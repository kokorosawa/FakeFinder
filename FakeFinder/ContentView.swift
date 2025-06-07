import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("FakeFinder")
                    .font(.largeTitle)
                    .bold()
                
                Text("Detect audio deepfakes\nand protect your voice.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    viewModel.navigateToRecording()
                }) {
                    Text("Get Started")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationDestination(isPresented: $viewModel.showingRecordingView) {
                RecordingView()
            }
        }
    }
}

#Preview {
    ContentView()
}
