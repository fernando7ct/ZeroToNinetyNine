import SwiftUI
import SwiftData
import FirebaseCore

@main
struct ZeroToNinetyNineApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: Game.self)
    }
}
