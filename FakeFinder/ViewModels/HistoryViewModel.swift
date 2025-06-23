import SwiftUI
import CoreData

class HistoryViewModel : ObservableObject {
    private let context: NSManagedObjectContext
    @Published var logs: [SubmitLog] = []

    // 移除預設值，強制要求傳入 context
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchLogs()
    }

    func fetchLogs() {
        let request: NSFetchRequest<SubmitLog> = SubmitLog.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SubmitLog.creatAt, ascending: false)]

        do {
            logs = try context.fetch(request)
        } catch {
            print("❌ 取得 SubmitLog 失敗：\(error.localizedDescription)")
        }
        for log in logs {
            print("Log: \(log.creatAt ?? Date()), Result: \(log.result), Score: \(log.score), Rate: \(log.rate), WAV ID: \(log.wavId ?? "")")
        }
    }

    func delete(log: SubmitLog) {
        context.delete(log)
        try? context.save()
        fetchLogs()
    }
}
