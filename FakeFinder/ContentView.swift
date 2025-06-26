import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var path = NavigationPath()
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        NavigationStack(path: $path) {
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
                    
                    // Glitch lines
                    VStack {
                        Rectangle()
                            .fill(Color.cyan.opacity(0.3))
                            .frame(height: 1)
                            .blur(radius: 1)
                        Spacer()
                        Rectangle()
                            .fill(Color.green.opacity(0.2))
                            .frame(height: 1)
                            .blur(radius: 1)
                    }
                    
                    VStack(spacing: 40) {
                        Spacer()
                        
                        // Logo section
                        VStack(spacing: 15) {
                            // Cyber logo
                            ZStack {
                                Circle()
                                    .stroke(Color.cyan.opacity(0.3), lineWidth: 2)
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "waveform.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.cyan)
                                    .shadow(color: .cyan, radius: 10)
                            }
                            
                            Text("FAKEFINDER")
                                .font(.system(size: 32, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .tracking(3)
                                .shadow(color: .cyan, radius: 5)
                            
                            Text("v2.0")
                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                                .foregroundColor(.cyan)
                                .tracking(2)
                        }
                        
                        // Description
                        VStack(spacing: 10) {
                            Text("NEURAL AUDIO AUTHENTICATION")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(.cyan)
                                .tracking(1)
                            
                            Text("DETECT • ANALYZE • PROTECT")
                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                .foregroundColor(.gray)
                                .tracking(2)
                            
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [.clear, .cyan, .clear],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 1)
                                .frame(maxWidth: 200)
                        }
                        
                        Spacer()
                        
                        // Action buttons
                        VStack(spacing: 20) {
                            // Primary button - 移除 scaleEffect 和 animation
                            Button(action: {
                                path.append("record")
                            }) {
                                HStack {
                                    Image(systemName: "play.circle.fill")
                                        .font(.title2)
                                    Text("INITIATE SCAN")
                                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                                        .tracking(1)
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.cyan)
                                        
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    }
                                )
                                .shadow(color: .cyan.opacity(0.5), radius: 15)
                            }
                            
                            // Secondary button
                            Button(action: {
                                path.append("history")
                            }) {
                                HStack {
                                    Image(systemName: "clock.arrow.circlepath")
                                        .font(.title3)
                                    Text("ACCESS HISTORY")
                                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                                        .tracking(1)
                                }
                                .foregroundColor(.cyan)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black.opacity(0.3))
                                        )
                                )
                            }
                            
                            // Status indicator - 只改變透明度，不移動
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 8, height: 8)
                                    .opacity(0.8)
                                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: 0.8)
                                
                                Text("SYSTEM ONLINE")
                                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                                    .foregroundColor(.green)
                                    .tracking(1)
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer()
                        
                        // Footer
                        VStack(spacing: 5) {
                            Text("POWERED BY NEURAL NETWORKS")
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundColor(.gray)
                                .tracking(1)
                            
                            HStack(spacing: 15) {
                                Text("SECURE")
                                Text("•")
                                Text("REAL-TIME")
                                Text("•")
                                Text("ACCURATE")
                            }
                            .font(.system(size: 8, weight: .medium, design: .monospaced))
                            .foregroundColor(.cyan.opacity(0.7))
                            .tracking(1)
                        }
                    }
                    .padding(30)
                }
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case "record":
                    RecordingView(path: $path, viewModel: RecordingViewModel(context: context))
                        .navigationTitle("")
                        .navigationBarTitleDisplayMode(.inline)
                case "loading":
                    LoadingView(path:$path, viewModel: LoadingViewModel(context: context))
                        .navigationTitle("")
                        .navigationBarTitleDisplayMode(.inline)
                case "history":
                    HistoryView(path: $path, viewModel: HistoryViewModel(context: context))
                        .toolbarBackground(.hidden, for: .navigationBar)
                
                default:
                    Text("Unknown destination")
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            // Add subtle vibration when app loads
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
