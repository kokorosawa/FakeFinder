//
//  PersistenceController.swift
//  FakeFinder
//
//  Created by 吳念澤 on 2025/6/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    // 用於 Preview 的實例
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        // 創建一些測試資料
        for i in 0..<5 {
            let log = SubmitLog(context: context)
            log.creatAt = Date().addingTimeInterval(TimeInterval(-i * 3600))
            log.result = i % 2 == 0
            log.score = Int16.random(in: 0...100)
            log.rate = Double.random(in: 0...1)
            log.wavId = "WAV\(String(format: "%04d", i))"
        }
        
        do {
            try context.save()
        } catch {
            print("Preview 資料創建失敗：\(error)")
        }
        
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("❌ Core Data 無法載入：\(error), \(error.userInfo)")
            }
        }
        
        // 設置自動合併變更
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
