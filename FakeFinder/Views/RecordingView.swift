import SwiftUI
import CoreData
import UniformTypeIdentifiers

struct RecordingView: View {
    @Binding var path: NavigationPath
    @StateObject var viewModel: RecordingViewModel
    @State private var pulseAnimation = false
    
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
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 10) {
                            Text("AUDIO RECORDER")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.cyan)
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
                                .frame(maxWidth: 150)
                        }
                        .padding(.top, 20)
                        
                        // Recording button with cyber effects
                        ZStack {
                            // Outer glow ring
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: viewModel.isRecording ? [.red, .pink] : [.cyan, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                                .frame(width: 130, height: 130)
                                .opacity(0.6)
                                .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulseAnimation)
                            
                            // Inner recording button
                            Button(action: {
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                                viewModel.toggleRecording()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                colors: viewModel.isRecording ? [.red, .red.opacity(0.7)] : [.cyan, .blue],
                                                center: .center,
                                                startRadius: 20,
                                                endRadius: 50
                                            )
                                        )
                                        .frame(width: 100, height: 100)
                                        .shadow(
                                            color: viewModel.isRecording ? .red : .cyan,
                                            radius: 20
                                        )
                                    
                                    Image(systemName: viewModel.isRecording ? "stop.fill" : "mic")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.white)
                                        .shadow(color: .black, radius: 2)
                                }
                            }
                            .scaleEffect(viewModel.isRecording ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: viewModel.isRecording)
                        }
                        .onAppear {
                            pulseAnimation = true
                        }
                        
                        // Status indicator
                        HStack(spacing: 8) {
                            Circle()
                                .fill(viewModel.isRecording ? .red : .green)
                                .frame(width: 8, height: 8)
                                .opacity(0.8)
                                .animation(.easeInOut(duration: 0.5), value: viewModel.isRecording)
                            
                            Text(viewModel.isRecording ? "RECORDING..." : "READY")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(viewModel.isRecording ? .red : .green)
                                .tracking(1)
                        }
                        
                        // Playback section
                        if viewModel.showRecord {
                            VStack(spacing: 15) {
                                Text("PLAYBACK CONTROL")
                                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                                    .foregroundColor(.cyan)
                                    .tracking(1)
                                
                                HStack(spacing: 20) {
                                    Button(action: {
                                        viewModel.playPause()
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.black.opacity(0.7))
                                                .frame(width: 50, height: 50)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                                                )
                                            
                                            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.cyan)
                                        }
                                    }
                                    
                                    VStack(spacing: 5) {
                                        Slider(value: $viewModel.playbackProgress, in: 0...1, onEditingChanged: { isEditing in
                                            if isEditing {
                                                viewModel.pause()
                                            } else {
                                                viewModel.seekToProgress()
                                                viewModel.play()
                                            }
                                        })
                                        .accentColor(.cyan)
                                        .background(Color.black)
                                        
                                        Text("WAVEFORM")
                                            .font(.system(size: 8, weight: .medium, design: .monospaced))
                                            .foregroundColor(.gray)
                                            .tracking(1)
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.black.opacity(0.5))
                                    )
                            )
                        }
                        
                        // Input section
                        VStack(spacing: 15) {
                            Text("TEXT INPUT")
                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                .foregroundColor(.cyan)
                                .tracking(1)
                            
                            TextField("ENTER COMMAND TEXT", text: $viewModel.inputText)
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black.opacity(0.7))
                                        )
                                )
                                .textInputAutocapitalization(.never)
                        }
                        
                        // Action buttons
                        VStack(spacing: 15) {
                            // Generate button
                            Button(action: {
                                viewModel.generateAudio()
                            }) {
                                HStack {
                                    Image(systemName: "waveform.path.badge.plus")
                                    Text("GENERATE AUDIO")
                                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                                        .tracking(1)
                                }
                                .foregroundColor(viewModel.generateFinished ? .black : .gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(viewModel.generateFinished ? Color.cyan : Color.gray.opacity(0.3))
                                        .shadow(
                                            color: viewModel.generateFinished ? .cyan.opacity(0.5) : .clear,
                                            radius: viewModel.generateFinished ? 10 : 0
                                        )
                                )
                            }
                            .disabled(!viewModel.generateFinished)
                            
                            // Upload button
                            Button(action: {
                                viewModel.uploadAudio()
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up.circle")
                                    Text("UPLOAD AUDIO")
                                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                                        .tracking(1)
                                }
                                .foregroundColor(.cyan)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black.opacity(0.3))
                                        )
                                )
                            }
                            .fileImporter(
                                isPresented: $viewModel.isImporterShown,
                                allowedContentTypes: [UTType.audio],
                                allowsMultipleSelection: false
                            ) { result in
                                do {
                                    guard let selectedFile: URL = try result.get().first else { return }
                                    
                                    guard selectedFile.startAccessingSecurityScopedResource() else {
                                        print("❌ 無法訪問選中的文件")
                                        return
                                    }
                                    
                                    defer {
                                        selectedFile.stopAccessingSecurityScopedResource()
                                    }
                                    
                                    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                    let destinationURL = documentsPath.appendingPathComponent(selectedFile.lastPathComponent)
                                    
                                    if FileManager.default.fileExists(atPath: destinationURL.path) {
                                        try FileManager.default.removeItem(at: destinationURL)
                                    }
                                    
                                    try FileManager.default.copyItem(at: selectedFile, to: destinationURL)
                                    
                                    viewModel.uploadAudio(url: destinationURL)
                                    print("✅ 音頻文件上傳成功: \(selectedFile.lastPathComponent)")
                                } catch {
                                    print("⚠️ 無法上傳音頻文件: \(error.localizedDescription)")
                                }
                            }
                            
                            // Send button
                            Button(action: {
                                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                                impactFeedback.impactOccurred()
                                path.append("loading")
                                viewModel.submit()
                            }) {
                                HStack {
                                    Image(systemName: "paperplane.circle.fill")
                                    Text("INITIATE ANALYSIS")
                                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                                        .tracking(1)
                                }
                                .foregroundColor(viewModel.showRecord ? .black : .gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(viewModel.showRecord ? Color.cyan : Color.gray.opacity(0.3))
                                        
                                        if viewModel.showRecord {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        }
                                    }
                                )
                                .shadow(
                                    color: viewModel.showRecord ? .cyan.opacity(0.5) : .clear,
                                    radius: viewModel.showRecord ? 15 : 0
                                )
                            }
                            .disabled(!viewModel.showRecord)
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(20)
                }.scrollIndicators(.hidden)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        RecordingView(
            path: .constant(NavigationPath()),
            viewModel: RecordingViewModel(context: PersistenceController.shared.container.viewContext)
        )
    }
}
