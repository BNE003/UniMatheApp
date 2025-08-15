import SwiftUI

struct ConfettiView: View {
    @State private var animate = false
    @State private var finishedAnimationCouter = 0
    let finishedAnimationCouter2 = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece()
                    .opacity(animate ? 0 : 1)
                    .scaleEffect(animate ? 0 : 1)
                    .animation(
                        Animation
                            .easeInOut(duration: Double.random(in: 1.5...3.0))
                            .delay(Double.random(in: 0...0.5)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    @State private var location = CGPoint(x: 0, y: 0)
    @State private var opacity: Double = 1.0
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    let shapes = ["circle", "triangle", "square"]
    
    var body: some View {
        let randomColor = colors.randomElement() ?? .blue
        let randomShape = shapes.randomElement() ?? "circle"
        
        Group {
            if randomShape == "circle" {
                Circle()
                    .fill(randomColor)
                    .frame(width: CGFloat.random(in: 4...12), height: CGFloat.random(in: 4...12))
            } else if randomShape == "triangle" {
                Triangle()
                    .fill(randomColor)
                    .frame(width: CGFloat.random(in: 6...14), height: CGFloat.random(in: 6...14))
            } else {
                Rectangle()
                    .fill(randomColor)
                    .frame(width: CGFloat.random(in: 4...10), height: CGFloat.random(in: 4...10))
            }
        }
        .position(location)
        .opacity(opacity)
        .onAppear {
            // Random starting position at the top
            location = CGPoint(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: -20
            )
            
            // Animate to random position at the bottom
            withAnimation(
                Animation.easeIn(duration: Double.random(in: 2...4))
                    .delay(Double.random(in: 0...1))
            ) {
                location = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: UIScreen.main.bounds.height + 100
                )
                opacity = 0
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

#Preview {
    ConfettiView()
}