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
        case "matrixTimesVector": LinearCombinationVisual(
            captions: [
                "A hat die Spalten a₁ = (2, 1) und a₂ = (1, 2). Wir berechnen A · x für x = (1, 2).",
                "Der 2. Eintrag von x ist 2: Spalte a₂ wird verdoppelt → 2 · a₂ = (2, 4).",
                "Der 1. Eintrag von x ist 1: a₁ einmal. Wir hängen 2 · a₂ an die Spitze von a₁.",
                "A · x = 1 · a₁ + 2 · a₂ = (4, 5). Matrix mal Vektor ist eine Linearkombination der Spalten!"
            ],
            firstName: "a₁",
            secondName: "a₂",
            targetName: "A·x"
        )
        case "matrixTransform": MatrixTransformVisual()
        case "matrixOrder": MatrixOrderVisual()
        case "singularMatrix": SingularMatrixVisual()
        case "linearityCheck": LinearityCheckVisual()
        case "kernelImage": KernelImageVisual()
        case "shearMap": GridMapVisual(
            captions: [
                "Vorher: das Einheitsquadrat, e₁ = (1, 0), e₂ = (0, 1) und der Vektor x = (1, 2). Die Abbildung ist f(x, y) = (x + y, y).",
                "f(e₁) = (1 + 0, 0) = (1, 0): e₁ bleibt, wo es ist.",
                "f(e₂) = (0 + 1, 1) = (1, 1): e₂ kippt nach rechts.",
                "Das Gitter folgt: Das Quadrat wird zu einem schiefen Parallelogramm. Grundseite und Höhe bleiben gleich – die Fläche auch.",
                "f(x) = 1 · f(e₁) + 2 · f(e₂) = (1, 0) + (2, 2) = (3, 2). Das ist eine Scherung."
            ],
            image1: CGPoint(x: 1, y: 0),
            image2: CGPoint(x: 1, y: 1),
            sample: CGPoint(x: 1, y: 2)
        )
        case "reflectionMap": GridMapVisual(
            captions: [
                "Vorher: das Einheitsquadrat, e₁, e₂ und x = (1, 2). Die Abbildung ist f(x, y) = (y, x): Sie vertauscht die Koordinaten.",
                "f(e₁) = (0, 1): e₁ springt nach oben.",
                "f(e₂) = (1, 0): e₂ springt nach rechts. Die beiden Basisvektoren tauschen die Plätze.",
                "Das Gitter wird an der Geraden y = x gespiegelt. Das Quadrat landet auf sich selbst, aber sein Umlaufsinn kehrt sich um.",
                "f(x) = 1 · f(e₁) + 2 · f(e₂) = (0, 1) + (2, 0) = (2, 1): das Spiegelbild von x an der Geraden y = x."
            ],
            image1: CGPoint(x: 0, y: 1),
            image2: CGPoint(x: 1, y: 0),
            sample: CGPoint(x: 1, y: 2),
            mirrorDirection: CGPoint(x: 1, y: 1)
        )
        case "basisChange": BasisChangeVisual()
        case "detArea": GridMapVisual(
            window: PlaneWindow(xMin: -1, xMax: 5, yMin: -1, yMax: 5),
            captions: [
                "Das Einheitsquadrat hat die Fläche 1. Wir wenden f(x) = A x mit A = (3 1; 1 2) an. Dazu e₁ = (1, 0), e₂ = (0, 1) und x = (1, 1).",
                "f(e₁) = A e₁ = (3, 1): die erste Spalte von A.",
                "f(e₂) = A e₂ = (1, 2): die zweite Spalte von A.",
                "Das Quadrat wird zum Parallelogramm mit der Fläche |3 · 2 − 1 · 1| = 5. Die Determinante sagt: Flächen werden mit 5 multipliziert.",
                "Die Ecke x = (1, 1) landet bei f(x) = (3 + 1, 1 + 2) = (4, 3) – der gegenüberliegenden Ecke des Parallelogramms."
            ],
            image1: CGPoint(x: 3, y: 1),
            image2: CGPoint(x: 1, y: 2),
            sample: CGPoint(x: 1, y: 1)
        )
        case "detRules": DetRulesVisual()
        case "eigenSearch": EigenSearchVisual()
        case "eigenvalueScaling": EigenvalueScalingVisual()
        case "charPolyCollapse": CharPolyCollapseVisual()
        case "eigenMap": EigenMapVisual(
            captions: [
                "A = (2 1; 1 2). Blau: v₁ = (1, 1), orange: v₂ = (−1, 1), rot: ein gewöhnlicher Vektor x = (1, 0).",
                "Gestrichelt: die Geraden durch v₁, v₂ und x. Die Geraden durch v₁ und v₂ sind die Eigenräume.",
                "Jetzt wirkt A auf die ganze Ebene: A v₁ = 3 v₁ und A v₂ = 1 · v₂ bleiben auf ihren Geraden. A x = (2, 1) verlässt dagegen seine Gerade.",
                "A streckt also in Richtung (1, 1) um den Faktor 3 und lässt die Richtung (−1, 1) unverändert. Mehr macht A nicht – das ist das ganze Geheimnis dieser Matrix."
            ],
            column1: CGPoint(x: 2, y: 1),
            column2: CGPoint(x: 1, y: 2),
            eigen: [(CGPoint(x: 1, y: 1), 3, "v₁"), (CGPoint(x: -1, y: 1), 1, "v₂")],
            sample: CGPoint(x: 1, y: 0)
        )
        case "shearEigen": EigenMapVisual(
            window: PlaneWindow(xMin: -1.5, xMax: 2.5, yMin: -1.5, yMax: 2.5),
            captions: [
                "Scherung A = (1 1; 0 1). Blau: v = (1, 0), rot: x = (0, 1).",
                "Die x-Achse (gestrichelt) ist die einzige Eigengerade. Die rote Gerade durch x ist zum Vergleich eingezeichnet.",
                "A wirkt: A v = v bleibt liegen (Eigenwert 1). A x = (1, 1) kippt aus seiner Geraden heraus – wie jeder Vektor außerhalb der x-Achse.",
                "Es gibt nur EINE Eigenrichtung: Doppelter Eigenwert 1, aber Eigenraum der Dimension 1. Zu wenige Eigenvektoren für eine Basis!"
            ],
            column1: CGPoint(x: 1, y: 0),
            column2: CGPoint(x: 1, y: 1),
            eigen: [(CGPoint(x: 1, y: 0), 1, "v")],
            sample: CGPoint(x: 0, y: 1)
        )
        case "powerIteration": PowerIterationVisual()
        case "vennOperations": VennOperationsVisual()
        case "deMorgan": DeMorganVisual()
        case "powerSet": PowerSetVisual()
        case "cartesianProduct": CartesianProductVisual()
        case "modClasses": ModClassesVisual()
        case "implicationTable": ImplicationTableVisual()
        case "implicationSets": ImplicationSetsVisual()
        case "dominoes": DominoVisual()
        case "gaussSum": GaussSumVisual()
        case "binomialSquare": BinomialSquareVisual()
        case "binomialDifference": BinomialDifferenceVisual()
        case "euclidRectangle": EuclidRectangleVisual()
        case "triangleSymmetries": TriangleSymmetryVisual()
        case "complexOperations": ComplexOperationsVisual()
        case "complexMultiplication": ComplexMultiplicationVisual()
        case "rootsOfUnity": RootsOfUnityVisual()
        case "clockZ12": ClockVisual(n: 12, frames: [
            ClockFrame(caption: "ℤ/12: Rechnen auf der Uhr. Es gibt nur die Zahlen 0 bis 11; nach 11 kommt wieder 0."),
            ClockFrame(arcs: [ClockArc(from: 9, steps: 5)], marks: [(9, .blue), (2, .green)], caption: "9 + 5: Von 9 aus 5 Schritte weiter landet man bei 2. Also 9 + 5 = 2 in ℤ/12 (denn 14 = 12 + 2)."),
            ClockFrame(marks: [(0, .green)], caption: "Das neutrale Element ist 0: „0 Schritte weiter“ ändert nichts."),
            ClockFrame(arcs: [ClockArc(from: 5, steps: 7, color: .orange)], marks: [(5, .blue), (0, .green)], caption: "Das Inverse von 5 ist 7: Von 5 aus 7 Schritte führen zurück zur 0. Also 5 + 7 = 0 und −5 = 7."),
            ClockFrame(arcs: [ClockArc(from: 0, steps: 4, color: .purple), ClockArc(from: 4, steps: 4, color: .purple), ClockArc(from: 8, steps: 4, color: .purple)],
                       marks: [(0, .purple), (4, .purple), (8, .purple)],
                       caption: "Mit Schritten der Länge 4 erreicht man nur 0, 4, 8 – dann ist man wieder bei 0. {0, 4, 8} ist eine Untergruppe, und 4 hat die Ordnung 3.")
        ])
        case "clockZ6": ClockVisual(n: 6, frames: [
            ClockFrame(caption: "ℤ/6 = {0, 1, 2, 3, 4, 5}. Multiplizieren heißt wiederholtes Addieren: 2 · 3 = 3 + 3."),
            ClockFrame(arcs: [ClockArc(from: 0, steps: 3), ClockArc(from: 3, steps: 3)], marks: [(3, .orange), (0, .red)],
                       caption: "2 · 3 = 3 + 3 = 6 = 0. Zwei Elemente ungleich 0 haben das Produkt 0: 2 und 3 sind Nullteiler."),
            ClockFrame(arcs: [ClockArc(from: 0, steps: 2, color: .orange), ClockArc(from: 2, steps: 2, color: .orange), ClockArc(from: 4, steps: 2, color: .orange)],
                       marks: [(0, .orange), (2, .orange), (4, .orange), (1, .red)],
                       caption: "Die Vielfachen von 2 sind nur 0, 2, 4. Die 1 wird nie erreicht – es gibt kein x mit 2 · x = 1. Die 2 ist nicht invertierbar."),
            ClockFrame(marks: [(5, .green), (1, .green)], caption: "Anders bei 5: 5 · 5 = 25 = 4 · 6 + 1, also 5 · 5 = 1. Die 5 ist invertierbar, denn ggT(5, 6) = 1.")
        ])
        case "clockF5": ClockVisual(n: 5, frames: [
            ClockFrame(caption: "ℤ/5 = {0, 1, 2, 3, 4}. Gibt es auch hier Nullteiler?"),
            ClockFrame(arcs: [ClockArc(from: 0, steps: 2, color: .orange), ClockArc(from: 2, steps: 2, color: .orange), ClockArc(from: 4, steps: 2, color: .orange), ClockArc(from: 1, steps: 2, color: .orange), ClockArc(from: 3, steps: 2, color: .orange)],
                       marks: [(0, .orange), (2, .orange), (4, .orange), (1, .green), (3, .orange)],
                       caption: "Vielfache von 2: 0, 2, 4, 1, 3 – ALLE Zahlen werden erreicht, auch die 1. Bei 2 · 3 = 6 = 1 landet man auf der 1: Also ist 3 das Inverse von 2."),
            ClockFrame(marks: [(1, .green), (2, .green), (3, .green), (4, .green)],
                       caption: "Weil 5 eine Primzahl ist, klappt das mit jeder Zahl ungleich 0: 1 · 1 = 1, 2 · 3 = 1, 4 · 4 = 1. ℤ/5 ist ein Körper.")
        ])
        case "fieldInverses": ArrowDiagramVisual(
            columns: [["1", "2", "3", "4", "5", "6"], ["1", "2", "3", "4", "5", "6"]],
            names: ["a", "a⁻¹"],
            frames: [
                DiagramFrame(arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 0), .init(fromColumn: 0, from: 1, toColumn: 1, to: 3), .init(fromColumn: 0, from: 2, toColumn: 1, to: 4),
                                      .init(fromColumn: 0, from: 3, toColumn: 1, to: 1), .init(fromColumn: 0, from: 4, toColumn: 1, to: 2), .init(fromColumn: 0, from: 5, toColumn: 1, to: 5)],
                             caption: "In 𝔽₇: Jedes a ≠ 0 hat genau ein Inverses. 2 · 4 = 8 = 1, 3 · 5 = 15 = 1, 6 · 6 = 36 = 1. Die Zuordnung a ↦ a⁻¹ ist sogar bijektiv."),
                DiagramFrame(columns: [["1", "2", "3", "4", "5"], ["1", "2", "3", "4", "5"]],
                             arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 0), .init(fromColumn: 0, from: 4, toColumn: 1, to: 4)],
                             marks: [.init(column: 0, index: 1, color: .red), .init(column: 0, index: 2, color: .red), .init(column: 0, index: 3, color: .red)],
                             caption: "In ℤ/6 dagegen haben nur 1 und 5 ein Inverses. 2, 3 und 4 haben einen gemeinsamen Teiler mit 6 – für sie gibt es keins.")
            ]
        )
        case "quantifierOrder": ArrowDiagramVisual(
            columns: [["1", "2", "3"], ["a", "b", "c"]],
            names: ["Schlösser", "Schlüssel"],
            frames: [
                DiagramFrame(arrows: [], caption: "Drei Schlösser 1, 2, 3 und drei Schlüssel a, b, c. Ein Pfeil heißt: Der Schlüssel passt."),
                DiagramFrame(arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 0), .init(fromColumn: 0, from: 1, toColumn: 1, to: 1), .init(fromColumn: 0, from: 2, toColumn: 1, to: 2)],
                             caption: "∀ Schloss ∃ Schlüssel: „Zu jedem Schloss gibt es einen passenden Schlüssel.“ Wahr – aber jedes Schloss hat einen ANDEREN."),
                DiagramFrame(arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 1), .init(fromColumn: 0, from: 1, toColumn: 1, to: 1), .init(fromColumn: 0, from: 2, toColumn: 1, to: 1)],
                             marks: [.init(column: 1, index: 1, color: .green)],
                             caption: "∃ Schlüssel ∀ Schloss: „Es gibt EINEN Schlüssel, der zu allen Schlössern passt“ – ein Generalschlüssel. Das ist eine viel stärkere Aussage."),
                DiagramFrame(arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 0), .init(fromColumn: 0, from: 1, toColumn: 1, to: 1), .init(fromColumn: 0, from: 2, toColumn: 1, to: 2)],
                             marks: [.init(column: 1, index: 0, color: .red), .init(column: 1, index: 1, color: .red), .init(column: 1, index: 2, color: .red)],
                             caption: "In der Situation von vorhin gilt ∀∃, aber nicht ∃∀: Kein Schlüssel passt überall. Die Reihenfolge der Quantoren ändert die Bedeutung!")
            ]
        )
        case "mapCheck": ArrowDiagramVisual(
            columns: [["1", "2", "3"], ["a", "b", "c", "d"]],
            names: ["A", "B"],
            frames: [
                DiagramFrame(arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 1), .init(fromColumn: 0, from: 1, toColumn: 1, to: 0), .init(fromColumn: 0, from: 2, toColumn: 1, to: 3)],
                             marks: [.init(column: 0, index: 0, color: .green), .init(column: 0, index: 1, color: .green), .init(column: 0, index: 2, color: .green)],
                             caption: "Jedes Element von A hat GENAU EINEN Pfeil: eine Abbildung. Dass c nichts abbekommt, ist erlaubt."),
                DiagramFrame(arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 1), .init(fromColumn: 0, from: 1, toColumn: 1, to: 0)],
                             marks: [.init(column: 0, index: 2, color: .red)],
                             caption: "3 hat keinen Pfeil: KEINE Abbildung. Jedem Element von A muss etwas zugeordnet werden."),
                DiagramFrame(arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 1), .init(fromColumn: 0, from: 0, toColumn: 1, to: 2), .init(fromColumn: 0, from: 1, toColumn: 1, to: 0), .init(fromColumn: 0, from: 2, toColumn: 1, to: 3)],
                             marks: [.init(column: 0, index: 0, color: .red)],
                             caption: "1 hat zwei Pfeile: KEINE Abbildung. Der Wert f(1) muss eindeutig sein."),
                DiagramFrame(arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 1), .init(fromColumn: 0, from: 1, toColumn: 1, to: 1), .init(fromColumn: 0, from: 2, toColumn: 1, to: 1)],
                             marks: [.init(column: 1, index: 1, color: .green)],
                             caption: "Alle drei Pfeile treffen b: Das IST eine Abbildung (eine konstante). Bei B dürfen beliebig viele Pfeile ankommen – auch keiner.")
            ]
        )
        case "injSurj": ArrowDiagramVisual(
            columns: [["1", "2", "3"], ["a", "b", "c"]],
            names: ["A", "B"],
            frames: [
                DiagramFrame(columns: [["1", "2", "3"], ["a", "b", "c", "d"]],
                             arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 0), .init(fromColumn: 0, from: 1, toColumn: 1, to: 1), .init(fromColumn: 0, from: 2, toColumn: 1, to: 3)],
                             marks: [.init(column: 1, index: 2, color: .orange)],
                             caption: "Injektiv, nicht surjektiv: Kein Element von B wird doppelt getroffen – aber c wird gar nicht getroffen."),
                DiagramFrame(columns: [["1", "2", "3", "4"], ["a", "b", "c"]],
                             arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 0), .init(fromColumn: 0, from: 1, toColumn: 1, to: 1), .init(fromColumn: 0, from: 2, toColumn: 1, to: 2), .init(fromColumn: 0, from: 3, toColumn: 1, to: 2)],
                             marks: [.init(column: 1, index: 2, color: .orange)],
                             caption: "Surjektiv, nicht injektiv: Jedes Element von B wird getroffen – aber c doppelt (von 3 und 4)."),
                DiagramFrame(arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 1), .init(fromColumn: 0, from: 1, toColumn: 1, to: 2), .init(fromColumn: 0, from: 2, toColumn: 1, to: 0)],
                             marks: [.init(column: 1, index: 0, color: .green), .init(column: 1, index: 1, color: .green), .init(column: 1, index: 2, color: .green)],
                             caption: "Bijektiv: Jedes Element von B wird GENAU EINMAL getroffen. Die Elemente von A und B sind perfekt gepaart."),
                DiagramFrame(arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 0), .init(fromColumn: 0, from: 1, toColumn: 1, to: 0), .init(fromColumn: 0, from: 2, toColumn: 1, to: 2)],
                             marks: [.init(column: 1, index: 0, color: .red), .init(column: 1, index: 1, color: .orange)],
                             caption: "Weder noch: a wird doppelt getroffen (nicht injektiv), b gar nicht (nicht surjektiv). Es ist trotzdem eine Abbildung!")
            ]
        )
        case "preimage": ArrowDiagramVisual(
            columns: [["1", "2", "3", "4"], ["a", "b", "c", "d"]],
            names: ["A", "B"],
            frames: {
                let f: [DiagramArrow] = [.init(fromColumn: 0, from: 0, toColumn: 1, to: 0), .init(fromColumn: 0, from: 1, toColumn: 1, to: 1), .init(fromColumn: 0, from: 2, toColumn: 1, to: 0), .init(fromColumn: 0, from: 3, toColumn: 1, to: 2)]
                return [
                    DiagramFrame(arrows: f, caption: "f: A → B mit f(1) = a, f(2) = b, f(3) = a, f(4) = c."),
                    DiagramFrame(arrows: f, marks: [.init(column: 0, index: 0, color: .green), .init(column: 0, index: 1, color: .green), .init(column: 1, index: 0, color: .green), .init(column: 1, index: 1, color: .green)],
                                 caption: "Bild: f({1, 2}) = {a, b}. Man startet LINKS und folgt den Pfeilen."),
                    DiagramFrame(arrows: f, marks: [.init(column: 1, index: 0, color: .purple), .init(column: 0, index: 0, color: .purple), .init(column: 0, index: 2, color: .purple)],
                                 caption: "Urbild: f⁻¹({a}) = {1, 3}. Man startet RECHTS und sucht alle Pfeile, die dort ankommen."),
                    DiagramFrame(arrows: f, marks: [.init(column: 1, index: 3, color: .purple)],
                                 caption: "f⁻¹({d}) = ∅, denn kein Pfeil kommt bei d an. Das Urbild existiert IMMER – auch wenn f gar nicht umkehrbar ist.")
                ]
            }()
        )
        case "composition": ArrowDiagramVisual(
            columns: [["1", "2", "3"], ["a", "b", "c"], ["x", "y"]],
            names: ["A", "B", "C"],
            frames: {
                let f: [DiagramArrow] = [.init(fromColumn: 0, from: 0, toColumn: 1, to: 0), .init(fromColumn: 0, from: 1, toColumn: 1, to: 2), .init(fromColumn: 0, from: 2, toColumn: 1, to: 1)]
                let g: [DiagramArrow] = [.init(fromColumn: 1, from: 0, toColumn: 2, to: 1, color: .orange), .init(fromColumn: 1, from: 1, toColumn: 2, to: 0, color: .orange), .init(fromColumn: 1, from: 2, toColumn: 2, to: 1, color: .orange)]
                return [
                    DiagramFrame(arrows: f, caption: "Erst f: A → B (blau): 1 ↦ a, 2 ↦ c, 3 ↦ b."),
                    DiagramFrame(arrows: f + g, caption: "Dann g: B → C (orange): a ↦ y, b ↦ x, c ↦ y. Die Ziele von f sind die Startpunkte von g."),
                    DiagramFrame(arrows: [.init(fromColumn: 0, from: 0, toColumn: 1, to: 0, color: .green), .init(fromColumn: 1, from: 0, toColumn: 2, to: 1, color: .green)],
                                 marks: [.init(column: 0, index: 0, color: .green), .init(column: 2, index: 1, color: .green)],
                                 dimmedArrows: f + g,
                                 caption: "Pfad für 1: erst zu f(1) = a, dann zu g(a) = y. Also (g ∘ f)(1) = g(f(1)) = y."),
                    DiagramFrame(arrows: [.init(fromColumn: 0, from: 0, toColumn: 2, to: 1, color: .green), .init(fromColumn: 0, from: 1, toColumn: 2, to: 1, color: .green), .init(fromColumn: 0, from: 2, toColumn: 2, to: 0, color: .green)],
                                 dimmedArrows: f + g,
                                 caption: "g ∘ f: A → C fasst beide Schritte zusammen: 1 ↦ y, 2 ↦ y, 3 ↦ x. Man liest „g nach f“ – f wird zuerst angewendet.")
                ]
            }()
        )
        case "inverseMap": ArrowDiagramVisual(
            columns: [["1", "2", "3"], ["a", "b", "c"]],
            names: ["A", "B"],
            frames: {
                let f: [DiagramArrow] = [.init(fromColumn: 0, from: 0, toColumn: 1, to: 1), .init(fromColumn: 0, from: 1, toColumn: 1, to: 2), .init(fromColumn: 0, from: 2, toColumn: 1, to: 0)]
                let back: [DiagramArrow] = [.init(fromColumn: 1, from: 1, toColumn: 0, to: 0, color: .green), .init(fromColumn: 1, from: 2, toColumn: 0, to: 1, color: .green), .init(fromColumn: 1, from: 0, toColumn: 0, to: 2, color: .green)]
                let h: [DiagramArrow] = [.init(fromColumn: 0, from: 0, toColumn: 1, to: 0), .init(fromColumn: 0, from: 1, toColumn: 1, to: 0), .init(fromColumn: 0, from: 2, toColumn: 1, to: 1)]
                let hBack: [DiagramArrow] = [.init(fromColumn: 1, from: 0, toColumn: 0, to: 0, color: .red), .init(fromColumn: 1, from: 0, toColumn: 0, to: 1, color: .red), .init(fromColumn: 1, from: 1, toColumn: 0, to: 2, color: .red)]
                return [
                    DiagramFrame(arrows: f, caption: "f ist bijektiv: 1 ↦ b, 2 ↦ c, 3 ↦ a. Jedes Element von B wird genau einmal getroffen."),
                    DiagramFrame(arrows: back, dimmedArrows: f, caption: "Alle Pfeile umdrehen (grün) ergibt wieder eine Abbildung: f⁻¹: B → A mit f⁻¹(a) = 3, f⁻¹(b) = 1, f⁻¹(c) = 2."),
                    DiagramFrame(arrows: h, caption: "Jetzt ein nicht bijektives h: 1 ↦ a, 2 ↦ a, 3 ↦ b."),
                    DiagramFrame(arrows: hBack, marks: [.init(column: 1, index: 0, color: .red), .init(column: 1, index: 2, color: .red)], dimmedArrows: h,
                                 caption: "Umgedreht hätte a zwei Pfeile und c keinen – das ist keine Abbildung. Eine Umkehrabbildung gibt es nur für bijektive Abbildungen.")
                ]
            }()
        )
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
    let showGrid: Bool
    let aspectRatio: CGFloat
    let content: (Int, CGSize) -> Content

    @State private var phase = 0
    @State private var runID = 0

    init(
        window: PlaneWindow,
        captions: [String],
        showGrid: Bool = true,
        aspectRatio: CGFloat = 1,
        @ViewBuilder content: @escaping (Int, CGSize) -> Content
    ) {
        self.window = window
        self.captions = captions
        self.showGrid = showGrid
        self.aspectRatio = aspectRatio
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader { geo in
                ZStack {
                    if showGrid {
                        CoordinateGrid(window: window)
                    }
                    content(phase, geo.size)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .aspectRatio(aspectRatio, contentMode: .fit)
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
    var captions = [
        "Ziel: w = (4, 5). Unsere Bausteine: v₁ = (2, 1) und v₂ = (1, 2).",
        "Erst skalieren: Wir verdoppeln v₂ und erhalten 2 · v₂ = (2, 4).",
        "Dann addieren: 2 · v₂ wird an die Spitze von 1 · v₁ gehängt.",
        "Treffer! 1 · v₁ + 2 · v₂ = (4, 5) = w. Die Zahlen 1 und 2 sind die „Bauanleitung“ für w."
    ]
    var firstName = "v₁"
    var secondName = "v₂"
    var targetName = "w"

    var body: some View {
        AnimatedFigure(window: window, captions: captions) { phase, size in
            let v2Start = phase >= 2 ? CGPoint(x: 2, y: 1) : .zero
            let v2Length: CGFloat = phase >= 1 ? 2 : 1
            let v2End = CGPoint(x: v2Start.x + v2Length, y: v2Start.y + 2 * v2Length)

            Dot(at: CGPoint(x: 4, y: 5), color: VisualColor.result, window: window, size: size, hollow: phase < 3)
            MathLabel(text: targetName, at: CGPoint(x: 4, y: 5), color: VisualColor.result, window: window, size: size)

            Arrow(from: .zero, to: phase >= 3 ? CGPoint(x: 4, y: 5) : .zero, color: VisualColor.result, window: window, width: 4)
                .opacity(show(phase >= 3))

            Arrow(from: .zero, to: CGPoint(x: 2, y: 1), color: VisualColor.first, window: window)
            MathLabel(text: firstName, at: CGPoint(x: 2, y: 1), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 12, height: 10))

            Arrow(from: v2Start, to: v2End, color: VisualColor.second, window: window)
            MathLabel(text: phase >= 1 ? "2·" + secondName : secondName, at: v2End, color: VisualColor.second, window: window, size: size, offset: phase >= 2 ? CGSize(width: -26, height: 6) : CGSize(width: -16, height: -6))
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

// MARK: - Matrizen: animierbare Formen

/// Parallelogramm, das von den Vektoren a und b im Ursprung aufgespannt wird (animierbar).
struct ParallelogramShape: Shape {
    var a: CGPoint
    var b: CGPoint
    let window: PlaneWindow

    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
        get { AnimatablePair(AnimatablePair(a.x, a.y), AnimatablePair(b.x, b.y)) }
        set {
            a = CGPoint(x: newValue.first.first, y: newValue.first.second)
            b = CGPoint(x: newValue.second.first, y: newValue.second.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: window.point(.zero, in: rect.size))
        path.addLine(to: window.point(a, in: rect.size))
        path.addLine(to: window.point(CGPoint(x: a.x + b.x, y: a.y + b.y), in: rect.size))
        path.addLine(to: window.point(b, in: rect.size))
        path.closeSubpath()
        return path
    }
}

/// Gitter aus den ganzzahligen Kombinationen von a und b, dessen Richtungen sich animieren lassen.
struct AnimatableGridShape: Shape {
    var a: CGPoint
    var b: CGPoint
    let window: PlaneWindow

    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
        get { AnimatablePair(AnimatablePair(a.x, a.y), AnimatablePair(b.x, b.y)) }
        set {
            a = CGPoint(x: newValue.first.first, y: newValue.first.second)
            b = CGPoint(x: newValue.second.first, y: newValue.second.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        SkewGridShape(a: a, b: b, window: window).path(in: rect)
    }
}

// MARK: - 7. Matrix als Abbildung: das Gitter wird verformt

private struct MatrixTransformVisual: View {
    let window = PlaneWindow(xMin: -1.5, xMax: 5, yMin: -1.5, yMax: 5)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Vorher: e₁ = (1, 0), e₂ = (0, 1), das Einheitsquadrat und der Vektor x = (1, 2).",
            "A = (2 1; 0 1) schickt e₁ auf A · e₁ = (2, 0) – genau die 1. Spalte von A.",
            "e₂ landet auf A · e₂ = (1, 1) – genau die 2. Spalte von A.",
            "Das ganze Gitter folgt: Gitterlinien bleiben gerade, parallel und gleichmäßig verteilt. Das Quadrat wird zum Parallelogramm.",
            "x = (1, 2) landet bei A · x = 1 · (2, 0) + 2 · (1, 1) = (4, 2) – dieselben Koordinaten im neuen Gitter."
        ]) { phase, size in
            let col1 = phase >= 1 ? CGPoint(x: 2, y: 0) : CGPoint(x: 1, y: 0)
            let col2 = phase >= 2 ? CGPoint(x: 1, y: 1) : CGPoint(x: 0, y: 1)
            let gridA = phase >= 3 ? CGPoint(x: 2, y: 0) : CGPoint(x: 1, y: 0)
            let gridB = phase >= 3 ? CGPoint(x: 1, y: 1) : CGPoint(x: 0, y: 1)
            let xImage = phase >= 4 ? CGPoint(x: 4, y: 2) : CGPoint(x: 1, y: 2)

            AnimatableGridShape(a: gridA, b: gridB, window: window)
                .stroke(VisualColor.first.opacity(0.35), lineWidth: 1)
            ParallelogramShape(a: gridA, b: gridB, window: window)
                .fill(VisualColor.first.opacity(0.18))

            Arrow(from: .zero, to: xImage, color: VisualColor.result, window: window)
            MathLabel(text: phase >= 4 ? "A·x" : "x", at: xImage, color: VisualColor.result, window: window, size: size, offset: CGSize(width: 14, height: -10))

            Arrow(from: .zero, to: col1, color: VisualColor.first, window: window, width: 4)
            MathLabel(text: phase >= 1 ? "A·e₁" : "e₁", at: col1, color: VisualColor.first, window: window, size: size, offset: CGSize(width: 4, height: 16))
            Arrow(from: .zero, to: col2, color: VisualColor.second, window: window, width: 4)
            MathLabel(text: phase >= 2 ? "A·e₂" : "e₂", at: col2, color: VisualColor.second, window: window, size: size, offset: CGSize(width: -22, height: -8))
        }
    }
}

// MARK: - 8. Reihenfolge: R·D ≠ D·R

private struct MatrixOrderVisual: View {
    let window = PlaneWindow(xMin: -3, xMax: 3, yMin: -1.5, yMax: 3)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Start: das Einheitsquadrat. D verdoppelt die x-Richtung, R dreht um 90°.",
            "Erst D: Aus dem Quadrat wird ein Rechteck der Breite 2.",
            "Dann R: Das Rechteck wird gedreht – Ergebnis von R · D ist ein hohes Rechteck.",
            "Jetzt umgekehrt, von vorn: Erst R dreht das Quadrat – es bleibt ein Quadrat.",
            "Dann D: Ergebnis von D · R ist ein breites Rechteck. Gestrichelt: R · D zum Vergleich. Also R · D ≠ D · R."
        ]) { phase, size in
            let columns: (CGPoint, CGPoint) = {
                switch phase {
                case 1: return (CGPoint(x: 2, y: 0), CGPoint(x: 0, y: 1))
                case 2: return (CGPoint(x: 0, y: 2), CGPoint(x: -1, y: 0))
                case 3: return (CGPoint(x: 0, y: 1), CGPoint(x: -1, y: 0))
                case 4: return (CGPoint(x: 0, y: 1), CGPoint(x: -2, y: 0))
                default: return (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1))
                }
            }()

            ParallelogramShape(a: CGPoint(x: 0, y: 2), b: CGPoint(x: -1, y: 0), window: window)
                .stroke(VisualColor.extra, style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                .opacity(show(phase == 4))
            MathLabel(text: "R·D", at: CGPoint(x: -0.5, y: 2), color: VisualColor.extra, window: window, size: size, offset: CGSize(width: 0, height: -12))
                .opacity(show(phase == 2 || phase == 4))

            ParallelogramShape(a: columns.0, b: columns.1, window: window)
                .fill(VisualColor.first.opacity(0.25))
            ParallelogramShape(a: columns.0, b: columns.1, window: window)
                .stroke(VisualColor.first, lineWidth: 2)

            MathLabel(text: "D·R", at: CGPoint(x: -1, y: 1), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 0, height: -14))
                .opacity(show(phase == 4))

            Arrow(from: .zero, to: columns.0, color: VisualColor.first, window: window, width: 3)
            Arrow(from: .zero, to: columns.1, color: VisualColor.second, window: window, width: 3)
        }
    }
}

// MARK: - 9. Nicht invertierbar: Die Ebene wird auf eine Gerade gequetscht

private struct SingularMatrixVisual: View {
    let window = PlaneWindow(xMin: -1.5, xMax: 5, yMin: -1.5, yMax: 5)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "A = (1 2; 2 4). Die Spalten (1, 2) und (2, 4) zeigen in dieselbe Richtung – die zweite ist das Doppelte der ersten.",
            "A quetscht die ganze Ebene auf eine Gerade: Das Gitter fällt zusammen, das Quadrat wird zu einer Strecke.",
            "Nimm zwei verschiedene Vektoren p = (2, 0) und q = (0, 1) …",
            "… beide landen bei A · p = A · q = (2, 4). Aus (2, 4) kann man nicht mehr ablesen, woher man kam: A ist nicht umkehrbar."
        ]) { phase, size in
            let gridA = phase >= 1 ? CGPoint(x: 1, y: 2) : CGPoint(x: 1, y: 0)
            let gridB = phase >= 1 ? CGPoint(x: 2, y: 4) : CGPoint(x: 0, y: 1)
            let target = CGPoint(x: 2, y: 4)

            PlaneLineShape(through: .zero, direction: CGPoint(x: 1, y: 2), window: window)
                .stroke(VisualColor.warning.opacity(0.3), lineWidth: 6)
                .opacity(show(phase >= 1))

            AnimatableGridShape(a: gridA, b: gridB, window: window)
                .stroke(VisualColor.first.opacity(0.35), lineWidth: 1)
                .opacity(phase >= 1 ? 0.0 : 1.0)
            ParallelogramShape(a: gridA, b: gridB, window: window)
                .fill(VisualColor.first.opacity(0.2))
            ParallelogramShape(a: gridA, b: gridB, window: window)
                .stroke(VisualColor.first, lineWidth: 2)

            Arrow(from: .zero, to: phase >= 3 ? target : CGPoint(x: 2, y: 0), color: VisualColor.second, window: window)
                .opacity(show(phase >= 2))
            MathLabel(text: phase >= 3 ? "A·p" : "p", at: phase >= 3 ? target : CGPoint(x: 2, y: 0), color: VisualColor.second, window: window, size: size, offset: CGSize(width: 18, height: 12))
                .opacity(show(phase >= 2))
            Arrow(from: .zero, to: phase >= 3 ? target : CGPoint(x: 0, y: 1), color: VisualColor.extra, window: window)
                .opacity(show(phase >= 2))
            MathLabel(text: phase >= 3 ? "A·q" : "q", at: phase >= 3 ? target : CGPoint(x: 0, y: 1), color: VisualColor.extra, window: window, size: size, offset: CGSize(width: -22, height: -8))
                .opacity(show(phase >= 2))

            Dot(at: target, color: VisualColor.warning, window: window, size: size)
                .opacity(show(phase >= 3))
        }
    }
}

// MARK: - Lineare Abbildungen: Animationen

// MARK: - 10. Linearität: erst addieren oder erst abbilden – dasselbe Ergebnis

private struct LinearityCheckVisual: View {
    let window = PlaneWindow(xMin: -1, xMax: 5, yMin: -1, yMax: 5)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "f(x, y) = (2x + y, y). Wir nehmen u = (1, 0) und v = (0, 2).",
            "Weg A, Schritt 1: erst addieren. u + v = (1, 2).",
            "Weg A, Schritt 2: dann abbilden. f(u + v) = (2 · 1 + 2, 2) = (4, 2).",
            "Weg B: erst abbilden, f(u) = (2, 0) und f(v) = (2, 2), dann addieren: (4, 2). Dasselbe Ziel – f ist additiv."
        ]) { phase, size in
            let vStart = phase >= 1 ? CGPoint(x: 1, y: 0) : .zero
            let vEnd = CGPoint(x: vStart.x, y: vStart.y + 2)

            Arrow(from: .zero, to: CGPoint(x: 1, y: 2), color: VisualColor.result, window: window)
                .opacity(show(phase >= 1))
            MathLabel(text: "u+v", at: CGPoint(x: 1, y: 2), color: VisualColor.result, window: window, size: size, offset: CGSize(width: -20, height: -8))
                .opacity(show(phase >= 1))

            Arrow(from: .zero, to: CGPoint(x: 1, y: 0), color: VisualColor.first, window: window)
            MathLabel(text: "u", at: CGPoint(x: 1, y: 0), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 0, height: 14))
            Arrow(from: vStart, to: vEnd, color: VisualColor.second, window: window)
            MathLabel(text: "v", at: vEnd, color: VisualColor.second, window: window, size: size, offset: CGSize(width: -12, height: 0))

            Arrow(from: .zero, to: phase >= 2 ? CGPoint(x: 4, y: 2) : CGPoint(x: 1, y: 2), color: VisualColor.extra, window: window, width: 4)
                .opacity(show(phase >= 2))
            MathLabel(text: "f(u+v)", at: CGPoint(x: 4, y: 2), color: VisualColor.extra, window: window, size: size, offset: CGSize(width: 22, height: -10))
                .opacity(show(phase >= 2))

            Arrow(from: .zero, to: CGPoint(x: 2, y: 0), color: VisualColor.first, window: window, dashed: true)
                .opacity(show(phase >= 3))
            MathLabel(text: "f(u)", at: CGPoint(x: 2, y: 0), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 0, height: 14))
                .opacity(show(phase >= 3))
            Arrow(from: phase >= 3 ? CGPoint(x: 2, y: 0) : .zero,
                  to: phase >= 3 ? CGPoint(x: 4, y: 2) : CGPoint(x: 2, y: 2),
                  color: VisualColor.second, window: window, dashed: true)
                .opacity(show(phase >= 3))
            MathLabel(text: "f(v)", at: CGPoint(x: 3, y: 1), color: VisualColor.second, window: window, size: size, offset: CGSize(width: 16, height: 8))
                .opacity(show(phase >= 3))
        }
    }
}

// MARK: - 11. Kern und Bild

private struct KernelImageVisual: View {
    let window = PlaneWindow(xMin: -3, xMax: 4, yMin: -3, yMax: 4)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "f(x, y) = (x + y, x + y). Die Vektoren p = (2, −2) und q = (−1, 1) liegen auf der Geraden y = −x.",
            "f(p) = (0, 0) und f(q) = (0, 0): Beide werden auf den Nullvektor gequetscht. Diese Gerade ist der Kern.",
            "Nun r = (3, 0) und s = (0, 3). Sie liegen auf einer zum Kern parallelen Geraden (x + y = 3).",
            "f(r) = f(s) = (3, 3): Die ganze Gerade landet in einem Punkt. Alle Bilder liegen auf y = x – das ist das Bild. Dim Kern + Dim Bild = 1 + 1 = 2 = dim ℝ²."
        ]) { phase, size in
            PlaneLineShape(through: .zero, direction: CGPoint(x: 1, y: -1), window: window)
                .stroke(VisualColor.warning.opacity(0.35), lineWidth: 6)
            MathLabel(text: "Kern", at: CGPoint(x: -2, y: 2), color: VisualColor.warning, window: window, size: size, offset: CGSize(width: -14, height: -8))

            PlaneLineShape(through: .zero, direction: CGPoint(x: 1, y: 1), window: window)
                .stroke(VisualColor.result.opacity(0.35), lineWidth: 6)
                .opacity(show(phase >= 2))
            MathLabel(text: "Bild", at: CGPoint(x: -1.5, y: -1.5), color: VisualColor.result, window: window, size: size, offset: CGSize(width: 16, height: 8))
                .opacity(show(phase >= 2))

            PlaneLineShape(through: CGPoint(x: 3, y: 0), direction: CGPoint(x: 1, y: -1), window: window)
                .stroke(VisualColor.extra, style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                .opacity(show(phase >= 2))

            Group {
                Arrow(from: .zero, to: phase >= 1 ? .zero : CGPoint(x: 2, y: -2), color: VisualColor.first, window: window)
                Arrow(from: .zero, to: phase >= 1 ? .zero : CGPoint(x: -1, y: 1), color: VisualColor.second, window: window)
                MathLabel(text: "p", at: CGPoint(x: 2, y: -2), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 12, height: 8))
                    .opacity(show(phase == 0))
                MathLabel(text: "q", at: CGPoint(x: -1, y: 1), color: VisualColor.second, window: window, size: size, offset: CGSize(width: -12, height: -4))
                    .opacity(show(phase == 0))
                MathLabel(text: "f(p) = f(q) = 0", at: .zero, color: VisualColor.warning, window: window, size: size, offset: CGSize(width: 50, height: 16))
                    .opacity(show(phase == 1))
            }
            .opacity(show(phase <= 1))

            Group {
                Arrow(from: .zero, to: phase >= 3 ? CGPoint(x: 3, y: 3) : CGPoint(x: 3, y: 0), color: VisualColor.first, window: window)
                Arrow(from: .zero, to: phase >= 3 ? CGPoint(x: 3, y: 3) : CGPoint(x: 0, y: 3), color: VisualColor.second, window: window)
                MathLabel(text: phase >= 3 ? "f(r)=f(s)" : "r", at: phase >= 3 ? CGPoint(x: 3, y: 3) : CGPoint(x: 3, y: 0), color: VisualColor.first, window: window, size: size, offset: phase >= 3 ? CGSize(width: -34, height: -8) : CGSize(width: 10, height: 12))
                MathLabel(text: "s", at: CGPoint(x: 0, y: 3), color: VisualColor.second, window: window, size: size, offset: CGSize(width: -12, height: -4))
                    .opacity(show(phase == 2))
            }
            .opacity(show(phase >= 2))

            Dot(at: CGPoint(x: 3, y: 3), color: VisualColor.result, window: window, size: size)
                .opacity(show(phase >= 3))
        }
    }
}

// MARK: - 12. Geometrische Abbildungen: Scherung und Spiegelung

/// Zeigt, wohin e₁, e₂, das Gitter und ein Beispielvektor unter einer linearen Abbildung wandern.
/// Phase 1: e₁ → image1, Phase 2: e₂ → image2, Phase 3: Gitter folgt, Phase 4: Beispielvektor.
private struct GridMapVisual: View {
    var window = PlaneWindow(xMin: -1, xMax: 4, yMin: -1, yMax: 4)
    let captions: [String]
    let image1: CGPoint
    let image2: CGPoint
    let sample: CGPoint
    var mirrorDirection: CGPoint? = nil

    var body: some View {
        AnimatedFigure(window: window, captions: captions) { phase, size in
            let col1 = phase >= 1 ? image1 : CGPoint(x: 1, y: 0)
            let col2 = phase >= 2 ? image2 : CGPoint(x: 0, y: 1)
            let gridA = phase >= 3 ? image1 : CGPoint(x: 1, y: 0)
            let gridB = phase >= 3 ? image2 : CGPoint(x: 0, y: 1)
            let sampleImage = CGPoint(
                x: sample.x * image1.x + sample.y * image2.x,
                y: sample.x * image1.y + sample.y * image2.y
            )
            let xPoint = phase >= 4 ? sampleImage : sample

            if let mirror = mirrorDirection {
                PlaneLineShape(through: .zero, direction: mirror, window: window)
                    .stroke(VisualColor.extra, style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                    .opacity(show(phase >= 3))
            }

            AnimatableGridShape(a: gridA, b: gridB, window: window)
                .stroke(VisualColor.first.opacity(0.35), lineWidth: 1)
            ParallelogramShape(a: gridA, b: gridB, window: window)
                .fill(VisualColor.first.opacity(0.18))

            Arrow(from: .zero, to: xPoint, color: VisualColor.result, window: window)
            MathLabel(text: phase >= 4 ? "f(x)" : "x", at: xPoint, color: VisualColor.result, window: window, size: size, offset: CGSize(width: 18, height: -10))

            Arrow(from: .zero, to: col1, color: VisualColor.first, window: window, width: 4)
            MathLabel(text: phase >= 1 ? "f(e₁)" : "e₁", at: col1, color: VisualColor.first, window: window, size: size, offset: CGSize(width: 4, height: 16))
            Arrow(from: .zero, to: col2, color: VisualColor.second, window: window, width: 4)
            MathLabel(text: phase >= 2 ? "f(e₂)" : "e₂", at: col2, color: VisualColor.second, window: window, size: size, offset: CGSize(width: -24, height: -8))
        }
    }
}

// MARK: - 13. Basiswechsel: In der richtigen Basis wird f einfach

private struct BasisChangeVisual: View {
    let window = PlaneWindow(xMin: -2, xMax: 8, yMin: -2, yMax: 8)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Basis B mit b₁ = (1, 1) und b₂ = (1, −1). Der Vektor v = (3, 1) = 2 · b₁ + 1 · b₂ hat die B-Koordinaten (2, 1).",
            "f(x, y) = (2x + y, x + 2y). Es ist f(b₁) = (3, 3) = 3 · b₁: b₁ wird nur gestreckt.",
            "f(b₂) = (1, −1) = 1 · b₂: b₂ bleibt unverändert.",
            "Also f(v) = 2 · 3 · b₁ + 1 · 1 · b₂ = (6, 6) + (1, −1) = (7, 5). In B-Koordinaten: (2, 1) ↦ (6, 1) – einfach komponentenweise mit 3 und 1 multipliziert."
        ]) { phase, size in
            SkewGridShape(a: CGPoint(x: 1, y: 1), b: CGPoint(x: 1, y: -1), window: window)
                .stroke(VisualColor.first.opacity(0.18), lineWidth: 1)

            Arrow(from: .zero, to: CGPoint(x: 3, y: 1), color: VisualColor.extra, window: window)
            MathLabel(text: "v", at: CGPoint(x: 3, y: 1), color: VisualColor.extra, window: window, size: size, offset: CGSize(width: 12, height: 8))

            Arrow(from: .zero, to: CGPoint(x: 3, y: 3), color: VisualColor.first, window: window, dashed: true)
                .opacity(show(phase >= 1))
            MathLabel(text: "f(b₁) = 3·b₁", at: CGPoint(x: 3, y: 3), color: VisualColor.first, window: window, size: size, offset: CGSize(width: -38, height: -10))
                .opacity(show(phase >= 1))

            Arrow(from: .zero, to: CGPoint(x: 1, y: 1), color: VisualColor.first, window: window, width: 4)
            MathLabel(text: "b₁", at: CGPoint(x: 1, y: 1), color: VisualColor.first, window: window, size: size, offset: CGSize(width: -14, height: -2))
            Arrow(from: .zero, to: CGPoint(x: 1, y: -1), color: VisualColor.second, window: window, width: 4)
            MathLabel(text: phase >= 2 ? "b₂ = f(b₂)" : "b₂", at: CGPoint(x: 1, y: -1), color: VisualColor.second, window: window, size: size, offset: CGSize(width: 24, height: 8))

            Arrow(from: .zero, to: phase >= 3 ? CGPoint(x: 6, y: 6) : CGPoint(x: 3, y: 1), color: VisualColor.first, window: window, dashed: true)
                .opacity(show(phase >= 3))
            Arrow(from: CGPoint(x: 6, y: 6), to: phase >= 3 ? CGPoint(x: 7, y: 5) : CGPoint(x: 6, y: 6), color: VisualColor.second, window: window, dashed: true)
                .opacity(show(phase >= 3))
            Arrow(from: .zero, to: phase >= 3 ? CGPoint(x: 7, y: 5) : CGPoint(x: 3, y: 1), color: VisualColor.result, window: window, width: 4)
                .opacity(show(phase >= 3))
            MathLabel(text: "f(v)", at: CGPoint(x: 7, y: 5), color: VisualColor.result, window: window, size: size, offset: CGSize(width: 16, height: 0))
                .opacity(show(phase >= 3))
        }
    }
}

// MARK: - 14. Determinante: Rechenregeln am Parallelogramm

private struct DetRulesVisual: View {
    let window = PlaneWindow(xMin: -1, xMax: 6, yMin: -1, yMax: 6)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Die Spalten a = (1, 0) und b = (1, 2) spannen ein Parallelogramm auf. Seine Fläche: det(a, b) = 1 · 2 − 1 · 0 = 2.",
            "Verdoppeln wir a zu (2, 0), verdoppelt sich die Fläche: det = 2 · 2 − 1 · 0 = 4. Die Determinante ist linear in jeder Spalte.",
            "Schieben wir b längs a nach b + a = (3, 2), bleiben Grundseite und Höhe gleich: Die Fläche bleibt 4.",
            "Kippen wir b auf die Gerade durch a, etwa nach (3, 0), klappt das Parallelogramm zu einer Strecke zusammen: Fläche 0, denn die Spalten sind linear abhängig."
        ]) { phase, size in
            let a = phase >= 1 ? CGPoint(x: 2, y: 0) : CGPoint(x: 1, y: 0)
            let b: CGPoint = phase >= 3 ? CGPoint(x: 3, y: 0) : (phase >= 2 ? CGPoint(x: 3, y: 2) : CGPoint(x: 1, y: 2))
            let area = ["2", "4", "4", "0"][min(phase, 3)]
            let color = phase >= 3 ? VisualColor.warning : VisualColor.first

            ParallelogramShape(a: a, b: b, window: window)
                .fill(color.opacity(0.2))
            ParallelogramShape(a: a, b: b, window: window)
                .stroke(color, lineWidth: 2)
            MathLabel(text: "Fläche " + area, at: CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2 + 0.3), color: color, window: window, size: size, offset: CGSize(width: 0, height: phase >= 3 ? -16 : 0))

            Arrow(from: .zero, to: a, color: VisualColor.first, window: window, width: 4)
            MathLabel(text: "a", at: a, color: VisualColor.first, window: window, size: size, offset: CGSize(width: 4, height: 16))
            Arrow(from: .zero, to: b, color: VisualColor.second, window: window, width: 4)
            MathLabel(text: "b", at: b, color: VisualColor.second, window: window, size: size, offset: CGSize(width: -12, height: -8))
        }
    }
}

// MARK: - Eigenwerte und Eigenvektoren: Animationen

// MARK: - 15. Suche nach Richtungen, die erhalten bleiben

/// Pro Phase ein Testvektor u (mit seiner Geraden) und sein Bild A·u für A = (2 1; 1 2).
private struct EigenSearchVisual: View {
    let window = PlaneWindow(xMin: -2.5, xMax: 4, yMin: -1.5, yMax: 5)

    private let tests: [(CGPoint, CGPoint)] = [
        (CGPoint(x: 1, y: 0), CGPoint(x: 2, y: 1)),
        (CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 2)),
        (CGPoint(x: 1, y: 1), CGPoint(x: 3, y: 3)),
        (CGPoint(x: -1, y: 1), CGPoint(x: -1, y: 1))
    ]

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "A = (2 1; 1 2). Testvektor u = (1, 0) mit seiner Geraden (gestrichelt). A · u = (2, 1) liegt NICHT auf dieser Geraden: Die Richtung ändert sich.",
            "u = (0, 1): A · u = (1, 2). Wieder kippt der Vektor aus seiner Geraden heraus.",
            "u = (1, 1): A · u = (3, 3) = 3·u. Der Vektor bleibt auf seiner Geraden und wird nur verdreifacht – ein Eigenvektor zum Eigenwert 3!",
            "u = (−1, 1): A · u = (−2 + 1, −1 + 2) = (−1, 1) = 1·u. Auch ein Eigenvektor, diesmal zum Eigenwert 1."
        ]) { phase, size in
            let test = tests[min(phase, tests.count - 1)]
            let isEigen = phase >= 2
            let imageColor = isEigen ? VisualColor.result : VisualColor.warning

            PlaneLineShape(through: .zero, direction: test.0, window: window)
                .stroke(isEigen ? VisualColor.result.opacity(0.6) : VisualColor.first.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5, 4]))

            Arrow(from: .zero, to: test.1, color: imageColor, window: window, width: 3)
            MathLabel(text: "A·u", at: test.1, color: imageColor, window: window, size: size, offset: CGSize(width: 18, height: -10))

            Arrow(from: .zero, to: test.0, color: VisualColor.first, window: window, width: 4)
            MathLabel(text: "u", at: test.0, color: VisualColor.first, window: window, size: size, offset: CGSize(width: phase == 3 ? -14 : 12, height: 14))
        }
    }
}

// MARK: - 16. Was der Eigenwert über die Streckung verrät

private struct EigenvalueScalingVisual: View {
    let window = PlaneWindow(xMin: -3, xMax: 5, yMin: -3, yMax: 5)
    private let v = CGPoint(x: 2, y: 1)
    private let lambdas: [CGFloat] = [1, 2, 0.5, -1, 0]
    private let names = ["λ = 1", "λ = 2", "λ = ½", "λ = −1", "λ = 0"]

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Ein Eigenvektor v = (2, 1) und seine Gerade. Ist A v = λ v, so hängt alles nur vom Faktor λ ab. Bei λ = 1 bleibt v unverändert.",
            "λ = 2: A v = 2 v – doppelt so lang, gleiche Richtung.",
            "λ = ½: A v = ½ v – halb so lang, gleiche Richtung.",
            "λ = −1: A v = −v – gleiche Gerade, aber umgeklappt in die Gegenrichtung.",
            "λ = 0: A v = 0 – v wird auf den Nullpunkt gequetscht. Dann ist v ein Vektor im Kern von A."
        ]) { phase, size in
            let lambda = lambdas[min(phase, lambdas.count - 1)]
            let image = CGPoint(x: lambda * v.x, y: lambda * v.y)

            PlaneLineShape(through: .zero, direction: v, window: window)
                .stroke(VisualColor.result.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5, 4]))

            Arrow(from: .zero, to: v, color: VisualColor.first, window: window, width: 6)
                .opacity(0.35)
            MathLabel(text: "v", at: v, color: VisualColor.first, window: window, size: size, offset: CGSize(width: 4, height: 16))

            Arrow(from: .zero, to: image, color: VisualColor.result, window: window, width: 3)
            Dot(at: image, color: VisualColor.result, window: window, size: size)
            MathLabel(text: "A·v  (" + names[min(phase, names.count - 1)] + ")", at: image, color: VisualColor.result, window: window, size: size, offset: CGSize(width: phase == 3 ? 10 : -6, height: phase == 3 ? 18 : -18))
        }
    }
}

// MARK: - 17. det(A − λI) = 0: Das Parallelogramm klappt zusammen

private struct CharPolyCollapseVisual: View {
    let window = PlaneWindow(xMin: -2, xMax: 3.5, yMin: -2, yMax: 3.5)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "λ = 0: A − 0 · I = (2 1; 1 2). Die Spalten (2, 1) und (1, 2) spannen ein Parallelogramm mit Fläche det = 4 − 1 = 3 auf.",
            "λ = 1: A − I = (1 1; 1 1). Beide Spalten sind (1, 1) – das Parallelogramm klappt zusammen, det = 0. Also ist 1 ein Eigenwert!",
            "λ = 2: A − 2I = (0 1; 1 0). Spalten (0, 1) und (1, 0): wieder eine echte Fläche, det = 0 − 1 = −1.",
            "λ = 3: A − 3I = (−1 1; 1 −1). Die Spalten (−1, 1) und (1, −1) sind entgegengesetzt – Fläche 0. Also ist 3 ein Eigenwert!"
        ]) { phase, size in
            let lambda = CGFloat(min(phase, 3))
            let a = CGPoint(x: 2 - lambda, y: 1)
            let b = CGPoint(x: 1, y: 2 - lambda)
            let collapsed = phase == 1 || phase == 3
            let color = collapsed ? VisualColor.warning : VisualColor.first
            let detText = ["det = 3", "det = 0", "det = −1", "det = 0"][min(phase, 3)]

            ParallelogramShape(a: a, b: b, window: window)
                .fill(color.opacity(0.2))
            ParallelogramShape(a: a, b: b, window: window)
                .stroke(color, lineWidth: 2)

            Arrow(from: .zero, to: a, color: VisualColor.first, window: window, width: 4)
            Arrow(from: .zero, to: b, color: VisualColor.second, window: window, width: 3)

            MathLabel(text: "λ = \(Int(lambda)):  " + detText, at: CGPoint(x: 0.75, y: -1.4), color: color, window: window, size: size, offset: .zero)
        }
    }
}

// MARK: - 18. Eigenrichtungen unter der Abbildung

/// Zeigt Eigengeraden einer 2×2-Matrix, dann wird die Abbildung angewendet:
/// Eigenvektoren bleiben auf ihrer Geraden, ein Vergleichsvektor nicht.
private struct EigenMapVisual: View {
    var window = PlaneWindow(xMin: -2, xMax: 4, yMin: -2, yMax: 4)
    let captions: [String]
    let column1: CGPoint
    let column2: CGPoint
    /// Eigenvektoren mit zugehörigem Eigenwert und Beschriftung.
    let eigen: [(vector: CGPoint, lambda: CGFloat, name: String)]
    let sample: CGPoint
    var linesPhase = 1
    var mapPhase = 2

    private func apply(_ p: CGPoint) -> CGPoint {
        CGPoint(x: p.x * column1.x + p.y * column2.x, y: p.x * column1.y + p.y * column2.y)
    }

    var body: some View {
        AnimatedFigure(window: window, captions: captions) { phase, size in
            let mapped = phase >= mapPhase
            let gridA = mapped ? column1 : CGPoint(x: 1, y: 0)
            let gridB = mapped ? column2 : CGPoint(x: 0, y: 1)
            let samplePoint = mapped ? apply(sample) : sample

            AnimatableGridShape(a: gridA, b: gridB, window: window)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            ParallelogramShape(a: gridA, b: gridB, window: window)
                .fill(VisualColor.first.opacity(0.12))

            ForEach(eigen.indices, id: \.self) { i in
                PlaneLineShape(through: .zero, direction: eigen[i].vector, window: window)
                    .stroke(VisualColor.result.opacity(0.55), style: StrokeStyle(lineWidth: 2.5, dash: [6, 4]))
                    .opacity(show(phase >= linesPhase))
            }

            PlaneLineShape(through: .zero, direction: sample, window: window)
                .stroke(VisualColor.warning.opacity(0.35), style: StrokeStyle(lineWidth: 1.5, dash: [3, 4]))
                .opacity(show(phase >= linesPhase))
            Arrow(from: .zero, to: samplePoint, color: VisualColor.warning, window: window, width: 3)
            MathLabel(text: mapped ? "A·x" : "x", at: samplePoint, color: VisualColor.warning, window: window, size: size, offset: CGSize(width: 16, height: 10))

            ForEach(eigen.indices, id: \.self) { i in
                let v = eigen[i].vector
                let target = mapped ? CGPoint(x: eigen[i].lambda * v.x, y: eigen[i].lambda * v.y) : v
                Arrow(from: .zero, to: target, color: i == 0 ? VisualColor.first : VisualColor.second, window: window, width: 4)
                MathLabel(
                    text: mapped ? "A·" + eigen[i].name : eigen[i].name,
                    at: target,
                    color: i == 0 ? VisualColor.first : VisualColor.second,
                    window: window,
                    size: size,
                    offset: i == 0 ? CGSize(width: 18, height: 14) : CGSize(width: -22, height: -10)
                )
            }
        }
    }
}

// MARK: - 19. Wiederholtes Anwenden: Die Richtung läuft zum größten Eigenwert

private struct PowerIterationVisual: View {
    let window = PlaneWindow(xMin: -1, xMax: 4, yMin: -1, yMax: 4)

    /// x, A x, A² x, A³ x für A = (2 1; 1 2) und x = (1, 0).
    private let iterates: [CGPoint] = [
        CGPoint(x: 1, y: 0), CGPoint(x: 2, y: 1), CGPoint(x: 5, y: 4), CGPoint(x: 14, y: 13)
    ]

    private func scaled(_ p: CGPoint) -> CGPoint {
        let length = sqrt(p.x * p.x + p.y * p.y)
        return CGPoint(x: 3 * p.x / length, y: 3 * p.y / length)
    }

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Start: x = (1, 0). Gestrichelt: die Eigengerade zu λ = 3. Alle Pfeile sind auf gleiche Länge gebracht – es geht nur um die Richtung.",
            "A x = (2, 1): Die Richtung dreht sich zur Eigengeraden hin.",
            "A² x = (5, 4): noch näher dran.",
            "A³ x = (14, 13): fast genau auf der Geraden. Der Anteil in Richtung (1, 1) wächst mit 3ᵏ, der Anteil in Richtung (1, −1) bleibt bei 1ᵏ = 1."
        ]) { phase, size in
            PlaneLineShape(through: .zero, direction: CGPoint(x: 1, y: 1), window: window)
                .stroke(VisualColor.result.opacity(0.6), style: StrokeStyle(lineWidth: 2.5, dash: [6, 4]))

            ForEach(0..<iterates.count, id: \.self) { k in
                Arrow(from: .zero, to: scaled(iterates[k]), color: VisualColor.first, window: window, width: k == phase ? 4 : 2)
                    .opacity(k > phase ? 0 : (k == phase ? 1 : 0.3))
            }

            let current = scaled(iterates[min(phase, iterates.count - 1)])
            MathLabel(text: ["x", "A·x", "A²·x", "A³·x"][min(phase, 3)], at: current, color: VisualColor.first, window: window, size: size, offset: CGSize(width: 22, height: 8))
        }
    }
}

// MARK: - Mengen und Abbildungen: Animationen

/// Zeichenfläche ohne Gitter im Seitenverhältnis 1,4 : 1 (Koordinaten 0…14 × 0…10).
private let setWindow = PlaneWindow(xMin: 0, xMax: 14, yMin: 0, yMax: 10)
private let setAspect: CGFloat = 1.4

private func setScale(_ size: CGSize) -> CGFloat { size.width / 14 }

private func circlePath(center: CGPoint, radius: CGFloat, size: CGSize) -> Path {
    let c = setWindow.point(center, in: size)
    let r = radius * setScale(size)
    return Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: 2 * r, height: 2 * r))
}

private func rectPath(from a: CGPoint, to b: CGPoint, size: CGSize) -> Path {
    let p = setWindow.point(a, in: size)
    let q = setWindow.point(b, in: size)
    return Path(roundedRect: CGRect(x: min(p.x, q.x), y: min(p.y, q.y), width: abs(q.x - p.x), height: abs(q.y - p.y)), cornerRadius: 10)
}

/// Kleiner Text an einer Stelle der Zeichenfläche (Mengen-Koordinaten).
private struct SetText: View {
    let text: String
    let at: CGPoint
    let size: CGSize
    var color: Color = .primary
    var fontSize: CGFloat = 15
    var weight: Font.Weight = .semibold
    var italic = false

    var body: some View {
        Group {
            if italic {
                Text(text).font(.system(size: fontSize, weight: weight, design: .serif)).italic()
            } else {
                Text(text).font(.system(size: fontSize, weight: weight, design: .rounded))
            }
        }
        .foregroundColor(color)
        .position(setWindow.point(at, in: size))
    }
}

// MARK: - 20. Mengenoperationen im Venn-Diagramm

private struct VennOperationsVisual: View {
    private let centerA = CGPoint(x: 5.3, y: 5)
    private let centerB = CGPoint(x: 8.7, y: 5)
    private let radius: CGFloat = 3.2

    /// Element, Position, Teilbereich (A nur, beide, B nur, außen).
    private let elements: [(String, CGPoint)] = [
        ("1", CGPoint(x: 3.6, y: 6.2)), ("2", CGPoint(x: 3.8, y: 3.8)),
        ("3", CGPoint(x: 7, y: 6.1)), ("4", CGPoint(x: 7, y: 3.9)),
        ("5", CGPoint(x: 10.2, y: 6.2)), ("6", CGPoint(x: 10.4, y: 3.8)),
        ("7", CGPoint(x: 1.3, y: 1.3)), ("8", CGPoint(x: 12.7, y: 8.7))
    ]

    private let highlighted: [Set<String>] = [
        [], ["3", "4"], ["1", "2", "3", "4", "5", "6"], ["1", "2"], ["5", "6"], ["5", "6", "7", "8"]
    ]

    var body: some View {
        AnimatedFigure(window: setWindow, captions: [
            "Grundmenge U = {1, …, 8}, darin A = {1, 2, 3, 4} (links) und B = {3, 4, 5, 6} (rechts).",
            "A ∩ B = {3, 4}: alles, was in A UND in B liegt – die Überlappung.",
            "A ∪ B = {1, 2, 3, 4, 5, 6}: alles, was in A ODER in B liegt. „Oder“ schließt „beides“ ein.",
            "A \\ B = {1, 2}: in A, aber nicht in B. Man nimmt A und schneidet die Überlappung weg.",
            "B \\ A = {5, 6} – etwas anderes als A \\ B! Die Differenz hängt von der Reihenfolge ab.",
            "Komplement Aᶜ = U \\ A = {5, 6, 7, 8}: alles in der Grundmenge außerhalb von A."
        ], showGrid: false, aspectRatio: setAspect) { phase, size in
            let a = circlePath(center: centerA, radius: radius, size: size)
            let b = circlePath(center: centerB, radius: radius, size: size)
            let u = rectPath(from: CGPoint(x: 0.4, y: 0.4), to: CGPoint(x: 13.6, y: 9.6), size: size)
            let regions: [Path] = [
                Path(), a.intersection(b), a.union(b), a.subtracting(b), b.subtracting(a), u.subtracting(a)
            ]
            let marked = highlighted[min(phase, highlighted.count - 1)]

            u.stroke(Color.secondary.opacity(0.5), lineWidth: 1.5)
            SetText(text: "U", at: CGPoint(x: 1.1, y: 9), size: size, color: .secondary, italic: true)

            ForEach(1..<regions.count, id: \.self) { k in
                regions[k]
                    .fill(VisualColor.result.opacity(0.32))
                    .opacity(show(phase == k))
            }

            a.stroke(VisualColor.first, lineWidth: 2.5)
            b.stroke(VisualColor.second, lineWidth: 2.5)
            SetText(text: "A", at: CGPoint(x: 3.2, y: 8.6), size: size, color: VisualColor.first, fontSize: 18, italic: true)
            SetText(text: "B", at: CGPoint(x: 10.8, y: 8.6), size: size, color: VisualColor.second, fontSize: 18, italic: true)

            ForEach(elements.indices, id: \.self) { i in
                let isMarked = marked.contains(elements[i].0)
                SetText(
                    text: elements[i].0,
                    at: elements[i].1,
                    size: size,
                    color: isMarked ? Color.primary : Color.secondary,
                    fontSize: isMarked ? 19 : 15,
                    weight: isMarked ? .bold : .regular
                )
            }
        }
    }
}

// MARK: - 21. De Morgan: (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ

private struct DeMorganVisual: View {
    private let centerA = CGPoint(x: 5.3, y: 5)
    private let centerB = CGPoint(x: 8.7, y: 5)

    var body: some View {
        AnimatedFigure(window: setWindow, captions: [
            "Linke Seite, Schritt 1: A ∪ B einfärben.",
            "Linke Seite, Schritt 2: (A ∪ B)ᶜ ist alles AUSSERHALB davon (grün).",
            "Rechte Seite, Schritt 1: Aᶜ – alles außerhalb von A (blau schraffiert gedacht).",
            "Rechte Seite, Schritt 2: dazu Bᶜ – alles außerhalb von B (orange). Wo sich beide Farben überlagern, liegt Aᶜ ∩ Bᶜ.",
            "Aᶜ ∩ Bᶜ (grün) ist genau dieselbe Fläche wie (A ∪ B)ᶜ: „nicht in A oder B“ heißt „nicht in A und nicht in B“."
        ], showGrid: false, aspectRatio: setAspect) { phase, size in
            let a = circlePath(center: centerA, radius: 3.2, size: size)
            let b = circlePath(center: centerB, radius: 3.2, size: size)
            let u = rectPath(from: CGPoint(x: 0.4, y: 0.4), to: CGPoint(x: 13.6, y: 9.6), size: size)
            let outside = u.subtracting(a.union(b))

            a.union(b).fill(VisualColor.extra.opacity(0.28)).opacity(show(phase == 0))
            outside.fill(VisualColor.result.opacity(0.4)).opacity(show(phase == 1 || phase == 4))
            u.subtracting(a).fill(VisualColor.first.opacity(0.22)).opacity(show(phase == 2 || phase == 3))
            u.subtracting(b).fill(VisualColor.second.opacity(0.22)).opacity(show(phase == 3))

            u.stroke(Color.secondary.opacity(0.5), lineWidth: 1.5)
            a.stroke(VisualColor.first, lineWidth: 2.5)
            b.stroke(VisualColor.second, lineWidth: 2.5)
            SetText(text: "U", at: CGPoint(x: 1.1, y: 9), size: size, color: .secondary, italic: true)
            SetText(text: "A", at: CGPoint(x: 4, y: 5), size: size, color: VisualColor.first, fontSize: 18, italic: true)
            SetText(text: "B", at: CGPoint(x: 10, y: 5), size: size, color: VisualColor.second, fontSize: 18, italic: true)
        }
    }
}

// MARK: - 22. Potenzmenge als Diagramm

private struct PowerSetVisual: View {
    private let nodes: [(String, CGPoint, Int)] = [
        ("∅", CGPoint(x: 7, y: 1.2), 0),
        ("{1}", CGPoint(x: 2.8, y: 4), 1), ("{2}", CGPoint(x: 7, y: 4), 1), ("{3}", CGPoint(x: 11.2, y: 4), 1),
        ("{1, 2}", CGPoint(x: 2.8, y: 6.6), 2), ("{1, 3}", CGPoint(x: 7, y: 6.6), 2), ("{2, 3}", CGPoint(x: 11.2, y: 6.6), 2),
        ("{1, 2, 3}", CGPoint(x: 7, y: 9.0), 3)
    ]
    /// Kanten: kleinere Menge ⊆ größere Menge, die genau ein Element mehr hat.
    private let edges: [(Int, Int)] = [
        (0, 1), (0, 2), (0, 3),
        (1, 4), (1, 5), (2, 4), (2, 6), (3, 5), (3, 6),
        (4, 7), (5, 7), (6, 7)
    ]

    var body: some View {
        AnimatedFigure(window: setWindow, captions: [
            "A = {1, 2, 3}. Die kleinste Teilmenge ist ∅ – man wählt einfach kein Element aus.",
            "Teilmengen mit genau einem Element: {1}, {2}, {3}. Linien bedeuten „⊆“.",
            "Teilmengen mit zwei Elementen: wieder drei Stück.",
            "Und A selbst. Zusammen 1 + 3 + 3 + 1 = 8 = 2³ Teilmengen. Diese 8 Mengen sind die Elemente von 𝒫(A)."
        ], showGrid: false, aspectRatio: setAspect) { phase, size in
            ForEach(edges.indices, id: \.self) { e in
                let from = nodes[edges[e].0]
                let to = nodes[edges[e].1]
                Path { p in
                    p.move(to: setWindow.point(CGPoint(x: from.1.x, y: from.1.y + 0.45), in: size))
                    p.addLine(to: setWindow.point(CGPoint(x: to.1.x, y: to.1.y - 0.45), in: size))
                }
                .stroke(Color.secondary.opacity(0.45), lineWidth: 1.2)
                .opacity(show(to.2 <= phase))
            }

            ForEach(nodes.indices, id: \.self) { i in
                let node = nodes[i]
                Text(node.0)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(VisualColor.first.opacity(node.2 == 3 ? 0.3 : 0.14)))
                    .overlay(Capsule().stroke(VisualColor.first.opacity(0.6), lineWidth: 1))
                    .position(setWindow.point(node.1, in: size))
                    .opacity(show(node.2 <= phase))
            }
        }
    }
}

// MARK: - 23. Kartesisches Produkt und Graph einer Abbildung

private struct CartesianProductVisual: View {
    let window = PlaneWindow(xMin: -0.8, xMax: 3.8, yMin: -0.8, yMax: 3.8)
    private let graph: Set<String> = ["1,2", "2,1", "3,2"]

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "A = {1, 2, 3} auf der x-Achse, B = {1, 2} auf der y-Achse.",
            "A × B: jedes a ∈ A mit jedem b ∈ B kombiniert – 3 · 2 = 6 Paare, also 6 Punkte.",
            "(1, 2) und (2, 1) sind verschiedene Punkte: Bei Paaren zählt die Reihenfolge.",
            "Die Abbildung f: A → B mit f(1) = 2, f(2) = 1, f(3) = 2 als Punktmenge: In jeder Spalte liegt GENAU EIN Punkt. Das ist der Graph von f – eine Teilmenge von A × B."
        ]) { phase, size in
            ForEach(1...3, id: \.self) { x in
                MathLabel(text: "\(x)", at: CGPoint(x: CGFloat(x), y: 0), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 0, height: 14))
            }
            ForEach(1...2, id: \.self) { y in
                MathLabel(text: "\(y)", at: CGPoint(x: 0, y: CGFloat(y)), color: VisualColor.second, window: window, size: size, offset: CGSize(width: -14, height: 0))
            }

            ForEach(1...3, id: \.self) { x in
                ForEach(1...2, id: \.self) { y in
                    let key = "\(x),\(y)"
                    let inGraph = graph.contains(key)
                    let special = phase == 2 && (key == "1,2" || key == "2,1")
                    let color: Color = phase >= 3 ? (inGraph ? VisualColor.result : Color.secondary) : (special ? VisualColor.extra : VisualColor.first)
                    Dot(at: CGPoint(x: CGFloat(x), y: CGFloat(y)), color: color, window: window, size: size)
                        .opacity(phase == 0 ? 0 : (phase >= 3 && !inGraph ? 0.3 : 1))
                        .scaleEffect(special || (phase >= 3 && inGraph) ? 1.5 : 1)
                    MathLabel(text: "(\(x), \(y))", at: CGPoint(x: CGFloat(x), y: CGFloat(y)), color: color, window: window, size: size, offset: CGSize(width: 0, height: -18))
                        .opacity(phase == 0 ? 0 : (phase >= 3 && !inGraph ? 0.25 : 1))
                }
            }
        }
    }
}

// MARK: - 24. Pfeildiagramme für Abbildungen

struct DiagramArrow {
    let fromColumn: Int
    let from: Int
    let toColumn: Int
    let to: Int
    var color: Color = .appAccentBlue
}

struct DiagramMark {
    let column: Int
    let index: Int
    let color: Color
}

struct DiagramFrame {
    var columns: [[String]]? = nil
    let arrows: [DiagramArrow]
    var marks: [DiagramMark] = []
    var dimmedArrows: [DiagramArrow] = []
    let caption: String
}

private struct DiagramArrowShape: Shape {
    let from: CGPoint
    let to: CGPoint

    func path(in rect: CGRect) -> Path {
        let a = setWindow.point(from, in: rect.size)
        let b = setWindow.point(to, in: rect.size)
        var p = Path()
        p.move(to: a)
        p.addLine(to: b)
        let angle = atan2(b.y - a.y, b.x - a.x)
        let head: CGFloat = 9
        p.move(to: b)
        p.addLine(to: CGPoint(x: b.x - head * cos(angle - .pi / 7), y: b.y - head * sin(angle - .pi / 7)))
        p.move(to: b)
        p.addLine(to: CGPoint(x: b.x - head * cos(angle + .pi / 7), y: b.y - head * sin(angle + .pi / 7)))
        return p
    }
}

private struct ArrowDiagramVisual: View {
    let columns: [[String]]
    let names: [String]
    let frames: [DiagramFrame]

    private func columnX(_ k: Int, of n: Int) -> CGFloat {
        n == 2 ? (k == 0 ? 3.6 : 10.4) : 14 * (CGFloat(k) + 0.5) / CGFloat(n)
    }

    private func spacing(_ m: Int) -> CGFloat { min(1.55, 6.6 / CGFloat(max(m, 1))) }

    private func position(column k: Int, index i: Int, in cols: [[String]]) -> CGPoint {
        let m = cols[k].count
        let sp = spacing(m)
        return CGPoint(x: columnX(k, of: cols.count), y: 4.6 + CGFloat(m - 1) / 2 * sp - CGFloat(i) * sp)
    }

    private func arrowEnds(_ arrow: DiagramArrow, in cols: [[String]]) -> (CGPoint, CGPoint) {
        let p = position(column: arrow.fromColumn, index: arrow.from, in: cols)
        let q = position(column: arrow.toColumn, index: arrow.to, in: cols)
        let dx = q.x - p.x, dy = q.y - p.y
        let len = max(sqrt(dx * dx + dy * dy), 0.001)
        return (CGPoint(x: p.x + 0.55 * dx / len, y: p.y + 0.55 * dy / len),
                CGPoint(x: q.x - 0.6 * dx / len, y: q.y - 0.6 * dy / len))
    }

    var body: some View {
        AnimatedFigure(window: setWindow, captions: frames.map(\.caption), showGrid: false, aspectRatio: setAspect) { phase, size in
            let frame = frames[min(phase, frames.count - 1)]
            let cols = frame.columns ?? columns

            ZStack {
                ForEach(cols.indices, id: \.self) { k in
                    let m = cols[k].count
                    let height = CGFloat(m) * spacing(m) + 0.9
                    let center = setWindow.point(CGPoint(x: columnX(k, of: cols.count), y: 4.6), in: size)
                    Ellipse()
                        .stroke(Color.secondary.opacity(0.5), lineWidth: 1.5)
                        .background(Ellipse().fill(Color.secondary.opacity(0.06)))
                        .frame(width: 2.3 * setScale(size), height: height * setScale(size))
                        .position(center)
                    SetText(text: names[k], at: CGPoint(x: columnX(k, of: cols.count), y: 4.6 + height / 2 + 0.6), size: size, color: .secondary, fontSize: 17, italic: true)
                }

                ForEach(frame.dimmedArrows.indices, id: \.self) { i in
                    let ends = arrowEnds(frame.dimmedArrows[i], in: cols)
                    DiagramArrowShape(from: ends.0, to: ends.1)
                        .stroke(frame.dimmedArrows[i].color.opacity(0.25), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                }

                ForEach(frame.arrows.indices, id: \.self) { i in
                    let ends = arrowEnds(frame.arrows[i], in: cols)
                    DiagramArrowShape(from: ends.0, to: ends.1)
                        .stroke(frame.arrows[i].color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                }

                ForEach(cols.indices, id: \.self) { k in
                    ForEach(cols[k].indices, id: \.self) { i in
                        let mark = frame.marks.first { $0.column == k && $0.index == i }
                        Text(cols[k][i])
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)
                            .frame(width: 28, height: 28)
                            .background(Circle().fill((mark?.color ?? Color.appSurfaceStrong).opacity(mark == nil ? 1 : 0.3)))
                            .overlay(Circle().stroke(mark?.color ?? Color.secondary.opacity(0.4), lineWidth: mark == nil ? 1 : 2.5))
                            .position(setWindow.point(position(column: k, index: i, in: cols), in: size))
                    }
                }
            }
            .id(phase)
            .transition(.opacity)
        }
    }
}

// MARK: - 25. Äquivalenzklassen: Rest beim Teilen durch 3

private struct ModClassesVisual: View {
    private let colors: [Color] = [VisualColor.first, VisualColor.second, VisualColor.result]

    private func position(_ n: Int, phase: Int) -> CGPoint {
        if phase < 2 {
            return CGPoint(x: 1.2 + CGFloat(n) * 1.45, y: 7.2)
        }
        let r = n % 3
        let k = n / 3
        return CGPoint(x: 2.6 + CGFloat(r) * 4.4, y: 4.9 - CGFloat(k) * 1.4)
    }

    var body: some View {
        AnimatedFigure(window: setWindow, captions: [
            "Die Zahlen 0 bis 8. Relation: a ∼ b, wenn a und b beim Teilen durch 3 denselben Rest lassen.",
            "Wir färben nach dem Rest: Rest 0 blau, Rest 1 orange, Rest 2 grün. Gleiche Farbe heißt äquivalent.",
            "Jede Farbe bildet eine Äquivalenzklasse: [0] = {0, 3, 6}, [1] = {1, 4, 7}, [2] = {2, 5, 8}.",
            "Jede Zahl liegt in genau einer Klasse, und keine Klasse ist leer: Die Klassen zerlegen die Menge, ohne Überlappung und ohne Lücke."
        ], showGrid: false, aspectRatio: setAspect) { phase, size in
            ForEach(0..<3, id: \.self) { r in
                RoundedRectangle(cornerRadius: 14)
                    .stroke(colors[r], lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 14).fill(colors[r].opacity(phase >= 3 ? 0.14 : 0.06)))
                    .frame(width: 3.4 * setScale(size), height: 5 * setScale(size))
                    .position(setWindow.point(CGPoint(x: 2.6 + CGFloat(r) * 4.4, y: 3.5), in: size))
                    .opacity(show(phase >= 2))
                SetText(text: "[\(r)]", at: CGPoint(x: 2.6 + CGFloat(r) * 4.4, y: 0.6), size: size, color: colors[r], fontSize: 16)
                    .opacity(show(phase >= 2))
            }

            ForEach(0..<9, id: \.self) { n in
                let colored = phase >= 1
                Text("\(n)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(colored ? .white : .primary)
                    .frame(width: 30, height: 30)
                    .background(Circle().fill(colored ? colors[n % 3] : Color.secondary.opacity(0.15)))
                    .position(setWindow.point(position(n, phase: phase), in: size))
            }
        }
    }
}

// MARK: - Logik: Animationen

// MARK: - 26. Wahrheitstafel der Implikation

private struct ImplicationTableVisual: View {
    private let rows: [(String, String, String)] = [("w", "w", "w"), ("w", "f", "f"), ("f", "w", "w"), ("f", "f", "w")]
    private let columnX: [CGFloat] = [2.8, 6.2, 10.6]
    private let rowY: [CGFloat] = [6.7, 5.0, 3.3, 1.6]

    /// Welche Ergebniszeilen in welcher Phase sichtbar sind und welche hervorgehoben werden.
    private func visible(_ row: Int, phase: Int) -> Bool {
        switch phase {
        case 0: return false
        case 1: return row == 0
        case 2: return row <= 1
        default: return true
        }
    }

    private func highlighted(_ row: Int, phase: Int) -> Bool {
        switch phase {
        case 1: return row == 0
        case 2: return row == 1
        case 3: return row >= 2
        default: return false
        }
    }

    var body: some View {
        AnimatedFigure(window: setWindow, captions: [
            "A: „Es regnet.“ B: „Die Straße ist nass.“ A ⇒ B ist ein Versprechen: „Wenn es regnet, ist die Straße nass.“",
            "Es regnet und die Straße ist nass: Das Versprechen wurde gehalten – A ⇒ B ist wahr.",
            "Es regnet, aber die Straße ist trocken: Das Versprechen ist gebrochen – A ⇒ B ist falsch. Das ist der EINZIGE falsche Fall.",
            "Es regnet nicht: Dann hat das Versprechen gar nichts behauptet. Ob die Straße nass ist (Rasensprenger) oder nicht – gebrochen wurde es nicht. Also wahr.",
            "Ergebnis: A ⇒ B ist nur falsch, wenn A wahr und B falsch ist."
        ], showGrid: false, aspectRatio: setAspect) { phase, size in
            let scale = setScale(size)

            ForEach(0..<4, id: \.self) { r in
                RoundedRectangle(cornerRadius: 8)
                    .fill((r == 1 ? VisualColor.warning : VisualColor.result).opacity(0.2))
                    .frame(width: 12.4 * scale, height: 1.4 * scale)
                    .position(setWindow.point(CGPoint(x: 6.7, y: rowY[r]), in: size))
                    .opacity(show(highlighted(r, phase: phase)))
            }

            Path { p in
                p.move(to: setWindow.point(CGPoint(x: 0.5, y: 7.75), in: size))
                p.addLine(to: setWindow.point(CGPoint(x: 12.9, y: 7.75), in: size))
                p.move(to: setWindow.point(CGPoint(x: 8.4, y: 9.4), in: size))
                p.addLine(to: setWindow.point(CGPoint(x: 8.4, y: 0.7), in: size))
            }
            .stroke(Color.secondary.opacity(0.5), lineWidth: 1.5)

            SetText(text: "A", at: CGPoint(x: columnX[0], y: 8.6), size: size, color: VisualColor.first, fontSize: 19, italic: true)
            SetText(text: "B", at: CGPoint(x: columnX[1], y: 8.6), size: size, color: VisualColor.second, fontSize: 19, italic: true)
            SetText(text: "A ⇒ B", at: CGPoint(x: columnX[2], y: 8.6), size: size, color: .primary, fontSize: 19, italic: true)

            ForEach(0..<4, id: \.self) { r in
                SetText(text: rows[r].0, at: CGPoint(x: columnX[0], y: rowY[r]), size: size, fontSize: 18)
                SetText(text: rows[r].1, at: CGPoint(x: columnX[1], y: rowY[r]), size: size, fontSize: 18)
                SetText(
                    text: rows[r].2,
                    at: CGPoint(x: columnX[2], y: rowY[r]),
                    size: size,
                    color: rows[r].2 == "f" ? VisualColor.warning : VisualColor.result,
                    fontSize: 20,
                    weight: .bold
                )
                .opacity(show(visible(r, phase: phase)))
            }
        }
    }
}

// MARK: - 27. Implikation als Teilmenge: Kontraposition und Umkehrschluss

private struct ImplicationSetsVisual: View {
    var body: some View {
        AnimatedFigure(window: setWindow, captions: [
            "A ⇒ B mit A: „ist ein Quadrat“, B: „ist ein Rechteck“. Jedes Quadrat ist ein Rechteck – die Menge der Quadrate liegt IN der Menge der Rechtecke.",
            "Ein Quadrat (Punkt in A) liegt automatisch auch in B. Das ist die Implikation selbst.",
            "Ein Dreieck liegt außerhalb von B – und damit auch außerhalb von A. Das ist die Kontraposition: ¬B ⇒ ¬A. Sie ist gleichwertig zu A ⇒ B.",
            "Ein 2×3-Rechteck liegt in B, aber nicht in A. Also folgt aus B NICHT A (Umkehrschluss falsch) und aus ¬A NICHT ¬B."
        ], showGrid: false, aspectRatio: setAspect) { phase, size in
            let outer = circlePath(center: CGPoint(x: 7.4, y: 5), radius: 4.3, size: size)
            let inner = circlePath(center: CGPoint(x: 6.2, y: 5), radius: 2.0, size: size)

            outer.fill(VisualColor.second.opacity(0.1))
            outer.stroke(VisualColor.second, lineWidth: 2.5)
            inner.fill(VisualColor.first.opacity(0.18))
            inner.stroke(VisualColor.first, lineWidth: 2.5)
            SetText(text: "B: Rechtecke", at: CGPoint(x: 7.4, y: 8.6), size: size, color: VisualColor.second, fontSize: 15)
            SetText(text: "A: Quadrate", at: CGPoint(x: 6.2, y: 6.3), size: size, color: VisualColor.first, fontSize: 14)

            Group {
                Rectangle().fill(VisualColor.first).frame(width: 18, height: 18)
                    .position(setWindow.point(CGPoint(x: 6.2, y: 4.4), in: size))
                    .opacity(show(phase >= 1))
                Path { p in
                    let a = setWindow.point(CGPoint(x: 1.6, y: 2.0), in: size)
                    p.move(to: CGPoint(x: a.x, y: a.y - 12))
                    p.addLine(to: CGPoint(x: a.x - 11, y: a.y + 9))
                    p.addLine(to: CGPoint(x: a.x + 11, y: a.y + 9))
                    p.closeSubpath()
                }
                .fill(VisualColor.warning)
                .opacity(show(phase >= 2))
                Rectangle().fill(VisualColor.result).frame(width: 30, height: 20)
                    .position(setWindow.point(CGPoint(x: 9.9, y: 4.6), in: size))
                    .opacity(show(phase >= 3))
            }
        }
    }
}

// MARK: - Vollständige Induktion: Animationen

// MARK: - 28. Dominoeffekt

private struct DominoVisual: View {
    private let count = 10

    private func x(_ i: Int, phase: Int) -> CGFloat {
        1.0 + CGFloat(i) * 1.25 + (phase == 5 && i >= 5 ? 1.0 : 0)
    }

    private func fallen(_ i: Int, phase: Int) -> Bool {
        switch phase {
        case 1, 2: return i == 0
        case 3: return true
        case 5: return i < 5
        default: return false
        }
    }

    var body: some View {
        AnimatedFigure(window: setWindow, captions: [
            "Unendlich viele Dominosteine stehen in einer Reihe. Stein n steht für die Aussage A(n).",
            "Induktionsanfang: Der erste Stein fällt um. Das heißt: A(1) ist wahr.",
            "Induktionsschritt: Die Steine stehen so, dass JEDER Stein k beim Umfallen den Stein k + 1 mitreißt. Das heißt: Aus A(k) folgt A(k + 1).",
            "Beides zusammen: Alle Steine fallen, einer nach dem anderen. A(n) gilt für alle n.",
            "Ohne Induktionsanfang fällt gar nichts – obwohl jeder Stein den nächsten umwerfen WÜRDE.",
            "Ohne gültigen Schritt reißt die Kette ab: Hier ist die Lücke nach Stein 5 zu groß. Ab Stein 6 bleibt alles stehen."
        ], showGrid: false, aspectRatio: setAspect) { phase, size in
            let scale = setScale(size)

            Path { p in
                p.move(to: setWindow.point(CGPoint(x: 0.2, y: 2.4), in: size))
                p.addLine(to: setWindow.point(CGPoint(x: 13.8, y: 2.4), in: size))
            }
            .stroke(Color.secondary.opacity(0.5), lineWidth: 2)

            ForEach(0..<count, id: \.self) { i in
                let isPair = phase == 2 && (i == 3 || i == 4)
                let color = isPair ? VisualColor.second : (fallen(i, phase: phase) ? VisualColor.result : VisualColor.first)
                RoundedRectangle(cornerRadius: 3)
                    .fill(color)
                    .frame(width: 0.38 * scale, height: 3.0 * scale)
                    .rotationEffect(.degrees(fallen(i, phase: phase) ? 62 : 0), anchor: .bottomTrailing)
                    .animation(.easeIn(duration: 0.3).delay(phase == 3 ? Double(i) * 0.18 : 0), value: phase)
                    .position(setWindow.point(CGPoint(x: x(i, phase: phase), y: 3.9), in: size))
                SetText(text: i == count - 1 ? "…" : "\(i + 1)", at: CGPoint(x: x(i, phase: phase), y: 1.6), size: size, color: .secondary, fontSize: 14)
            }

            SetText(text: "k", at: CGPoint(x: x(3, phase: phase), y: 6.6), size: size, color: VisualColor.second, fontSize: 17, italic: true)
                .opacity(show(phase == 2))
            SetText(text: "k + 1", at: CGPoint(x: x(4, phase: phase) + 0.4, y: 6.6), size: size, color: VisualColor.second, fontSize: 17, italic: true)
                .opacity(show(phase == 2))
            SetText(text: "Lücke!", at: CGPoint(x: x(5, phase: phase) - 0.9, y: 6.4), size: size, color: VisualColor.warning, fontSize: 16)
                .opacity(show(phase == 5))
        }
    }
}

// MARK: - 29. Gaußsche Summenformel als Treppe

private struct GaussSumVisual: View {
    let window = PlaneWindow(xMin: -0.5, xMax: 5.7, yMin: -0.5, yMax: 5.7)

    private func cells(_ columns: [(Int, Int, Int)], size: CGSize) -> Path {
        Path { p in
            for (column, from, to) in columns {
                for row in from..<to {
                    let a = window.point(CGPoint(x: CGFloat(column), y: CGFloat(row + 1)), in: size)
                    let b = window.point(CGPoint(x: CGFloat(column + 1), y: CGFloat(row)), in: size)
                    p.addRect(CGRect(x: a.x + 1.5, y: a.y + 1.5, width: b.x - a.x - 3, height: b.y - a.y - 3))
                }
            }
        }
    }

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "1 + 2 + 3 + 4 als Treppe: Spalte k hat k Kästchen.",
            "Eine zweite Treppe, auf den Kopf gestellt, passt genau in die Lücke darüber.",
            "Zusammen ergeben beide ein Rechteck aus 4 · 5 = 20 Kästchen. Eine Treppe hat also 20 / 2 = 10. Allgemein: 1 + 2 + … + n = n(n + 1)/2.",
            "So sieht der Induktionsschritt aus: Von n = 4 zu n = 5 kommt genau eine neue Spalte mit 5 Kästchen dazu. Also S(5) = S(4) + 5 = 15."
        ]) { phase, size in
            cells([(0, 0, 1), (1, 0, 2), (2, 0, 3), (3, 0, 4)], size: size)
                .fill(VisualColor.first.opacity(0.75))
            cells([(0, 1, 5), (1, 2, 5), (2, 3, 5), (3, 4, 5)], size: size)
                .fill(VisualColor.second.opacity(0.7))
                .opacity(show(phase == 1 || phase == 2))
            cells([(4, 0, 5)], size: size)
                .fill(VisualColor.result.opacity(0.8))
                .opacity(show(phase == 3))

            Path { p in
                let a = window.point(CGPoint(x: 0, y: 5), in: size)
                let b = window.point(CGPoint(x: 4, y: 0), in: size)
                p.addRect(CGRect(x: a.x, y: a.y, width: b.x - a.x, height: b.y - a.y))
            }
            .stroke(VisualColor.extra, lineWidth: 3)
            .opacity(show(phase == 2))

            MathLabel(text: "n = 4", at: CGPoint(x: 2, y: 0), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 0, height: 14))
            MathLabel(text: "n + 1 = 5", at: CGPoint(x: 0, y: 2.5), color: VisualColor.extra, window: window, size: size, offset: CGSize(width: -2, height: 0))
                .opacity(show(phase == 2))
            MathLabel(text: "+5", at: CGPoint(x: 4.5, y: 5), color: VisualColor.result, window: window, size: size, offset: CGSize(width: 0, height: -14))
                .opacity(show(phase == 3))
        }
    }
}

// MARK: - Grundlagen: Binomische Formeln

private func unitRect(_ x0: CGFloat, _ y0: CGFloat, _ x1: CGFloat, _ y1: CGFloat, window: PlaneWindow, size: CGSize) -> Path {
    let a = window.point(CGPoint(x: x0, y: y1), in: size)
    let b = window.point(CGPoint(x: x1, y: y0), in: size)
    return Path(CGRect(x: a.x, y: a.y, width: b.x - a.x, height: b.y - a.y))
}

// MARK: - 30. (a + b)² als Fläche

private struct BinomialSquareVisual: View {
    let window = PlaneWindow(xMin: -0.8, xMax: 4.6, yMin: -0.8, yMax: 4.6)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Ein Quadrat mit der Seitenlänge a + b (hier a = 3, b = 1). Seine Fläche ist (a + b)².",
            "Unten links passt ein Quadrat a × a: Fläche a².",
            "Zwei Rechtecke a × b: zusammen 2ab. Genau dieser „gemischte“ Teil wird beim Fehler (a + b)² = a² + b² vergessen.",
            "Oben rechts bleibt ein kleines Quadrat b × b. Zusammen: (a + b)² = a² + 2ab + b². Hier: 16 = 9 + 6 + 1."
        ]) { phase, size in
            unitRect(0, 0, 3, 3, window: window, size: size).fill(VisualColor.first.opacity(0.45)).opacity(show(phase >= 1))
            unitRect(3, 0, 4, 3, window: window, size: size).fill(VisualColor.second.opacity(0.5)).opacity(show(phase >= 2))
            unitRect(0, 3, 3, 4, window: window, size: size).fill(VisualColor.second.opacity(0.5)).opacity(show(phase >= 2))
            unitRect(3, 3, 4, 4, window: window, size: size).fill(VisualColor.result.opacity(0.55)).opacity(show(phase >= 3))
            unitRect(0, 0, 4, 4, window: window, size: size).stroke(Color.primary.opacity(0.7), lineWidth: 2)

            MathLabel(text: "a", at: CGPoint(x: 1.5, y: 0), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 0, height: 14))
            MathLabel(text: "b", at: CGPoint(x: 3.5, y: 0), color: VisualColor.second, window: window, size: size, offset: CGSize(width: 0, height: 14))
            MathLabel(text: "a", at: CGPoint(x: 0, y: 1.5), color: VisualColor.first, window: window, size: size, offset: CGSize(width: -14, height: 0))
            MathLabel(text: "b", at: CGPoint(x: 0, y: 3.5), color: VisualColor.second, window: window, size: size, offset: CGSize(width: -14, height: 0))

            MathLabel(text: "a²", at: CGPoint(x: 1.5, y: 1.5), color: .primary, window: window, size: size, offset: .zero).opacity(show(phase >= 1))
            MathLabel(text: "ab", at: CGPoint(x: 3.5, y: 1.5), color: .primary, window: window, size: size, offset: .zero).opacity(show(phase >= 2))
            MathLabel(text: "ab", at: CGPoint(x: 1.5, y: 3.5), color: .primary, window: window, size: size, offset: .zero).opacity(show(phase >= 2))
            MathLabel(text: "b²", at: CGPoint(x: 3.5, y: 3.5), color: .primary, window: window, size: size, offset: .zero).opacity(show(phase >= 3))
        }
    }
}

// MARK: - 31. a² − b² = (a + b)(a − b) durch Umlegen

private struct BinomialDifferenceVisual: View {
    let window = PlaneWindow(xMin: -0.8, xMax: 4.6, yMin: -0.8, yMax: 4.6)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Ein Quadrat a × a (hier a = 3) hat die Fläche a².",
            "Wir schneiden oben rechts ein Quadrat b × b weg (hier b = 1). Übrig bleibt eine L-Form mit der Fläche a² − b².",
            "Die L-Form zerlegen wir: unten ein Rechteck a × (a − b), oben ein Streifen (a − b) × b.",
            "Den Streifen drehen und rechts anlegen: Es entsteht ein Rechteck (a + b) × (a − b). Also a² − b² = (a + b)(a − b). Hier: 9 − 1 = 4 · 2."
        ]) { phase, size in
            let scale = size.width / (window.xMax - window.xMin)
            unitRect(0, 0, 3, 3, window: window, size: size).fill(VisualColor.first.opacity(0.4)).opacity(show(phase == 0))
            unitRect(0, 0, 3, 2, window: window, size: size).fill(VisualColor.first.opacity(0.45)).opacity(show(phase >= 1))
            unitRect(2, 2, 3, 3, window: window, size: size)
                .stroke(VisualColor.warning, style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                .opacity(show(phase >= 1 && phase <= 2))

            let stripCenter = phase >= 3 ? CGPoint(x: 3.5, y: 1) : CGPoint(x: 1, y: 2.5)
            RoundedRectangle(cornerRadius: 2)
                .fill(VisualColor.second.opacity(phase >= 2 ? 0.6 : 0.45))
                .overlay(RoundedRectangle(cornerRadius: 2).stroke(phase >= 2 ? VisualColor.second : .clear, lineWidth: 2))
                .frame(width: 2 * scale, height: 1 * scale)
                .rotationEffect(.degrees(phase >= 3 ? 90 : 0))
                .position(window.point(stripCenter, in: size))
                .opacity(show(phase >= 1))

            unitRect(0, 0, 4, 2, window: window, size: size)
                .stroke(VisualColor.result, lineWidth: 3)
                .opacity(show(phase >= 3))

            MathLabel(text: "a", at: CGPoint(x: 1.5, y: 0), color: VisualColor.first, window: window, size: size, offset: CGSize(width: 0, height: 14)).opacity(show(phase <= 2))
            MathLabel(text: "a + b", at: CGPoint(x: 2, y: 0), color: VisualColor.result, window: window, size: size, offset: CGSize(width: 0, height: 14)).opacity(show(phase >= 3))
            MathLabel(text: "a − b", at: CGPoint(x: 0, y: 1), color: VisualColor.first, window: window, size: size, offset: CGSize(width: -22, height: 0)).opacity(show(phase >= 2))
            MathLabel(text: "b²", at: CGPoint(x: 2.5, y: 2.5), color: VisualColor.warning, window: window, size: size, offset: .zero).opacity(show(phase == 1 || phase == 2))
        }
    }
}

// MARK: - 32. Euklidischer Algorithmus als Quadrat-Zerlegung

private struct EuclidRectangleVisual: View {
    let window = PlaneWindow(xMin: -0.6, xMax: 12.6, yMin: -2.2, yMax: 11.0)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Ein Rechteck 12 × 9. Gesucht ist das größte Quadrat, mit dem man es lückenlos auslegen kann. Seine Seitenlänge ist ggT(12, 9).",
            "Schneide das größte Quadrat ab, das hineinpasst: 9 × 9. Das ist der Schritt 12 = 1 · 9 + 3. Übrig bleibt ein Streifen 3 × 9.",
            "Im Streifen passen genau drei Quadrate 3 × 3: 9 = 3 · 3 + 0. Der Rest ist 0 – der Algorithmus endet.",
            "Mit 3 × 3-Quadraten lässt sich das ganze Rechteck auslegen, mit keinem größeren Quadrat. Also ggT(12, 9) = 3 – der letzte Rest ungleich 0."
        ], showGrid: false) { phase, size in
            unitRect(0, 0, 9, 9, window: window, size: size).fill(VisualColor.first.opacity(0.35)).opacity(show(phase >= 1))
            ForEach(0..<3, id: \.self) { k in
                unitRect(9, CGFloat(3 * k), 12, CGFloat(3 * k + 3), window: window, size: size)
                    .fill(VisualColor.second.opacity(0.45))
                    .opacity(show(phase >= 2))
                unitRect(9, CGFloat(3 * k), 12, CGFloat(3 * k + 3), window: window, size: size)
                    .stroke(VisualColor.second, lineWidth: 2)
                    .opacity(show(phase >= 2))
            }
            Path { p in
                for k in 1..<4 {
                    let x = CGFloat(3 * k)
                    p.move(to: window.point(CGPoint(x: x, y: 0), in: size))
                    p.addLine(to: window.point(CGPoint(x: x, y: 9), in: size))
                }
                for k in 1..<3 {
                    let y = CGFloat(3 * k)
                    p.move(to: window.point(CGPoint(x: 0, y: y), in: size))
                    p.addLine(to: window.point(CGPoint(x: 9, y: y), in: size))
                }
            }
            .stroke(VisualColor.result, lineWidth: 2)
            .opacity(show(phase >= 3))
            unitRect(0, 0, 12, 9, window: window, size: size).stroke(Color.primary.opacity(0.7), lineWidth: 2)
            unitRect(0, 0, 9, 9, window: window, size: size).stroke(VisualColor.first, lineWidth: 2.5).opacity(show(phase >= 1))

            MathLabel(text: "12", at: CGPoint(x: 6, y: 0), color: .primary, window: window, size: size, offset: CGSize(width: 0, height: 14))
            MathLabel(text: "9", at: CGPoint(x: 0, y: 4.5), color: .primary, window: window, size: size, offset: CGSize(width: -12, height: 0))
            MathLabel(text: "9 × 9", at: CGPoint(x: 4.5, y: 4.5), color: VisualColor.first, window: window, size: size, offset: .zero).opacity(show(phase >= 1 && phase < 3))
            MathLabel(text: "3", at: CGPoint(x: 10.5, y: 9), color: VisualColor.second, window: window, size: size, offset: CGSize(width: 0, height: -14)).opacity(show(phase >= 1))
        }
    }
}

// MARK: - Gruppen: Symmetrien des Dreiecks

private struct TriangleSymmetryVisual: View {
    let window = PlaneWindow(xMin: -1.6, xMax: 1.6, yMin: -1.6, yMax: 1.6)

    /// Zustand: erst Drehung um `angle` (gegen den Uhrzeigersinn), dann evtl. Spiegelung an der senkrechten Achse.
    private let states: [(Bool, Double)] = [(false, 0), (false, 120), (true, 120), (true, 0), (true, -120)]
    private let captions = [
        "Ein gleichseitiges Dreieck mit den Ecken 1, 2, 3. Eine Symmetrie bildet das Dreieck auf sich selbst ab – nur die Ecken tauschen die Plätze.",
        "r: Drehung um 120° gegen den Uhrzeigersinn.",
        "Danach s: Spiegelung an der senkrechten Achse. Ergebnis von „erst r, dann s“, also s ∘ r: oben 3, links 2, rechts 1.",
        "Jetzt die andere Reihenfolge, von vorn: erst s …",
        "… dann r. Ergebnis r ∘ s: oben 2, links 1, rechts 3. Grau: das Ergebnis von s ∘ r. Verschieden – die Gruppe ist nicht kommutativ!"
    ]
    private let colors: [Color] = [VisualColor.first, VisualColor.second, VisualColor.result]

    private func vertex(_ k: Int, radius: CGFloat) -> CGPoint {
        let theta = (90.0 + 120.0 * Double(k)) * Double.pi / 180.0
        return CGPoint(x: radius * CGFloat(cos(theta)), y: radius * CGFloat(sin(theta)))
    }

    private func trianglePath(_ size: CGSize) -> Path {
        var p = Path()
        p.move(to: window.point(vertex(0, radius: 1.05), in: size))
        p.addLine(to: window.point(vertex(1, radius: 1.05), in: size))
        p.addLine(to: window.point(vertex(2, radius: 1.05), in: size))
        p.closeSubpath()
        return p
    }

    private func vertexLabel(_ k: Int, mirrored: Bool, angle: Double, size: CGSize) -> some View {
        let diameter: CGFloat = 0.24 * size.width / 3.2
        return Text("\(k + 1)")
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(width: diameter, height: diameter)
            .background(Circle().fill(colors[k]))
            .scaleEffect(x: mirrored ? -1 : 1)
            .rotationEffect(.degrees(angle))
            .position(window.point(vertex(k, radius: 1.05), in: size))
    }

    private func ghostLabel(_ k: Int, size: CGSize) -> some View {
        Text(["3", "2", "1"][k])
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .foregroundColor(.secondary.opacity(0.6))
            .position(window.point(vertex(k, radius: 1.38), in: size))
    }

    private func figure(phase: Int, size: CGSize) -> some View {
        let state = states[min(phase, states.count - 1)]
        let mirrored = state.0
        let angle = state.1
        return ZStack {
            trianglePath(size).fill(VisualColor.first.opacity(0.18))
            trianglePath(size).stroke(VisualColor.first, lineWidth: 2.5)
            ForEach(0..<3, id: \.self) { k in
                vertexLabel(k, mirrored: mirrored, angle: angle, size: size)
            }
        }
        .frame(width: size.width, height: size.height)
        .rotationEffect(.degrees(-angle))
        .scaleEffect(x: mirrored ? -1 : 1)
    }

    var body: some View {
        AnimatedFigure(window: window, captions: captions, showGrid: false) { phase, size in
            Path { p in
                p.move(to: window.point(CGPoint(x: 0, y: -1.5), in: size))
                p.addLine(to: window.point(CGPoint(x: 0, y: 1.5), in: size))
            }
            .stroke(VisualColor.extra.opacity(0.6), style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
            MathLabel(text: "s", at: CGPoint(x: 0.12, y: 1.45), color: VisualColor.extra, window: window, size: size, offset: .zero)

            ForEach(0..<3, id: \.self) { k in
                ghostLabel(k, size: size).opacity(show(phase == 4))
            }
            figure(phase: phase, size: size)
        }
    }
}

// MARK: - Restklassen auf der Uhr

struct ClockArc {
    let from: Int
    let steps: Int
    var color: Color = .appAccentBlue
}

struct ClockFrame {
    var arcs: [ClockArc] = []
    var marks: [(Int, Color)] = []
    let caption: String
}

private struct ClockVisual: View {
    let n: Int
    let frames: [ClockFrame]
    let window = PlaneWindow(xMin: -1.5, xMax: 1.5, yMin: -1.5, yMax: 1.5)

    /// Winkel (mathematisch) der Zahl k: 0 oben, im Uhrzeigersinn.
    private func angle(_ k: Double) -> Double { (90 - 360 * k / Double(n)) * .pi / 180 }

    private func point(_ k: Double, radius: CGFloat) -> CGPoint {
        CGPoint(x: radius * CGFloat(cos(angle(k))), y: radius * CGFloat(sin(angle(k))))
    }

    var body: some View {
        AnimatedFigure(window: window, captions: frames.map(\.caption), showGrid: false) { phase, size in
            let frame = frames[min(phase, frames.count - 1)]

            Circle()
                .stroke(Color.secondary.opacity(0.4), lineWidth: 2)
                .frame(width: 2.0 * size.width / 3, height: 2.0 * size.width / 3)
                .position(window.point(.zero, in: size))

            ZStack {
                ForEach(frame.arcs.indices, id: \.self) { i in
                    let arc = frame.arcs[i]
                    let radius: CGFloat = 0.72 - CGFloat(i % 3) * 0.06
                    Path { p in
                        let count = max(arc.steps * 12, 12)
                        for t in 0...count {
                            let k = Double(arc.from) + Double(arc.steps) * Double(t) / Double(count)
                            let pt = window.point(point(k, radius: radius), in: size)
                            if t == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
                        }
                        let end = Double(arc.from + arc.steps)
                        let tip = window.point(point(end, radius: radius), in: size)
                        let before = window.point(point(end - 0.15, radius: radius), in: size)
                        let a = atan2(tip.y - before.y, tip.x - before.x)
                        p.move(to: tip)
                        p.addLine(to: CGPoint(x: tip.x - 9 * cos(a - .pi / 7), y: tip.y - 9 * sin(a - .pi / 7)))
                        p.move(to: tip)
                        p.addLine(to: CGPoint(x: tip.x - 9 * cos(a + .pi / 7), y: tip.y - 9 * sin(a + .pi / 7)))
                    }
                    .stroke(arc.color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                }

                ForEach(0..<n, id: \.self) { k in
                    let mark = frame.marks.first { $0.0 == k }?.1
                    Text("\(k)")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(mark == nil ? .primary : .white)
                        .frame(width: 30, height: 30)
                        .background(Circle().fill(mark ?? Color.appSurfaceStrong))
                        .overlay(Circle().stroke(mark ?? Color.secondary.opacity(0.5), lineWidth: 1.5))
                        .position(window.point(point(Double(k), radius: 1.0), in: size))
                }
            }
            .id(phase)
            .transition(.opacity)
        }
    }
}

// MARK: - Komplexe Zahlen

private struct ComplexOperationsVisual: View {
    let window = PlaneWindow(xMin: -2, xMax: 4, yMin: -2, yMax: 4)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "In der Gaußschen Zahlenebene ist z = 2 + i der Punkt (2, 1) und w = 1 + 2i der Punkt (1, 2). Waagerecht: Realteil, senkrecht: Imaginärteil.",
            "Addition wie bei Vektoren: z + w = 3 + 3i. Man hängt w an die Spitze von z.",
            "Konjugieren: z̄ = 2 − i ist das Spiegelbild von z an der reellen Achse.",
            "Multiplikation mit i: i · z = 2i + i² = −1 + 2i. Das ist z, um 90° gegen den Uhrzeigersinn gedreht!"
        ]) { phase, size in
            let z = CGPoint(x: 2, y: 1)
            let w = CGPoint(x: 1, y: 2)

            Arrow(from: .zero, to: z, color: VisualColor.first, window: window, width: 3.5)
            MathLabel(text: "z", at: z, color: VisualColor.first, window: window, size: size, offset: CGSize(width: 12, height: 6))
            Arrow(from: .zero, to: w, color: VisualColor.second, window: window, width: 3.5)
                .opacity(show(phase <= 1))
            MathLabel(text: "w", at: w, color: VisualColor.second, window: window, size: size, offset: CGSize(width: -12, height: -6))
                .opacity(show(phase <= 1))

            Arrow(from: z, to: CGPoint(x: 3, y: 3), color: VisualColor.second, window: window, dashed: true)
                .opacity(show(phase == 1))
            Arrow(from: .zero, to: CGPoint(x: 3, y: 3), color: VisualColor.result, window: window, width: 3.5)
                .opacity(show(phase == 1))
            MathLabel(text: "z + w", at: CGPoint(x: 3, y: 3), color: VisualColor.result, window: window, size: size, offset: CGSize(width: 18, height: -10))
                .opacity(show(phase == 1))

            Arrow(from: .zero, to: CGPoint(x: 2, y: -1), color: VisualColor.extra, window: window, width: 3.5)
                .opacity(show(phase == 2))
            MathLabel(text: "z̄", at: CGPoint(x: 2, y: -1), color: VisualColor.extra, window: window, size: size, offset: CGSize(width: 12, height: 8))
                .opacity(show(phase == 2))

            Arrow(from: .zero, to: phase >= 3 ? CGPoint(x: -1, y: 2) : z, color: VisualColor.result, window: window, width: 3.5)
                .opacity(show(phase >= 3))
            MathLabel(text: "i·z", at: CGPoint(x: -1, y: 2), color: VisualColor.result, window: window, size: size, offset: CGSize(width: -12, height: -10))
                .opacity(show(phase >= 3))
        }
    }
}

private struct AngleArcShape: Shape {
    let from: Double
    let to: Double
    let radius: CGFloat
    let window: PlaneWindow

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let count = 40
        for t in 0...count {
            let a = (from + (to - from) * Double(t) / Double(count)) * .pi / 180
            let pt = window.point(CGPoint(x: radius * CGFloat(cos(a)), y: radius * CGFloat(sin(a))), in: rect.size)
            if t == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        return p
    }
}

private struct ComplexMultiplicationVisual: View {
    let window = PlaneWindow(xMin: -1.6, xMax: 3.0, yMin: -0.8, yMax: 3.8)

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "z = 1 + i hat den Betrag √2 und den Winkel 45°.",
            "w = 1 + √3·i hat den Betrag 2 und den Winkel 60°.",
            "Das Produkt z · w hat den Winkel 45° + 60° = 105° und den Betrag √2 · 2 = 2√2 ≈ 2,83. Winkel addieren sich, Beträge multiplizieren sich.",
            "Zur Kontrolle algebraisch: (1 + i)(1 + √3 i) = (1 − √3) + (1 + √3) i ≈ −0,73 + 2,73 i – genau der grüne Punkt."
        ]) { phase, size in
            let z = CGPoint(x: 1, y: 1)
            let w = CGPoint(x: 1, y: sqrt(3))
            let zw = CGPoint(x: 1 - sqrt(3), y: 1 + sqrt(3))

            AngleArcShape(from: 0, to: 45, radius: 0.45, window: window)
                .stroke(VisualColor.first, lineWidth: 2)
            Arrow(from: .zero, to: z, color: VisualColor.first, window: window, width: 3.5)
            MathLabel(text: "z", at: z, color: VisualColor.first, window: window, size: size, offset: CGSize(width: 12, height: 4))

            AngleArcShape(from: 0, to: 60, radius: 0.7, window: window)
                .stroke(VisualColor.second, lineWidth: 2)
                .opacity(show(phase >= 1))
            Arrow(from: .zero, to: w, color: VisualColor.second, window: window, width: 3.5)
                .opacity(show(phase >= 1))
            MathLabel(text: "w", at: w, color: VisualColor.second, window: window, size: size, offset: CGSize(width: 12, height: -4))
                .opacity(show(phase >= 1))

            AngleArcShape(from: 0, to: 105, radius: 1.0, window: window)
                .stroke(VisualColor.result, style: StrokeStyle(lineWidth: 2, dash: [4, 3]))
                .opacity(show(phase >= 2))
            Arrow(from: .zero, to: phase >= 2 ? zw : z, color: VisualColor.result, window: window, width: 3.5)
                .opacity(show(phase >= 2))
            MathLabel(text: "z·w", at: zw, color: VisualColor.result, window: window, size: size, offset: CGSize(width: -16, height: -10))
                .opacity(show(phase >= 2))
            Dot(at: zw, color: VisualColor.result, window: window, size: size)
                .opacity(show(phase >= 3))
        }
    }
}

private struct RootsOfUnityVisual: View {
    let window = PlaneWindow(xMin: -1.6, xMax: 1.6, yMin: -1.6, yMax: 1.6)

    private func root(_ k: Int) -> CGPoint {
        let a = Double(k) * .pi / 3
        return CGPoint(x: cos(a), y: sin(a))
    }

    var body: some View {
        AnimatedFigure(window: window, captions: [
            "Gesucht: alle Lösungen von z⁶ = 1. Der Einheitskreis enthält alle Zahlen mit Betrag 1.",
            "ζ = cos 60° + i sin 60° = ½ + (√3/2) i. Sechsmal 60° ergibt 360°, also ζ⁶ = 1.",
            "Die Potenzen ζ, ζ², …, ζ⁶ = 1 laufen in 60°-Schritten um den Kreis. Jede ist eine Lösung.",
            "Die sechs Lösungen bilden ein regelmäßiges Sechseck. Allgemein hat zⁿ = 1 genau n Lösungen – die Ecken eines regelmäßigen n-Ecks."
        ]) { phase, size in
            let scale = size.width / (window.xMax - window.xMin)
            Circle()
                .stroke(VisualColor.first.opacity(0.5), lineWidth: 2)
                .frame(width: 2 * scale, height: 2 * scale)
                .position(window.point(.zero, in: size))

            Path { p in
                for k in 0...6 {
                    let pt = window.point(root(k % 6), in: size)
                    if k == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
                }
            }
            .stroke(VisualColor.result, lineWidth: 2.5)
            .opacity(show(phase >= 3))

            ForEach(0..<6, id: \.self) { k in
                let visible = phase >= 2 || (phase == 1 && (k == 1 || k == 0))
                Dot(at: root(k), color: k == 0 ? VisualColor.second : VisualColor.result, window: window, size: size)
                    .opacity(show(visible))
                MathLabel(text: k == 0 ? "1" : (k == 1 ? "ζ" : "ζ\(["", "", "²", "³", "⁴", "⁵"][k])"), at: root(k), color: VisualColor.result, window: window, size: size,
                          offset: CGSize(width: root(k).x * 22, height: -root(k).y * 22))
                    .opacity(show(visible))
            }
            AngleArcShape(from: 0, to: 60, radius: 0.35, window: window)
                .stroke(VisualColor.second, lineWidth: 2)
                .opacity(show(phase >= 1))
            Arrow(from: .zero, to: root(1), color: VisualColor.second, window: window, width: 2.5)
                .opacity(show(phase == 1))
        }
    }
}
