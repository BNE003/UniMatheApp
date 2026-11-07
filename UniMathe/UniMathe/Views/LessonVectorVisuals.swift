//
//  LessonVectorVisuals.swift
//  UniMathe
//
//  Kleine, rein erklärende Animationen für die Schritt-für-Schritt-Lektionen.
//  Ein Lernschritt kann über das optionale JSON-Feld "visual" eine dieser
//  Animationen einbinden. Jede Animation läuft in wenigen Phasen ab; zu jeder
//  Phase gibt es eine Bildunterschrift, die erklärt, was mathematisch passiert.
//

import SwiftUI

// MARK: - Einstiegspunkt

struct LessonVisualView: View {
    let kind: String

    var body: some View {
        switch kind {
        case "vectorAddition": VectorAdditionVisual()
        case "subspaceClosure": SubspaceClosureVisual()
        case "linearCombination": LinearCombinationVisual()
        case "spanGrowth": SpanGrowthVisual()
        case "linearDependence": LinearDependenceVisual()
        case "basisCoordinates": BasisCoordinatesVisual()
        default: EmptyView()
        }
    }
}

// MARK: - Koordinatensystem

/// Ausschnitt der Ebene, der im Bild gezeigt wird (mathematische Koordinaten).
struct PlaneWindow {
    let xMin: CGFloat
    let xMax: CGFloat
    let yMin: CGFloat
    let yMax: CGFloat

    func point(_ p: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: (p.x - xMin) / (xMax - xMin) * size.width,
            y: size.height - (p.y - yMin) / (yMax - yMin) * size.height
        )
    }

    var diagonal: CGFloat {
        sqrt(pow(xMax - xMin, 2) + pow(yMax - yMin, 2))
    }
}

private enum VisualColor {
    static let first = Color.appAccentBlue
    static let second = Color.orange
    static let result = Color.green
    static let warning = Color.red
    static let extra = Color.purple
}

/// Pfeil von `from` nach `to` (mathematische Koordinaten); Start und Ziel sind animierbar.
struct VectorArrowShape: Shape {
    var from: CGPoint
    var to: CGPoint
    let window: PlaneWindow

    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
        get { AnimatablePair(AnimatablePair(from.x, from.y), AnimatablePair(to.x, to.y)) }
        set {
            from = CGPoint(x: newValue.first.first, y: newValue.first.second)
            to = CGPoint(x: newValue.second.first, y: newValue.second.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        let a = window.point(from, in: rect.size)
        let b = window.point(to, in: rect.size)
        var path = Path()
        path.move(to: a)
        path.addLine(to: b)

        let dx = b.x - a.x
        let dy = b.y - a.y
        let length = sqrt(dx * dx + dy * dy)
        guard length > 2 else { return path }

        let back = CGPoint(x: -dx / length, y: -dy / length)
        let head = min(11, length * 0.45)
        for angle in [CGFloat.pi / 7, -CGFloat.pi / 7] {
            let rx = back.x * cos(angle) - back.y * sin(angle)
            let ry = back.x * sin(angle) + back.y * cos(angle)
            path.move(to: b)
            path.addLine(to: CGPoint(x: b.x + head * rx, y: b.y + head * ry))
        }
        return path
    }
}

/// Gerade durch `through` mit Richtung `direction`. Mit `.trim` wächst sie von `through` aus nach beiden Seiten.
struct PlaneLineShape: Shape {
    let through: CGPoint
    let direction: CGPoint
    let window: PlaneWindow

    func path(in rect: CGRect) -> Path {
        let norm = sqrt(direction.x * direction.x + direction.y * direction.y)
        guard norm > 0 else { return Path() }
        let t = window.diagonal * 1.5 / norm
        let start = CGPoint(x: through.x - t * direction.x, y: through.y - t * direction.y)
        let end = CGPoint(x: through.x + t * direction.x, y: through.y + t * direction.y)
        var path = Path()
        path.move(to: window.point(start, in: rect.size))
        path.addLine(to: window.point(end, in: rect.size))
        return path
    }
}

/// Schiefes Gitter aus den ganzzahligen Linearkombinationen zweier Vektoren.
struct SkewGridShape: Shape {
    let a: CGPoint
    let b: CGPoint
    let window: PlaneWindow

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for k in -8...8 {
            let k = CGFloat(k)
            path.addPath(PlaneLineShape(through: CGPoint(x: k * a.x, y: k * a.y), direction: b, window: window).path(in: rect))
            path.addPath(PlaneLineShape(through: CGPoint(x: k * b.x, y: k * b.y), direction: a, window: window).path(in: rect))
        }
        return path
    }
}

private struct CoordinateGrid: View {
    let window: PlaneWindow

    var body: some View {
        Canvas { context, size in
            let minX = Int(window.xMin.rounded(.up))
            let maxX = Int(window.xMax.rounded(.down))
            let minY = Int(window.yMin.rounded(.up))
            let maxY = Int(window.yMax.rounded(.down))

            var grid = Path()
            for x in minX...maxX {
                grid.move(to: window.point(CGPoint(x: CGFloat(x), y: window.yMin), in: size))
                grid.addLine(to: window.point(CGPoint(x: CGFloat(x), y: window.yMax), in: size))
            }
            for y in minY...maxY {
                grid.move(to: window.point(CGPoint(x: window.xMin, y: CGFloat(y)), in: size))
                grid.addLine(to: window.point(CGPoint(x: window.xMax, y: CGFloat(y)), in: size))
            }
            context.stroke(grid, with: .color(.secondary.opacity(0.15)), lineWidth: 0.5)

            var axes = Path()
            axes.move(to: window.point(CGPoint(x: window.xMin, y: 0), in: size))
            axes.addLine(to: window.point(CGPoint(x: window.xMax, y: 0), in: size))
            axes.move(to: window.point(CGPoint(x: 0, y: window.yMin), in: size))
            axes.addLine(to: window.point(CGPoint(x: 0, y: window.yMax), in: size))
            context.stroke(axes, with: .color(.secondary.opacity(0.55)), lineWidth: 1)
        }
    }
}

// MARK: - Bausteine zum Zeichnen innerhalb einer Abbildung

private struct Arrow: View {
    let from: CGPoint
    let to: CGPoint
    let color: Color
    let window: PlaneWindow
    var width: CGFloat = 3
    var dashed = false

    var body: some View {
        VectorArrowShape(from: from, to: to, window: window)
            .stroke(color, style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round, dash: dashed ? [5, 5] : []))
    }
}

private struct MathLabel: View {
    let text: String
    let at: CGPoint
    let color: Color
    let window: PlaneWindow
    let size: CGSize
    var offset = CGSize(width: 12, height: -10)

    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold, design: .serif))
            .italic()
            .foregroundColor(color)
            .padding(.horizontal, 3)
            .background(Color.appSurfaceStrong.opacity(0.75).cornerRadius(4))
            .position(window.point(at, in: size))
            .offset(offset)
    }
}

private struct Dot: View {
    let at: CGPoint
    let color: Color
    let window: PlaneWindow
    let size: CGSize
    var hollow = false

    var body: some View {
        Group {
            if hollow {
                Circle().stroke(color, style: StrokeStyle(lineWidth: 2, dash: [3, 3]))
            } else {
                Circle().fill(color)
            }
        }
        .frame(width: 10, height: 10)
        .position(window.point(at, in: size))
    }
}

// MARK: - Rahmen: Phasensteuerung, Bildunterschrift, Wiederholen

private struct AnimatedFigure<Content: View>: View {
    let window: PlaneWindow
    let captions: [String]
    let content: (Int, CGSize) -> Content

    @State private var phase = 0
    @State private var runID = 0

    init(window: PlaneWindow, captions: [String], @ViewBuilder content: @escaping (Int, CGSize) -> Content) {
        self.window = window
        self.captions = captions
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader { geo in
                ZStack {
                    CoordinateGrid(window: window)
                    content(phase, geo.size)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            HStack(spacing: 4) {
                ForEach(captions.indices, id: \.self) { i in
                    Capsule()
                        .fill(i <= phase ? Color.appAccentBlue : Color.secondary.opacity(0.25))
                        .frame(height: 4)
                }
            }

            HStack(alignment: .top, spacing: 8) {
                Text(captions[min(phase, captions.count - 1)])
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .id(phase)
                    .transition(.opacity)

                Button {
                    runID += 1
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.appAccentBlue)
                        .padding(6)
                        .background(Circle().fill(Color.appAccentBlue.opacity(0.12)))
                }
                .accessibilityLabel(SettingsModel.shared.language == .english ? "Replay animation" : "Animation wiederholen")
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.appSurface)
                .shadow(color: Color.appShadow.opacity(0.5), radius: 5, x: 0, y: 2)
        )
        .task(id: runID) {
            var reset = Transaction()
            reset.disablesAnimations = true
            withTransaction(reset) { phase = 0 }
            do {
                try await Task.sleep(nanoseconds: 1_200_000_000)
                for next in 1..<captions.count {
                    withAnimation(.easeInOut(duration: 0.9)) { phase = next }
                    try await Task.sleep(nanoseconds: 2_600_000_000)
                }
            } catch {
                return
            }
        }
    }
}

private func show(_ condition: Bool) -> Double { condition ? 1 : 0 }

// MARK: - 1. Addition und Skalierung

private struct VectorAdditionVisual: View {
    let window = PlaneWindow(xMin: -1.5, xMax: 6.5, yMin: -1.5, yMax: 6.5)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "v = (2, 1) und w = (1, 2) als Pfeile, die im Ursprung starten.",
            "Addieren: Wir hängen w an die Spitze von v.",
            "v + w = (3, 3) ist der Pfeil vom Ursprung zur neuen Spitze. Komponentenweise: 2 + 1 = 3 und 1 + 2 = 3.",
            "Skalieren: 2 · v = (4, 2) zeigt in dieselbe Richtung, ist aber doppelt so lang."
        ]) { phase, size in
            let wStart = phase >= 1 && phase < 3 ? CGPoint(x: 2, y: 1) : .zero
            let wEnd = CGPoint(x: wStart.x + 1, y: wStart.y + 2)

            Arrow(from: .zero, to: phase >= 3 ? CGPoint(x: 4, y: 2) : .zero, color: VisualColor.extra, window: window, width: 5)
                .opacity(show(phase >= 3))
            MathLabel(text: "2·v", at: CGPoint(x: 4, y: 2), color: VisualColor.extra, window: window, size: size)
                .opacity(show(phase >= 3))

            Arrow(from: .zero, to: phase >= 2 && phase < 3 ? CGPoint(x: 3, y: 3) : .zero, color: VisualColor.result, window: window)
                .opacity(show(phase == 2))
            MathLabel(text: "v + w", at: CGPoint(x: 3, y: 3), color: VisualColor.result, window: window, size: size, offset: CGSize(width: -22, height: -12))
                .opacity(show(phase == 2))

            Arrow(from: .zero, to: CGPoint(x: 2, y: 1), color: VisualColor.first, window: window)
            MathLabel(text: "v", at: CGPoint(x: 2, y: 1), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 10, height: 10))

            Arrow(from: wStart, to: wEnd, color: VisualColor.second, window: window)
                .opacity(show(phase < 3))
            MathLabel(text: "w", at: wEnd, color: VisualColor.second, window: window, size: size)
                .opacity(show(phase < 3))
        }
    }
}

// MARK: - 2. Untervektorraum: Gerade durch 0 vs. verschobene Gerade

private struct SubspaceClosureVisual: View {
    let window = PlaneWindow(xMin: -3, xMax: 7, yMin: -3, yMax: 7)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "U ist eine Gerade durch den Ursprung. Die Vektoren u und v liegen auf U.",
            "u + v: Wir hängen v an die Spitze von u. Das Ergebnis liegt wieder auf U.",
            "(−1) · u zeigt in die Gegenrichtung – liegt aber ebenfalls auf U. U ist abgeschlossen.",
            "G ist eine parallele Gerade, die NICHT durch den Ursprung geht. p und q liegen auf G.",
            "p + q landet neben G (roter Punkt). Schon die Addition führt aus G heraus – G ist kein Untervektorraum."
        ]) { phase, size in
            let onU = phase < 3
            let vStart = phase >= 1 ? CGPoint(x: 2, y: 1) : .zero
            let qStart = phase >= 4 ? CGPoint(x: 0, y: 2) : .zero

            Group {
                PlaneLineShape(through: .zero, direction: CGPoint(x: 2, y: 1), window: window)
                    .stroke(VisualColor.first.opacity(0.35), lineWidth: 6)
                MathLabel(text: "U", at: CGPoint(x: 5.6, y: 2.8), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 0, height: 16))

                Arrow(from: .zero, to: phase >= 1 ? CGPoint(x: 5, y: 2.5) : .zero, color: VisualColor.result, window: window)
                    .opacity(show(phase >= 1))
                Arrow(from: .zero, to: CGPoint(x: 2, y: 1), color: VisualColor.first, window: window)
                MathLabel(text: "u", at: CGPoint(x: 2, y: 1), color: VisualColor.first, window: window, size: size, offset: CGSize(width: -4, height: -16))
                Arrow(from: vStart, to: CGPoint(x: vStart.x + 3, y: vStart.y + 1.5), color: VisualColor.second, window: window)
                MathLabel(text: phase >= 1 ? "u + v" : "v", at: phase >= 1 ? CGPoint(x: 5, y: 2.5) : CGPoint(x: 3, y: 1.5), color: phase >= 1 ? VisualColor.result : VisualColor.second, window: window, size: size, offset: CGSize(width: -6, height: -18))

                Arrow(from: .zero, to: phase >= 2 ? CGPoint(x: -2, y: -1) : .zero, color: VisualColor.extra, window: window)
                    .opacity(show(phase >= 2))
                MathLabel(text: "(−1)·u", at: CGPoint(x: -2, y: -1), color: VisualColor.extra, window: window, size: size, offset: CGSize(width: 6, height: 16))
                    .opacity(show(phase >= 2))
            }
            .opacity(show(onU))

            Group {
                PlaneLineShape(through: CGPoint(x: 0, y: 2), direction: CGPoint(x: 2, y: 1), window: window)
                    .stroke(VisualColor.warning.opacity(0.35), lineWidth: 6)
                MathLabel(text: "G", at: CGPoint(x: 5, y: 4.5), color: VisualColor.warning, window: window, size: size, offset: CGSize(width: 10, height: 12))

                Arrow(from: .zero, to: phase >= 4 ? CGPoint(x: 2, y: 5) : .zero, color: VisualColor.result, window: window)
                    .opacity(show(phase >= 4))
                Arrow(from: .zero, to: CGPoint(x: 0, y: 2), color: VisualColor.first, window: window)
                MathLabel(text: "p", at: CGPoint(x: 0, y: 2), color: VisualColor.first, window: window, size: size, offset: CGSize(width: -14, height: 0))
                Arrow(from: qStart, to: CGPoint(x: qStart.x + 2, y: qStart.y + 3), color: VisualColor.second, window: window)
                MathLabel(text: "q", at: CGPoint(x: qStart.x + 2, y: qStart.y + 3), color: VisualColor.second, window: window, size: size, offset: CGSize(width: 14, height: 4))
                    .opacity(show(phase < 4))
                Dot(at: CGPoint(x: 2, y: 5), color: VisualColor.warning, window: window, size: size)
                    .opacity(show(phase >= 4))
                MathLabel(text: "p + q ∉ G", at: CGPoint(x: 2, y: 5), color: VisualColor.warning, window: window, size: size, offset: CGSize(width: -10, height: -18))
                    .opacity(show(phase >= 4))
            }
            .opacity(show(!onU))
        }
    }
}

// MARK: - 3. Linearkombination

private struct LinearCombinationVisual: View {
    let window = PlaneWindow(xMin: -1.5, xMax: 6.5, yMin: -1.5, yMax: 6.5)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Ziel: w = (4, 5). Unsere Bausteine: v₁ = (2, 1) und v₂ = (1, 2).",
            "Erst skalieren: Wir verdoppeln v₂ und erhalten 2 · v₂ = (2, 4).",
            "Dann addieren: 2 · v₂ wird an die Spitze von 1 · v₁ gehängt.",
            "Treffer! 1 · v₁ + 2 · v₂ = (4, 5) = w. Die Zahlen 1 und 2 sind die „Bauanleitung“ für w."
        ]) { phase, size in
            let v2Start = phase >= 2 ? CGPoint(x: 2, y: 1) : .zero
            let v2Length: CGFloat = phase >= 1 ? 2 : 1
            let v2End = CGPoint(x: v2Start.x + v2Length, y: v2Start.y + 2 * v2Length)

            Dot(at: CGPoint(x: 4, y: 5), color: VisualColor.result, window: window, size: size, hollow: phase < 3)
            MathLabel(text: "w", at: CGPoint(x: 4, y: 5), color: VisualColor.result, window: window, size: size)

            Arrow(from: .zero, to: phase >= 3 ? CGPoint(x: 4, y: 5) : .zero, color: VisualColor.result, window: window, width: 4)
                .opacity(show(phase >= 3))

            Arrow(from: .zero, to: CGPoint(x: 2, y: 1), color: VisualColor.first, window: window)
            MathLabel(text: "v₁", at: CGPoint(x: 2, y: 1), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 12, height: 10))

            Arrow(from: v2Start, to: v2End, color: VisualColor.second, window: window)
            MathLabel(text: phase >= 1 ? "2·v₂" : "v₂", at: v2End, color: VisualColor.second, window: window, size: size, offset: phase >= 2 ? CGSize(width: -26, height: 6) : CGSize(width: -16, height: -6))
        }
    }
}

// MARK: - 4. Spann wächst: Gerade → Ebene

private struct SpanGrowthVisual: View {
    let window = PlaneWindow(xMin: -3, xMax: 6, yMin: -3, yMax: 6)
    let v1 = CGPoint(x: 2, y: 1)
    let v2 = CGPoint(x: 1, y: 2)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Ein einzelner Vektor v₁ = (2, 1).",
            "Alle Vielfachen λ · v₁ (auch negative und Brüche) bilden eine Gerade durch 0: span(v₁).",
            "Ein zweiter Vektor v₂ = (1, 2), der NICHT auf dieser Geraden liegt, bringt eine neue Richtung.",
            "Jetzt dürfen wir λ · v₁ + μ · v₂ bilden. Schon die ganzzahligen Kombinationen ergeben ein schiefes Gitter …",
            "… und mit allen reellen λ, μ erreichen wir jeden Punkt der Ebene: span(v₁, v₂) = ℝ²."
        ]) { phase, size in
            Rectangle()
                .fill(VisualColor.result.opacity(0.14))
                .opacity(show(phase >= 4))

            SkewGridShape(a: v1, b: v2, window: window)
                .stroke(VisualColor.result.opacity(0.45), lineWidth: 1)
                .opacity(show(phase >= 3))

            PlaneLineShape(through: .zero, direction: v1, window: window)
                .trim(from: phase >= 1 ? 0 : 0.5, to: phase >= 1 ? 1 : 0.5)
                .stroke(VisualColor.first.opacity(0.4), lineWidth: 5)

            Arrow(from: .zero, to: phase >= 1 ? CGPoint(x: 4, y: 2) : .zero, color: VisualColor.first.opacity(0.45), window: window)
                .opacity(show(phase >= 1 && phase < 3))
            Arrow(from: .zero, to: phase >= 1 ? CGPoint(x: -2, y: -1) : .zero, color: VisualColor.first.opacity(0.45), window: window)
                .opacity(show(phase >= 1 && phase < 3))
            MathLabel(text: "span(v₁)", at: CGPoint(x: 4.6, y: 2.3), color: VisualColor.first, window: window, size: size, offset: CGSize(width: -6, height: 16))
                .opacity(show(phase >= 1 && phase < 4))

            Arrow(from: .zero, to: v1, color: VisualColor.first, window: window)
            MathLabel(text: "v₁", at: v1, color: VisualColor.first, window: window, size: size, offset: CGSize(width: 10, height: 12))

            Arrow(from: .zero, to: phase >= 2 ? v2 : .zero, color: VisualColor.second, window: window)
                .opacity(show(phase >= 2))
            MathLabel(text: "v₂", at: v2, color: VisualColor.second, window: window, size: size, offset: CGSize(width: -14, height: -6))
                .opacity(show(phase >= 2))

            MathLabel(text: "span(v₁, v₂) = ℝ²", at: CGPoint(x: -2.8, y: 5.4), color: VisualColor.result, window: window, size: size, offset: CGSize(width: 62, height: 0))
                .opacity(show(phase >= 4))
        }
    }
}

// MARK: - 5. Lineare Abhängigkeit

private struct LinearDependenceVisual: View {
    let window = PlaneWindow(xMin: -1.5, xMax: 5, yMin: -1.5, yMax: 5)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "v₁ = (2, 1), v₂ = (1, 2) und zusätzlich v₃ = (3, 3).",
            "Wir hängen v₂ an die Spitze von v₁ …",
            "… und landen exakt auf der Spitze von v₃. Also gilt v₃ = v₁ + v₂.",
            "v₃ bringt keine neue Richtung: Alles, was v₃ erreicht, erreichen v₁ und v₂ schon allein. span(v₁, v₂, v₃) = span(v₁, v₂)."
        ]) { phase, size in
            let copyStart = phase >= 1 ? CGPoint(x: 2, y: 1) : .zero
            let v3Color = phase == 2 ? VisualColor.result : VisualColor.extra

            Arrow(from: .zero, to: CGPoint(x: 3, y: 3), color: v3Color, window: window, width: phase == 2 ? 5 : 3, dashed: phase >= 3)
                .opacity(phase >= 3 ? 0.5 : 1)
            MathLabel(text: "v₃", at: CGPoint(x: 3, y: 3), color: v3Color, window: window, size: size)

            Arrow(from: .zero, to: CGPoint(x: 2, y: 1), color: VisualColor.first, window: window)
            MathLabel(text: "v₁", at: CGPoint(x: 2, y: 1), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 12, height: 10))

            Arrow(from: .zero, to: CGPoint(x: 1, y: 2), color: VisualColor.second, window: window)
            MathLabel(text: "v₂", at: CGPoint(x: 1, y: 2), color: VisualColor.second, window: window, size: size, offset: CGSize(width: -14, height: -6))

            Arrow(from: copyStart, to: CGPoint(x: copyStart.x + 1, y: copyStart.y + 2), color: VisualColor.second.opacity(0.7), window: window, dashed: true)
                .opacity(show(phase >= 1 && phase < 3))
        }
    }
}

// MARK: - 6. Basis = Koordinatensystem

private struct BasisCoordinatesVisual: View {
    let window = PlaneWindow(xMin: -1.5, xMax: 6.5, yMin: -1.5, yMax: 6.5)
    let v1 = CGPoint(x: 2, y: 1)
    let v2 = CGPoint(x: 1, y: 2)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Standardbasis: w = 4 · e₁ + 5 · e₂. Koordinaten bezüglich (e₁, e₂): (4, 5).",
            "Jetzt wechseln wir das „Gitter“: Die Basis B = (v₁, v₂) erzeugt ein schiefes Koordinatensystem.",
            "In diesem Gitter erreichen wir w mit 1 Schritt in v₁-Richtung und 2 Schritten in v₂-Richtung.",
            "Derselbe Vektor w hat bezüglich B die Koordinaten (1, 2). Die Basis legt fest, wie wir Vektoren in Zahlen übersetzen."
        ]) { phase, size in
            let standard = phase == 0
            let basisPath = phase >= 2

            SkewGridShape(a: v1, b: v2, window: window)
                .stroke(VisualColor.first.opacity(0.35), lineWidth: 1)
                .opacity(show(!standard))

            Group {
                Arrow(from: .zero, to: CGPoint(x: 4, y: 0), color: VisualColor.first, window: window)
                Arrow(from: CGPoint(x: 4, y: 0), to: CGPoint(x: 4, y: 5), color: VisualColor.second, window: window)
                MathLabel(text: "4·e₁", at: CGPoint(x: 2, y: 0), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 0, height: 14))
                MathLabel(text: "5·e₂", at: CGPoint(x: 4, y: 2.5), color: VisualColor.second, window: window, size: size, offset: CGSize(width: 24, height: 0))
            }
            .opacity(show(standard))

            Group {
                Arrow(from: .zero, to: v1, color: VisualColor.first, window: window, width: 4)
                MathLabel(text: "v₁", at: v1, color: VisualColor.first, window: window, size: size, offset: CGSize(width: 12, height: 10))
                Arrow(from: .zero, to: v2, color: VisualColor.second, window: window, width: 4)
                    .opacity(show(!basisPath))
                MathLabel(text: "v₂", at: v2, color: VisualColor.second, window: window, size: size, offset: CGSize(width: -14, height: -6))
                    .opacity(show(!basisPath))
                Arrow(from: basisPath ? v1 : .zero, to: basisPath ? CGPoint(x: 4, y: 5) : v2, color: VisualColor.second, window: window, width: 4)
                    .opacity(show(basisPath))
                MathLabel(text: "2·v₂", at: CGPoint(x: 3, y: 3), color: VisualColor.second, window: window, size: size, offset: CGSize(width: 22, height: 0))
                    .opacity(show(basisPath))
            }
            .opacity(show(!standard))

            Dot(at: CGPoint(x: 4, y: 5), color: VisualColor.result, window: window, size: size)
            MathLabel(text: phase >= 3 ? "w ≙ (1, 2) bzgl. B" : (standard ? "w = (4, 5)" : "w"), at: CGPoint(x: 4, y: 5), color: VisualColor.result, window: window, size: size, offset: CGSize(width: -30, height: -16))
        }
    }
}
