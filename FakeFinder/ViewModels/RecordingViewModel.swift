import AVFoundation
import SwiftUI
import CoreData
#if canImport(UIKit)
import UIKit
#endif

class RecordingViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var showingLoadingView = false
    @Published var showRecord: Bool = false
    @Published var isPlaying: Bool = false
    @Published var playbackProgress: Double = 0.0
    @Published var isImporterShown = false

    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private let context: NSManagedObjectContext

    // 通過初始化器接收 context，不使用預設值
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func requestMicrophonePermission() {
        AVAudioApplication.requestRecordPermission { granted in
        }
    }

    func toggleRecording() {
        #if !targetEnvironment(simulator)
        requestMicrophonePermission()
        #endif
        
        let micPermissionStatus = AVAudioApplication.shared.recordPermission
        switch micPermissionStatus {
        case .granted:
            isRecording.toggle()
        default:
            #if canImport(UIKit)
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "麥克風權限未開啟", message: "請在設定中允許App存取麥克風以進行錄音。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default))
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let rootVC = scene.windows.first?.rootViewController
                {
                    rootVC.present(alert, animated: true)
                }
            }
            #else
            print("麥克風權限未開啟")
            #endif
        }

        if isRecording {
            setupRecorder()
            startRecording()
            self.pause()
        } else {
            stopRecording()
            showRecord = true
            loadAudio()
        }
    }

    func setupRecorder() {
        #if canImport(UIKit)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            try session.overrideOutputAudioPort(.speaker)
        } catch {
            print("音頻會話設定失敗：\(error)")
        }
        #endif
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]

        let fileName = "temp.m4a"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.prepareToRecord()
        } catch {
            print("錄音器初始化失敗：\(error)")
        }
    }

    func uploadAudio(url: URL) {
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("⚠️ 指定的音頻檔案不存在：\(url.path)")
            return
        }

        do {
            #if canImport(UIKit)
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            try session.overrideOutputAudioPort(.speaker)
            #endif
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1.0
            
            DispatchQueue.main.async {
                self.showRecord = true
                self.playbackProgress = 0.0
                self.isPlaying = false
            }
            
            print("✅ 音頻檔案載入成功，音頻會話已設置")
        } catch {
            print("❌ 播放器初始化失敗：\(error.localizedDescription)")
        }
    }

    func loadAudio() {
        guard let url = audioRecorder?.url else {
            print("⚠️ 無錄音檔可播放")
            return
        }

        print("✅ 嘗試載入音頻檔案：\(url.path)")
        

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1.0
        } catch {
            print("❌ 播放器初始化失敗：\(error.localizedDescription)")
        }

        DispatchQueue.main.async {
            self.showRecord = true
            self.playbackProgress = 0.0
            self.isPlaying = false
        }
    }

    func playPause() {
        guard let player = audioPlayer else { return }
        
        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopProgressTimer()
        } else {
            player.play()
            isPlaying = true
            startProgressTimer()
        }
    }

    func seekToProgress() {
        guard let player = audioPlayer else { return }
        
        let newTime = playbackProgress * player.duration
        player.currentTime = newTime
        
        if isPlaying {
            player.play()
        }
    }

    func play() {
        guard let player = audioPlayer else { return }
        
        if !player.isPlaying {
            player.play()
            isPlaying = true
            startProgressTimer()
        }
    }

    func pause() {
        guard let player = audioPlayer else { return }
        
        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopProgressTimer()
        }
    }

    private func startProgressTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
            DispatchQueue.main.async {
                self.progressTimer()
            }
        }
    }

    private func stopProgressTimer() {
        timer?.invalidate()
        timer = nil
    }

    func progressTimer() {
        guard let player = audioPlayer else { 
            stopProgressTimer()
            return 
        }
        
        guard player.isPlaying else {
            stopProgressTimer()
            return
        }
        
        playbackProgress = player.currentTime / player.duration
        if playbackProgress >= 1.0 {
            isPlaying = false
            playbackProgress = 0.0
            stopProgressTimer()
        }
    }

    func startRecording() {
        audioRecorder?.record()
    }

    func stopRecording() {
        audioRecorder?.stop()
    }

    func sendRecording() {
        showingLoadingView = true
    }

    func uploadAudio() {
        isImporterShown = true
    }

    func viewHistory() {
        // TODO: 實作查看歷史記錄功能
    }
    
    func submit() {
        let log = Submit(context: context)
        log.creatAt = Date()
        log.id = UUID()
        log.wavPath = audioPlayer?.url?.path()
        do {
            try context.save()
            print("儲存成功")
        } catch {
            print("儲存失敗：\(error)")
        }
    }
    
    deinit {
        stopProgressTimer()
    }
}
