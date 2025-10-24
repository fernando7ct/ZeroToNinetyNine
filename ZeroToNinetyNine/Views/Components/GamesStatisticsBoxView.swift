import SwiftUI

struct GamesStatisticsBoxView: View {
    let description: String
    let value: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(description)
                .foregroundStyle(.secondary)
            Text(value, format: .number)
                .font(.title2)
        }
        .fontWeight(.semibold)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThickMaterial, in: .rect(cornerRadius: 12))
    }
}

#Preview {
    HStack(spacing: 10) {
        GamesStatisticsBoxView(description: "Games Played", value: 150)
        GamesStatisticsBoxView(description: "Games Won", value: 40)
    }
}
