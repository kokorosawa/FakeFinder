import SwiftUI

struct LoadingView: View {
    @StateObject private var viewModel = LoadingViewModel()
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(2)
            
            Text("Analyzing Recording...")
                .font(.title2)
                .padding(.top, 40)
            
            Text("Your recordings are not saved")
                .foregroundColor(.secondary)
                .padding(.top, 10)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $viewModel.showingResultView) {
            ResultView(path:$path,analysisResult: viewModel.analysisResult)
        }
        .onAppear {
            viewModel.startAnalysis()
        }
    }
}
