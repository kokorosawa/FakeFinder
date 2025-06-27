import SwiftUI

struct LoadingView: View {
    @Binding var path: NavigationPath
    @StateObject var viewModel: LoadingViewModel
    @State private var scanLineOffset: CGFloat = 0
    @State private var glitchOffset: CGFloat = 0
    @State private var loadingDots = ""
    @State private var currentStep = 0 // 添加當前步驟狀態
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Cyber background
                LinearGradient(
                    colors: [.black, Color(.systemGray6).opacity(0.2), .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Grid pattern overlay
                Path { path in
                    let spacing: CGFloat = 40
                    for i in stride(from: 0, through: geometry.size.width, by: spacing) {
                        path.move(to: CGPoint(x: i, y: 0))
                        path.addLine(to: CGPoint(x: i, y: geometry.size.height))
                    }
                    for i in stride(from: 0, through: geometry.size.height, by: spacing) {
                        path.move(to: CGPoint(x: 0, y: i))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: i))
                    }
                }
                .stroke(Color.cyan.opacity(0.1), lineWidth: 0.5)
                
                // Scanning line effect
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .cyan.opacity(0.8), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 2)
                    .offset(y: scanLineOffset)
                    .blur(radius: 1)
                    .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: scanLineOffset)
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Main loading indicator
                    VStack(spacing: 30) {
                        // Cyber loading spinner
                        ZStack {
                            // Outer rings
                            ForEach(0..<3) { i in
                                Circle()
                                    .stroke(
                                        AngularGradient(
                                            colors: [.cyan, .blue, .cyan.opacity(0.3), .cyan],
                                            center: .center
                                        ),
                                        lineWidth: 2
                                    )
                                    .frame(width: CGFloat(80 + i * 20))
                                    .rotationEffect(.degrees(Double(i * 120)))
                                    .animation(
                                        .linear(duration: 2 + Double(i)).repeatForever(autoreverses: false),
                                        value: scanLineOffset
                                    )
                            }
                            
                            // Center core
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [.cyan, .blue.opacity(0.5), .clear],
                                        center: .center,
                                        startRadius: 10,
                                        endRadius: 30
                                    )
                                )
                                .frame(width: 60)
                                .shadow(color: .cyan, radius: 20)
                            
                            // Waveform icon
                            Image(systemName: "waveform.path.ecg")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .cyan, radius: 5)
                        }
                        
                        // Status text
                        VStack(spacing: 15) {
                            Text("ANALYZING AUDIO\(loadingDots)")
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                                .foregroundColor(.cyan)
                                .tracking(2)
                                .shadow(color: .cyan, radius: 5)
                                .offset(x: glitchOffset)
                            
                            Text("NEURAL NETWORK PROCESSING")
                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                .foregroundColor(.gray)
                                .tracking(1)
                            
                            // Progress indicators - 依序完成
                            VStack(spacing: 8) {
                                // Step 1: SIGNAL DECODE
                                HStack(spacing: 15) {
                                    Text("SIGNAL DECODE")
                                    Spacer()
                                    if currentStep >= 1 {
                                        Text("✓")
                                            .foregroundColor(.green)
                                            .transition(.scale.combined(with: .opacity))
                                    } else {
                                        ProgressView()
                                            .scaleEffect(0.6)
                                            .tint(.cyan)
                                    }
                                }
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(currentStep >= 1 ? .green : .cyan)
                                
                                // Step 2: FEATURE EXTRACT
                                HStack(spacing: 15) {
                                    Text("FEATURE EXTRACT")
                                    Spacer()
                                    if currentStep >= 2 {
                                        Text("✓")
                                            .foregroundColor(.green)
                                            .transition(.scale.combined(with: .opacity))
                                    } else if currentStep == 1 {
                                        ProgressView()
                                            .scaleEffect(0.6)
                                            .tint(.cyan)
                                    } else {
                                        Text("...")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(currentStep >= 2 ? .green : (currentStep == 1 ? .cyan : .gray))
                                
                                // Step 3: AI CLASSIFICATION
                                HStack(spacing: 15) {
                                    Text("AI CLASSIFICATION")
                                    Spacer()
                                    if currentStep >= 3 {
                                        Text("✓")
                                            .foregroundColor(.green)
                                            .transition(.scale.combined(with: .opacity))
                                    } else if currentStep == 2 {
                                        ProgressView()
                                            .scaleEffect(0.6)
                                            .tint(.cyan)
                                    } else {
                                        Text("...")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(currentStep >= 3 ? .green : (currentStep == 2 ? .cyan : .gray))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.black.opacity(0.5))
                                    )
                            )
                        }
                    }
                    
                    Spacer()
                    
                    // Security notice
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "lock.shield")
                                .font(.system(size: 16))
                                .foregroundColor(.green)
                            
                            Text("SECURE PROCESSING")
                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                                .foregroundColor(.green)
                                .tracking(1)
                        }
                        
                        Text("AUDIO DATA IS NOT STORED OR TRANSMITTED")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(.gray)
                            .tracking(0.5)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 30)
                }
                .padding(30)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $viewModel.showingResultView) {
            ResultView(path: $path, analysisResult: viewModel.analysisResult)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            startAnimations()
            startProgressSequence() // 開始進度序列
            viewModel.startAnalysis()
        }
    }
    
    private func startAnimations() {
        // Scanning line animation
        scanLineOffset = -UIScreen.main.bounds.height / 2
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            scanLineOffset = UIScreen.main.bounds.height / 2
        }
        
        // Loading dots animation
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            switch loadingDots.count {
            case 0: loadingDots = "."
            case 1: loadingDots = ".."
            case 2: loadingDots = "..."
            default: loadingDots = ""
            }
        }
        
        // Glitch effect
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if Double.random(in: 0...1) < 0.1 {
                withAnimation(.easeInOut(duration: 0.05)) {
                    glitchOffset = Double.random(in: -2...2)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    withAnimation(.easeInOut(duration: 0.05)) {
                        glitchOffset = 0
                    }
                }
            }
        }
    }
    
    private func startProgressSequence() {
        // Step 1: SIGNAL DECODE (1秒後完成)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentStep = 1
            }
            
            // 觸覺反饋
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
        
        // Step 2: FEATURE EXTRACT (3秒後完成)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentStep = 2
            }
            
            // 觸覺反饋
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
        
        // Step 3: AI CLASSIFICATION (5秒後完成)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentStep = 3
            }
            
            // 觸覺反饋
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
}

#Preview {
    NavigationStack {
        LoadingView(
            path: .constant(NavigationPath()),
            viewModel: LoadingViewModel(context: PersistenceController.preview.container.viewContext)
        )
    }
}
