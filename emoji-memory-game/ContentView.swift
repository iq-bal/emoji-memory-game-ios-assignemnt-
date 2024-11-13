import SwiftUI

struct ContentView: View {
    // Added two more emojis
    @State private var emojis = ["🐶", "🐱", "🐰", "🐯", "🐸", "🦁", "🦄", "🐨", "🐼", "🦄", "🐼", "🐨", "🦁", "🐱", "🐶", "🐰", "🐸", "🐯", "🌟", "🏆"]
    @State private var flippedIndices: Set<Int> = []
    @State private var matchedIndices: Set<Int> = []
    @State private var showWinAlert = false
    @State private var numFlips = 0
    
    var body: some View {
        ZStack {
            // Full-screen gradient background
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)  // Ensures the background covers the entire screen

            VStack {
                // Emoji above the title
                Text("🏆")
                    .font(.system(size: 70))
                    .padding(.top, 50)
                
                // Game Title
                Text("Memoji")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 0)
                
                // Grid View (Fixed grid for 4x5 layout now)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 5), spacing: 10) {
                    ForEach(0..<emojis.count, id: \.self) { index in
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(radius: 10)
                                .aspectRatio(1, contentMode: .fit) // Ensure square cells
                                .overlay(
                                    Text(self.flippedIndices.contains(index) || self.matchedIndices.contains(index) ? self.emojis[index] : "❓")
                                        .font(.system(size: 50))
                                        .foregroundColor(.purple)
                                )
                                .onTapGesture {
                                    flipCard(at: index)
                                }
                        }
                        .animation(.easeInOut(duration: 0.3), value: flippedIndices)
                    }
                }
                .padding(20)
                
                // Footer (Score & Reset)
                HStack {
                    // Styled Flip Counter with Left Margin
                    Text("Flips: \(numFlips)")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal,10)
                        .padding(.leading, 20) // Added left margin
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    
                    Spacer()
                    
                    Button(action: resetGame) {
                        Text("Reset")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.trailing, 20)
                    
                }
                .padding(.bottom, 30)
            }
        }
        .alert(isPresented: $showWinAlert) {
            Alert(
                title: Text("You Win!"),
                message: Text("Congratulations, you matched all emojis!"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // Function to flip a card
    func flipCard(at index: Int) {
        if flippedIndices.count == 2 || matchedIndices.contains(index) || flippedIndices.contains(index) {
            return
        }
        
        flippedIndices.insert(index)
        numFlips += 1
        
        if flippedIndices.count == 2 {
            checkForMatch()
        }
    }
    
    // Function to check if two flipped cards are a match
    func checkForMatch() {
        let flippedArray = Array(flippedIndices)
        let firstIndex = flippedArray[0]
        let secondIndex = flippedArray[1]
        
        if emojis[firstIndex] == emojis[secondIndex] {
            matchedIndices.insert(firstIndex)
            matchedIndices.insert(secondIndex)
            flippedIndices.removeAll()
            
            if matchedIndices.count == emojis.count {
                showWinAlert = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                flippedIndices.removeAll()
            }
        }
    }
    
    // Function to reset the game
    func resetGame() {
        emojis.shuffle()
        flippedIndices.removeAll()
        matchedIndices.removeAll()
        numFlips = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 Pro")
    }
}

