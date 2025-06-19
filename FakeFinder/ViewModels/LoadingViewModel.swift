import SwiftUI

class LoadingViewModel: ObservableObject {
    @Published var showingResultView = false
    @Published var analysisResult: AnalysisResult?
    
    func startAnalysis() {
        // 模擬分析過程
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.analysisResult = AnalysisResult(percentage: 0, isDeepfake: false)
            self.showingResultView = true
        }
    }
}
