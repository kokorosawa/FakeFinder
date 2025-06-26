import SwiftUI

struct ResultView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    let analysisResult: AnalysisResult?
    
    private var isSpoof: Bool {
        analysisResult?.isDeepfake ?? false
    }
    
    private var percentage: Int {
        analysisResult?.percentage ?? 0
    }
    
    private var confidenceLevel: String {
        switch percentage {
        case 0...30:
            return "LOW"
        case 31...70:
            return "MEDIUM"
        case 71...100:
            return "HIGH"
        default:
            return "UNKNOWN"
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("AUDIO ANALYSIS")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundColor(.cyan)
                .tracking(2)
            
            Text("NEURAL NETWORK CLASSIFICATION")
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundColor(.gray)
                .tracking(1)
        }
    }
    
    private var classificationSection: some View {
        HStack {
            Rectangle()
                .fill(isSpoof ? Color.red : Color.green)
                .frame(width: 4)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("CLASSIFICATION")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.gray)
                
                Text(isSpoof ? "SPOOF" : "BONAFIDE")
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(isSpoof ? .red : .green)
                    .tracking(2)
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSpoof ? Color.red.opacity(0.3) : Color.green.opacity(0.3), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.5))
                )
        )
    }
    
    private var confidenceSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("CONFIDENCE")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.gray)
                Spacer()
                Text(confidenceLevel)
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.cyan)
            }
            
            Text("\(percentage)%")
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .shadow(color: .cyan, radius: 10)
            
            GeometryReader { progressGeometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: progressGeometry.size.width * CGFloat(percentage) / 100, height: 8)
                        .shadow(color: .cyan, radius: 5)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
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
    
    private var infoSection: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: isSpoof ? "exclamationmark.triangle.fill" : "checkmark.shield.fill")
                    .font(.title2)
                    .foregroundColor(isSpoof ? .red : .green)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(isSpoof ? "SYNTHETIC AUDIO DETECTED" : "AUTHENTIC AUDIO DETECTED")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Text(isSpoof ? 
                         "This audio appears to be AI-generated or manipulated" :
                         "This audio appears to be genuine human speech")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.3))
                )
        )
    }
    
    private var actionButtons: some View {
        VStack(spacing: 15) {
            Button(action: {
                path.removeLast(1)
            }) {
                HStack {
                    Image(systemName: "arrow.left.circle")
                    Text("NEW ANALYSIS")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.cyan)
                        .shadow(color: .cyan.opacity(0.5), radius: 10)
                )
            }
            
            Button(action: {
                // TODO: 實作回報功能
            }) {
                HStack {
                    Image(systemName: "flag.circle")
                    Text("REPORT RESULT")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                }
                .foregroundColor(.cyan)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.3))
                        )
                )
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [.black, Color(.systemGray6).opacity(0.3), .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                Path { path in
                    let spacing: CGFloat = 30
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
                
                VStack(spacing: 30) {
                    headerSection
                    
                    VStack(spacing: 20) {
                        classificationSection
                        confidenceSection
                        infoSection
                    }
                    
                    Spacer()
                    
                    actionButtons
                }
                .padding(20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
        .onAppear {
            if isSpoof {
                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedback.impactOccurred()
            } else {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ResultView(
            path: .constant(NavigationPath()),
            analysisResult: AnalysisResult(percentage: 85, isDeepfake: true, score: 0.85)
        )
    }
}
