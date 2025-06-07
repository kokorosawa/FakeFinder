import SwiftUI

struct ResultView: View {
    @Environment(\.dismiss) private var dismiss
    let analysisResult: AnalysisResult?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Analysis Result")
                .font(.largeTitle)
            
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
            
            Text("\(analysisResult?.percentage ?? 0)%")
                .font(.system(size: 60, weight: .bold))
            
            Text("Likely Deepfake")
                .font(.title2)
            
            Text("The audio is likely to be an\nAI-generated synthetic speech.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Play Original") {
                // TODO: 實作播放原始音檔
            }
            .padding(.top)
            
            Button("Report False Positive") {
                // TODO: 實作回報誤判
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        
    }
}