import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    private init() {
        let schema = Schema([Game.self])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            insertSampleData()
            
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func insertSampleData() {
        context.insert(Game(attempts: [1], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1, 2, 3], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1, 2, 3], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1, 2, 3, 4], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1, 2, 3, 4, 5], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1, 2, 3, 4, 5], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1, 2, 3, 4, 5], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1, 2, 3, 4, 5], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1, 2, 3, 4, 5], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1, 2, 3, 4, 5], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1, 2, 3, 4, 5], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1, 2, 3, 4, 5], gameOver: true, playerWon: true))
        context.insert(Game(attempts: [1, 2, 3, 4, 5], gameOver: true, playerWon: true))
    }
}
