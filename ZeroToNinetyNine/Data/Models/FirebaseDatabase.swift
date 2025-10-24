import Foundation
import FirebaseFirestore

@Observable class FirebaseDatabase {
    static let shared = FirebaseDatabase()
    private let db = Firestore.firestore()
    
    var topPlayers: [Player] = []
    var loading: Bool = true
    
    private init() {}
    
    func fetchTopPlayers() {
        loading = true
        db.collection("players").order(by: "gamesWon", descending: true).limit(to: 3).getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("Error fetching top players: \(error!)")
                return
            }
            self.topPlayers = querySnapshot?.documents.compactMap { document in
                let data = document.data()
                guard
                    let id = data["id"] as? String,
                    let gamesWon = data["gamesWon"] as? Int
                else {
                    return nil
                }
                self.loading = false
                return Player(id: id, gamesWon: gamesWon)
            } ?? []
        }
    }
    
    func updateStats(id: String, gamesWon: Int) {
        let data: [String: Any] = [
            "id": id,
            "gamesWon": gamesWon
        ]
        
        db.collection("players").document(id).setData(data)
    }
}
