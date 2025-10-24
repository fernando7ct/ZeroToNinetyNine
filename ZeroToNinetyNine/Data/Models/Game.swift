import Foundation
import SwiftData

@Model
class Game {
    var id: UUID = UUID()
    var randomNumber: Int = Int.random(in: 0...99)
    var attempts: [Int] = []
    var gameOver: Bool = false
    var playerWon: Bool = false
    
    init(id: UUID = UUID(), randomNumber: Int = Int.random(in: 0...99), attempts: [Int] = [], gameOver: Bool = false, playerWon: Bool = false) {
        self.id = id
        self.randomNumber = randomNumber
        self.attempts = attempts
        self.gameOver = gameOver
        self.playerWon = playerWon
    }
    
    init(oldGame: Game) {
        randomNumber = oldGame.randomNumber
        attempts = oldGame.attempts
        gameOver = oldGame.gameOver
        playerWon = oldGame.playerWon
    }
    
    func resetGame() {
        randomNumber = Int.random(in: 0...99)
        attempts = []
        gameOver = false
        playerWon = false
    }
}
