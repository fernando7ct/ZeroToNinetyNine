import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Image("icon")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(.rect(cornerRadius: 12))
            
            Text("Welcome to Zero to Ninety Nine!")
                .font(.title2)
                .bold()
                .padding()
            
            Text("""
            🎯 Guess the Number:
            A random number between 0 and 99 will be generated. You have 5 attempts to guess it! After each guess, you'll be told whether the correct number is higher or lower.

            📊 Track Your Stats:
            View how many games you've played and how many you've won. See a bar chart that shows how many attempts it took to win each game.

            🏆 Leaderboard:
            The top 3 players based on total wins are displayed. Compete to become #1!
            """)
            .multilineTextAlignment(.leading)
            .fontWeight(.semibold)
            .font(.title3)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Continue")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        //.background(Color.background)
    }
}

#Preview {
    OnboardingView()
}
