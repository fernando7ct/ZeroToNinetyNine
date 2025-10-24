import SwiftUI
import Charts

struct GamesWonChartView: View {
    let games: [Game]
    @State private var selectedIndex: Int? = nil
    
    var graphData: [Int] {
        var data: [Int] = [0, 0, 0, 0, 0]
        for game in games {
            data[game.attempts.count - 1] += 1
        }
        return data
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text(selectedIndex == nil ? "Games Won By Attempt" : " ")
                .font(.title3)
                .fontWeight(.semibold)
            
            Chart {
                ForEach(0..<graphData.count, id: \.self) { index in
                    BarMark(x: .value("Attempts", index + 1), yStart: .value("Games Won", 0), yEnd: .value("Games Won", graphData[index]), width: 55)
                        .foregroundStyle(Color.accentColor)
                    
                    if let selectedIndex, selectedIndex > 0, selectedIndex < 6 {
                        RuleMark(x: .value("Attempts", selectedIndex))
                            .foregroundStyle(Color.accentColor)
                            .annotation(position: .top) {
                                Text("You have won \(graphData[selectedIndex - 1]) \(graphData[selectedIndex - 1] == 1 ? "game" : "games") in \(selectedIndex) \(selectedIndex == 1 ? "attempt" : "attempts").")
                                    .multilineTextAlignment(.leading)
                                    .padding()
                                    .frame(width: 120)
                                    .background(Color.accentColor, in: .rect(cornerRadius: 12))
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                            }
                    }
                }
            }
            .chartLegend(.hidden)
            .chartXScale(domain: 0.5...5.5)
            .chartYScale(domain: 0...(graphData.max()! + 1))
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisValueLabel()
                        .offset(x: -10)
                }
            }
            .chartXSelection(value: $selectedIndex)
        }
        .padding()
    }
}

#Preview {
    GamesWonChartView(games: [])
}
