import SwiftUI
import CoreData

class LoadingViewModel: ObservableObject {
    @Published var showingResultView = false
    @Published var analysisResult: AnalysisResult?
    private let context: NSManagedObjectContext
    var wavname: String = ""
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func startAnalysis() {
        // 模擬分析過程
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.classify()
            self.showingResultView = true
        }
    }
    
    func getSubmitFile() -> String {
        let request: NSFetchRequest<Submit> = Submit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Submit.createdAt, ascending: false)]
        let fetchResult = try? context.fetch(request)
        let wavPath = fetchResult?.first?.wavPath ?? ""
        for submit in fetchResult ?? [] {
            print(submit.createdAt)
            print(submit.id)
            print(submit.wavPath)
        }

        for submit in fetchResult ?? [] {
            context.delete(submit)
        }
        try? context.save()

        return wavPath
    }

    func classify() {
        let wavPath = getSubmitFile()
        
        let decodedPath = wavPath.removingPercentEncoding ?? wavPath
        self.wavname = decodedPath.components(separatedBy: "/").last ?? "unknown.wav"
        print("📂 解碼後的路徑: \(decodedPath)")
        
        guard !decodedPath.isEmpty,
              let url = URL(string: "https://classifier.kokoro44.com/classify"),
              let audioData = try? Data(contentsOf: URL(fileURLWithPath: decodedPath)) else {
            print("Failed to load audio file or invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // 第一部分：音頻文件
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"audio_file\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("kokoro44/fakefinder-2024-10-01".data(using: .utf8)!)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!) 
        
        request.httpBody = body
        
        print("🌐 發送請求到: \(url.absoluteString)")
        print("📦 請求大小: \(body.count) bytes")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: [])
                print("Classification result: \(result)")
                if let json = result as? [String: Any] {
                    let prediction = json["prediction"] as? String ?? "unknown"
                    let confidence = (json["confidence"] as? Int) ?? 0
                    let score = (json["score"] as? Double) ?? 0.0

                    print("✅ 預測結果：\(prediction)")
                    print("🔍 信心指數：\(confidence)")
                    print("🔍 分數：\(score)")

                    self.analysisResult = AnalysisResult(
                        percentage: confidence,
                        isDeepfake: prediction == "spoof",
                        score: score
                    )
                    self.submitHistory()
                } else {
                    print("❌ 無法轉為 [String: Any]")
                }
               
            } catch {
                print("JSON parsing error: \(error)")
            }
        }.resume()
    }

    func submitHistory() {
        guard let result = analysisResult else {
            print("❌ 無法提交歷史記錄，分析結果為 nil")
            return
        }
        
        let submitLog = SubmitLog(context: context)
        submitLog.createdAt = Date()
        submitLog.result = result.isDeepfake ? false : true
        submitLog.score = Int16(result.percentage)
        submitLog.rate = result.score
        submitLog.id = UUID()
        submitLog.wavId = self.wavname

        
        do {
            try context.save()
            print("✅ 歷史記錄已提交")
        } catch {
            print("❌ 提交歷史記錄失敗：\(error.localizedDescription)")
        }
    }
}
