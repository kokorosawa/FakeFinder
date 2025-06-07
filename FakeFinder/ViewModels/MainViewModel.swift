import SwiftUI
import AVFoundation

class MainViewModel: ObservableObject {
    @Published var showingRecordingView = false
    
    func navigateToRecording() {
        showingRecordingView = true
    }
    
    func showLearnMore() {
        // TODO: 實作學習更多功能
    }
}