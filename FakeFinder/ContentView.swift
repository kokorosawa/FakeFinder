import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Text("FakeFinder")
                    .font(.largeTitle)
                    .bold()
                
                Text("Detect audio deepfakes\nand protect your voice.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    path.append("record")
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
            .navigationDestination(for: String.self) { value in
                switch value {
                case "record":
                    RecordingView(path: $path)
                        .navigationTitle("")
                        .navigationBarTitleDisplayMode(.inline)
                case "loading":
                    LoadingView(path:$path)
                        .navigationTitle("")
                        .navigationBarTitleDisplayMode(.inline)
                
                default:
                    Text("Unknown destination")
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
