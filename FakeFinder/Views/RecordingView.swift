import SwiftUI
import UniformTypeIdentifiers

struct RecordingView: View {
    @StateObject private var viewModel = RecordingViewModel()
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.toggleRecording()
            }) {
                Circle()
                    .fill(viewModel.isRecording ? Color.red : Color.blue)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: viewModel.isRecording ? "stop.fill" : "mic")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    )
            }
            .scaleEffect(viewModel.isRecording ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: viewModel.isRecording)

            if viewModel.showRecord {
                HStack {
                    Button(action: {
                        viewModel.playPause()
                    }) {
                        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                    
                    Slider(value: $viewModel.playbackProgress, in: 0...1)
                        .accentColor(.blue)
                    
                }
                .padding()
            } 
            
            Button("Send") {
                viewModel.sendRecording()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.showRecord ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top)
            .disabled(!viewModel.showRecord)
            
            Button("Upload Audio") {
                viewModel.uploadAudio()
            }
            .padding()
            .fileImporter(
                isPresented: $viewModel.isImporterShown,
                allowedContentTypes: [UTType.audio],
                allowsMultipleSelection: false
            ){ result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    
                    // 重要：開始訪問安全範圍的資源
                    guard selectedFile.startAccessingSecurityScopedResource() else {
                        print("❌ 無法訪問選中的文件")
                        return
                    }
                    
                    defer {
                        // 確保在方法結束時停止訪問
                        selectedFile.stopAccessingSecurityScopedResource()
                    }
                    
                    // Copy file to app's documents directory
                    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationURL = documentsPath.appendingPathComponent(selectedFile.lastPathComponent)
                    
                    // Remove existing file if it exists
                    if FileManager.default.fileExists(atPath: destinationURL.path) {
                        try FileManager.default.removeItem(at: destinationURL)
                    }
                    
                    // Copy the file
                    try FileManager.default.copyItem(at: selectedFile, to: destinationURL)
                    
                    viewModel.uploadAudio(url: destinationURL)
                    print("✅ 音頻文件上傳成功: \(selectedFile.lastPathComponent)")
                } catch {
                    print("⚠️ 無法上傳音頻文件: \(error.localizedDescription)")
                }
            }

            Button("View History") {
                viewModel.viewHistory()
            }
            .padding()
        }
        .padding()
        .navigationTitle("Recording")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.showingLoadingView) {
            LoadingView()
        }
    }
}

#Preview() {
    RecordingView();
}
