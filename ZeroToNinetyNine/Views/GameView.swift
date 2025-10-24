import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var game: Game
    
    @State private var showQuitAlert: Bool = false
    @State private var guess: String = ""
    @State private var animatingNumber: Int = Int.random(in: 0...99)
    @State private var timer: Timer? = nil
    @State private var guessingRange: [Int] = [0, 99]
    @State private var showGuessAlert: Bool = false
    
    var body: some View {
        VStack {
            Text(animatingNumber, format: .number)
                .font(.largeTitle)
                .bold()
                .contentTransition(.numericText())
            
            Spacer()
            
            VStack(spacing: 40) {
                ForEach(0...4, id: \.self) { index in
                    HStack {
                        if game.attempts.indices.contains(index) {
                            let guess = game.attempts[index]
                            
                            Text(guess, format: .number)
                            
                            Spacer()
                            
                            if guess > game.randomNumber {
                                Label("Lower", systemImage: "arrow.down")
                                    .foregroundStyle(.red)
                            } else if guess < game.randomNumber {
                                Label("Higher", systemImage: "arrow.up")
                                    .foregroundStyle(.red)
                            } else {
                                Label("Correct", systemImage: "checkmark")
                                    .foregroundStyle(.green)
                            }
                        } else {
                            Text("_ _")
                            
                            Spacer()
                        }
                    }
                    .font(.largeTitle)
                    .bold()
                }
            }
            
            Spacer()
            
            if !game.gameOver {
                HStack {
                    TextField("Enter your guess", text: $guess)
                        .keyboardType(.numberPad)
                    
                    Button {
                        tryGuess()
                    } label: {
                        Label("Send Guess", systemImage: "arrow.right")
                            .labelStyle(.iconOnly)
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                    .disabled(guess.isEmpty)
                }
                .font(.title2)
                .fontWeight(.semibold)
                .confirmationDialog("Are you sure you want to submit this guess? You are trying to guess \(guess) but have already been told it is \((Int(guess) ?? 0) > guessingRange[1] ? "lower than \(guessingRange[1] + 1)" : "higher than \(guessingRange[0] - 1)").", isPresented: $showGuessAlert, titleVisibility: .visible) {
                    Button("Cancel", role: .cancel) {
                        showGuessAlert = false
                    }
                    Button("Yes") {
                        tryGuess()
                    }
                }
            } else {
                VStack(spacing: 10) {
                    Button {
                        resetGame()
                    } label: {
                        Text("Play Again")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topLeading) {
            if !game.gameOver {
                Button(role: .destructive) {
                    if game.attempts.isEmpty {
                        quitGame()
                    } else {
                        showQuitAlert = true
                    }
                } label: {
                    Label("Quit Game", systemImage: "xmark")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                        .bold()
                        .padding(6)
                }
                .buttonBorderShape(.circle)
                .buttonStyle(.bordered)
                .padding()
            }
        }
        .alert("Quit Game", isPresented: $showQuitAlert) {
            Button("Cancel", role: .cancel) {
                showQuitAlert = false
            }
            Button("Quit", role: .destructive, action: quitGame)
        } message: {
            Text("Are you sure you want to quit the game? All progress will be lost.")
        }
        .onChange(of: guess) { oldValue, newValue in
            guard let guessInt = Int(guess) else {
                guess = ""
                return
            }
            if guessInt > 99 {
                guess = oldValue
            }
        }
        .onAppear(perform: startTimer)
        .background(Color.background)
    }
    
    private func quitGame() {
        timer?.invalidate()
        modelContext.delete(game)
        dismiss()
    }
    
    private func tryGuess() {
        guard let guessInt = Int(guess) else { return }
        
        if (guessInt > guessingRange[1] || guessInt < guessingRange[0]) && !showGuessAlert {
            showGuessAlert = true
            return
        }
        
        game.attempts.append(guessInt)
        guess.removeAll()
        
        if guessInt == game.randomNumber {
            withAnimation {
                game.gameOver = true
                game.playerWon = true
                animatingNumber = game.randomNumber
            }
        } else if game.attempts.count > 4 {
            withAnimation {
                game.gameOver = true
                animatingNumber = game.randomNumber
            }
        }
        
        if game.randomNumber < guessInt {
            guessingRange[1] = guessInt - 1
        } else if game.randomNumber > guessInt {
            guessingRange[0] = guessInt + 1
        }
        
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { t in
            if !game.gameOver {
                withAnimation {
                    animatingNumber = Int.random(in: 0...99)
                }
            } else {
                withAnimation {
                    animatingNumber = game.randomNumber
                    timer?.invalidate()
                }
            }
        }
    }
    
    private func resetGame() {
        let finishedGame = Game(oldGame: game)
        modelContext.insert(finishedGame)
        withAnimation {
            game.resetGame()
            startTimer()
        }
        guessingRange = [0, 99]
    }
}

#Preview {
    @Previewable @State var game: Game = Game()
    
    GameView(game: game)
        .modelContainer(for: Game.self, inMemory: true)
}
