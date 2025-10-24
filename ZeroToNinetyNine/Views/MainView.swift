import SwiftUI
import SwiftData

struct MainView: View {
    @AppStorage("userID") private var userID: String = ""
    @Environment(\.modelContext) private var modelContext
    @Query private var games: [Game]
    @Namespace private var animation
    
    @State private var database: FirebaseDatabase = FirebaseDatabase.shared
    @State private var game: Game? = nil
    @State private var showOnboardingSheet: Bool = false
    
    var gamesPlayed: Int {
        games.filter({ $0.gameOver }).count
    }
    
    var gamesWon: Int {
        games.filter({ $0.playerWon }).count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Zero To Ninety-Nine")
                .font(.title)
                .bold()
                .padding(.bottom)
            
            Text("Stats")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
            
            HStack(spacing: 10) {
                GamesStatisticsBoxView(description: "Games Played", value: games.filter({ $0.gameOver }).count)
                GamesStatisticsBoxView(description: "Games Won", value: games.filter({ $0.playerWon }).count)
            }
            .padding(.bottom, 8)
            
            Group {
                if gamesWon == 0 {
                    ContentUnavailableView("No Games Won", systemImage: "gamecontroller", description: Text("You have yet to win any games. When you do more statistics will be available."))
                } else {
                    GamesWonChartView(games: games.filter({ $0.playerWon }))
                }
            }
            .frame(height: 300)
            .background(.ultraThickMaterial, in: .rect(cornerRadius: 12))
            .padding(.bottom)
            
            Text("Leaderboard")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
            
            VStack(spacing: 7) {
                if database.loading {
                    ProgressView()
                } else {
                    ForEach(Array(database.topPlayers.enumerated()), id: \.element.id) { index, player in
                        HStack {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(index == 0 ? .yellow : index == 1 ? .gray : Color(red: 205/255, green: 127/255, blue: 50/255))
                                .overlay {
                                    Text("\(index + 1)")
                                        .font(.callout)
                                        .bold()
                                }
                            
                            Spacer()
                            
                            Text("\(player.gamesWon) \(player.gamesWon == 1 ? "Game" : "Games") Won")
                                .font(.title3)
                        }
                        .fontWeight(.semibold)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(.ultraThickMaterial, in: .rect(cornerRadius: 12))
            
            Spacer()
            
            Button {
                startNewGame()
            } label: {
                Label("Start New Game", systemImage: "plus")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
            .matchedTransitionSource(id: "startNewGame", in: animation)
        }
        .padding()
        .fullScreenCover(item: $game) {
            GameView(game: $0)
                .navigationTransition(.zoom(sourceID: "startNewGame", in: animation))
                .interactiveDismissDisabled()
        }
        .onAppear {
            if userID.isEmpty {
                showOnboardingSheet = true
            } else {
                checkForUnfinishedGame()
                database.updateStats(id: userID, gamesWon: gamesWon)
                database.fetchTopPlayers()
            }
        }
        .sheet(isPresented: $showOnboardingSheet) {
            userID = UUID().uuidString
            database.fetchTopPlayers()
        } content: {
            OnboardingView()
                .interactiveDismissDisabled()
        }
        .background(Color.background)
    }
    
    private func startNewGame() {
        let newGame = Game()
        modelContext.insert(newGame)
        game = newGame
    }
    
    private func checkForUnfinishedGame() {
        if let unfinishedGame = games.first(where: { !$0.gameOver }) {
            game = unfinishedGame
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: Game.self, inMemory: true)
}

#Preview("Sample Data") {
    MainView()
        .modelContainer(SampleData.shared.modelContainer)
}
