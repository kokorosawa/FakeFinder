import SwiftUI

struct CardView: View {
    var time: Date = Date()
    var wavId: String = "1234567890"
    var score: Int = 0
    var result: Bool = true
    
    
    var body: some View {
        VStack(spacing: 12) {
            // Header with status
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(result ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                        .shadow(color: result ? .green : .red, radius: 4)
                    
                    Text(result ? "AUTHENTIC" : "DEEPFAKE")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(result ? .green : .red)
                }
                
                Spacer()
                
                Text("\(score)%")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.cyan)
            }
            
            // Wave ID section
            VStack(alignment: .leading, spacing: 4) {
                Text("WAVE ID")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundColor(.gray)
                
                Text(wavId)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.black.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
            
            // Timestamp
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.cyan)
                    .font(.system(size: 12))
                
                Text(time.formatted())
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.gray)
                
                Spacer()
                
                // Cyber decoration
                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.cyan.opacity(0.6))
                            .frame(width: 2, height: 8)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.8),
                            Color.gray.opacity(0.2)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.cyan.opacity(0.5),
                                    Color.blue.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .cyan.opacity(0.3), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

//#Preview {
//    CardView(time: "2023-10-01 12:00", wavId: "1234567890", score: 87, result: true)
//}
