//
//  ContentView.swift
//  UniMathe
//
//  Created by Benedikt Held on 24.04.25.
//

import SwiftUI

struct MathTopic: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let description: String
    var subTopics: [MathTopic]?
    var markdownContent: String?  // New property for Markdown content
}

struct ContentView: View {
    let topics = [
        MathTopic(
            title: "Grundlagen der Höheren Mathematik",
            icon: "book.fill",
            description: "Die grundlegenden Konzepte und Methoden der höheren Mathematik.",
            subTopics: [
                MathTopic(
                    title: "Mengen und Abbildungen",
                    icon: "circle.grid.2x2.fill",
                    description: "Grundlegende Konzepte der Mengenlehre und Abbildungen zwischen Mengen. Eine Menge ist eine Zusammenfassung von unterscheidbaren Objekten zu einer Gesamtheit. Abbildungen beschreiben Beziehungen zwischen Mengen.",
                    markdownContent: """
                    <div class="content-container">
                        <h1>📘 Mengen und Abbildungen</h1>
                        
                        <div class="section">
                            <h2>1. Grundbegriffe der Mengenlehre</h2>
                            <blockquote>
                                Eine <strong>Menge</strong> ist eine Zusammenfassung bestimmter, wohlunterschiedener Objekte zu einem Ganzen (Georg Cantor, 1895).
                            </blockquote>
                            
                            <h3>Wichtige Eigenschaften:</h3>
                            <ul>
                                <li>Jedes Objekt gehört entweder zur Menge oder nicht</li>
                                <li>Die Reihenfolge der Elemente ist unwichtig</li>
                                <li>Jedes Element kommt nur einmal vor</li>
                            </ul>
                            
                            <h3>Beispiele:</h3>
                            <ul>
                                <li>Menge der natürlichen Zahlen: <span class="math-inline">$\\mathbb{N} = \\{1, 2, 3, \\dots\\}$</span></li>
                                <li>Menge der ganzen Zahlen: <span class="math-inline">$\\mathbb{Z} = \\{\\dots, -2, -1, 0, 1, 2, \\dots\\}$</span></li>
                                <li>Menge der rationalen Zahlen: <span class="math-inline">$\\mathbb{Q} = \\left\\{ \\frac{p}{q} \\mid p \\in \\mathbb{Z}, q \\in \\mathbb{N} \\right\\}$</span></li>
                                <li>Menge der reellen Zahlen: <span class="math-inline">$\\mathbb{R}$</span></li>
                            </ul>
                        </div>
                        
                        <div class="section">
                            <h2>2. Mengenoperationen</h2>
                            
                            <div class="operation">
                                <h3>Vereinigung</h3>
                                <p class="math-block">$$A \\cup B = \\{ x \\mid x \\in A \\text{ oder } x \\in B \\}$$</p>
                                <p>Die Vereinigung enthält alle Elemente, die in A oder B vorkommen.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Durchschnitt</h3>
                                <p class="math-block">$$A \\cap B = \\{ x \\mid x \\in A \\text{ und } x \\in B \\}$$</p>
                                <p>Der Durchschnitt enthält nur die Elemente, die in beiden Mengen vorkommen.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Differenz</h3>
                                <p class="math-block">$$A \\setminus B = \\{ x \\in A \\mid x \\notin B \\}$$</p>
                                <p>Die Differenz enthält die Elemente von A, die nicht in B vorkommen.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Komplement</h3>
                                <p class="math-block">$$A^c = \\{ x \\mid x \\notin A \\}$$</p>
                                <p>Das Komplement enthält alle Elemente, die nicht in A vorkommen.</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>3. Beziehungen zwischen Mengen</h2>
                            
                            <div class="relation">
                                <h3>Teilmenge</h3>
                                <p class="math-block">$$A \\subseteq B \\Leftrightarrow \\forall x \\in A: x \\in B$$</p>
                                <p>A ist Teilmenge von B, wenn jedes Element von A auch in B enthalten ist.</p>
                            </div>
                            
                            <div class="relation">
                                <h3>Echte Teilmenge</h3>
                                <p class="math-block">$$A \\subset B \\Leftrightarrow A \\subseteq B \\text{ und } A \\neq B$$</p>
                                <p>A ist echte Teilmenge von B, wenn A Teilmenge von B ist und A ungleich B ist.</p>
                            </div>
                            
                            <div class="relation">
                                <h3>Gleichheit</h3>
                                <p class="math-block">$$A = B \\Leftrightarrow A \\subseteq B \\text{ und } B \\subseteq A$$</p>
                                <p>Zwei Mengen sind gleich, wenn sie dieselben Elemente enthalten.</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>4. Wichtige Mengen</h2>
                            
                            <div class="important-set">
                                <h3>Leere Menge</h3>
                                <p class="math-block">$$\\emptyset = \\{ \\}$$</p>
                                <p>Die Menge ohne Elemente.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Potenzmenge</h3>
                                <p class="math-block">$$\\mathcal{P}(A) = \\{ X \\mid X \\subseteq A \\}$$</p>
                                <p>Die Menge aller Teilmengen von A.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Kartesisches Produkt</h3>
                                <p class="math-block">$$A \\times B = \\{ (a,b) \\mid a \\in A, b \\in B \\}$$</p>
                                <p>Die Menge aller geordneten Paare (a,b) mit a aus A und b aus B.</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>5. Visualisierung</h2>
                            <div class="venn-diagram">
                                <svg width="200" height="150">
                                    <circle cx="70" cy="75" r="50" fill="skyblue" fill-opacity="0.5"/>
                                    <circle cx="130" cy="75" r="50" fill="lightcoral" fill-opacity="0.5"/>
                                    <text x="40" y="75" font-size="14">A</text>
                                    <text x="150" y="75" font-size="14">B</text>
                                    <text x="95" y="80" font-size="14" font-weight="bold">{2,3}</text>
                                </svg>
                                <p class="diagram-caption">Venn-Diagramm zur Veranschaulichung der Mengenoperationen</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>6. Abbildungen zwischen Mengen</h2>
                            
                            <div class="operation">
                                <h3>Definition einer Abbildung</h3>
                                <p class="math-block">$$f: A \\to B$$</p>
                                <p>Eine Abbildung $f$ von $A$ nach $B$ ordnet jedem Element $a \\in A$ genau ein Element $b \\in B$ zu.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Eigenschaften von Abbildungen</h3>
                                <ul>
                                    <li><strong>Injektiv:</strong> $\\forall a_1, a_2 \\in A: f(a_1) = f(a_2) \\Rightarrow a_1 = a_2$</li>
                                    <li><strong>Surjektiv:</strong> $\\forall b \\in B \\exists a \\in A: f(a) = b$</li>
                                    <li><strong>Bijektiv:</strong> injektiv und surjektiv</li>
                                </ul>
                            </div>
                            
                            <div class="operation">
                                <h3>Komposition von Abbildungen</h3>
                                <p class="math-block">$$(g \\circ f)(x) = g(f(x))$$</p>
                                <p>Die Komposition zweier Abbildungen $f: A \\to B$ und $g: B \\to C$ ist eine neue Abbildung $g \\circ f: A \\to C$.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Umkehrabbildung</h3>
                                <p class="math-block">$$f^{-1}: B \\to A$$</p>
                                <p>Die Umkehrabbildung $f^{-1}$ existiert genau dann, wenn $f$ bijektiv ist.</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>7. Wichtige Abbildungen</h2>
                            
                            <div class="important-set">
                                <h3>Identitätsabbildung</h3>
                                <p class="math-block">$$\\text{id}_A: A \\to A, \\quad \\text{id}_A(a) = a$$</p>
                                <p>Die Identitätsabbildung bildet jedes Element auf sich selbst ab.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Konstante Abbildung</h3>
                                <p class="math-block">$$f: A \\to B, \\quad f(a) = b_0 \\text{ für alle } a \\in A$$</p>
                                <p>Eine konstante Abbildung bildet alle Elemente auf denselben Wert ab.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Einschränkung einer Abbildung</h3>
                                <p class="math-block">$$f|_C: C \\to B, \\quad f|_C(c) = f(c) \\text{ für } C \\subseteq A$$</p>
                                <p>Die Einschränkung einer Abbildung auf eine Teilmenge des Definitionsbereichs.</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>8. Beispiele und Anwendungen</h2>
                            
                            <div class="example">
                                <h3>Beispiel 1: Lineare Abbildung</h3>
                                <p class="math-block">$$f: \\mathbb{R} \\to \\mathbb{R}, \\quad f(x) = 2x + 1$$</p>
                                <p>Diese Abbildung ist bijektiv, da sie sowohl injektiv als auch surjektiv ist.</p>
                            </div>
                            
                            <div class="example">
                                <h3>Beispiel 2: Quadratische Abbildung</h3>
                                <p class="math-block">$$f: \\mathbb{R} \\to \\mathbb{R}, \\quad f(x) = x^2$$</p>
                                <p>Diese Abbildung ist weder injektiv noch surjektiv auf $\\mathbb{R}$.</p>
                            </div>
                            
                            <div class="example">
                                <h3>Beispiel 3: Permutation</h3>
                                <p class="math-block">$$\\sigma: \\{1,2,3\\} \\to \\{1,2,3\\}, \\quad \\sigma(1)=2, \\sigma(2)=3, \\sigma(3)=1$$</p>
                                <p>Eine Permutation ist eine bijektive Abbildung einer endlichen Menge auf sich selbst.</p>
                            </div>
                        </div>
                    </div>
                    """
                ),
                MathTopic(
                    title: "Logik",
                    icon: "arrow.triangle.branch",
                    description: "Mathematische Logik und Beweistechniken. Die Logik bildet die Grundlage für mathematische Beweise und Argumentationen. Sie beschäftigt sich mit Aussagen und deren Verknüpfungen.",
                    markdownContent: """
                    <div class="content-container">
                        <h1>📘 Logik</h1>
                        
                        <div class="section">
                            <h2>1. Grundbegriffe der Logik</h2>
                            <blockquote>
                                Die mathematische Logik beschäftigt sich mit der formalen Analyse von Aussagen und deren Verknüpfungen.
                            </blockquote>
                            
                            <h3>Wichtige Begriffe:</h3>
                            <ul>
                                <li><strong>Aussage:</strong> Ein Satz, der entweder wahr oder falsch ist</li>
                                <li><strong>Aussageform:</strong> Ein Satz mit Variablen, der durch Einsetzen zu einer Aussage wird</li>
                                <li><strong>Quantoren:</strong> $\\forall$ (für alle) und $\\exists$ (es existiert)</li>
                            </ul>
                        </div>
                        
                        <div class="section">
                            <h2>2. Logische Verknüpfungen</h2>
                            
                            <div class="operation">
                                <h3>Negation</h3>
                                <p class="math-block">$$\\neg A$$</p>
                                <p>Die Negation einer Aussage $A$ ist genau dann wahr, wenn $A$ falsch ist.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Konjunktion (UND)</h3>
                                <p class="math-block">$$A \\land B$$</p>
                                <p>Die Konjunktion ist genau dann wahr, wenn beide Aussagen wahr sind.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Disjunktion (ODER)</h3>
                                <p class="math-block">$$A \\lor B$$</p>
                                <p>Die Disjunktion ist genau dann wahr, wenn mindestens eine Aussage wahr ist.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Implikation (WENN-DANN)</h3>
                                <p class="math-block">$$A \\Rightarrow B$$</p>
                                <p>Die Implikation ist nur dann falsch, wenn $A$ wahr und $B$ falsch ist.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Äquivalenz (GENAU DANN)</h3>
                                <p class="math-block">$$A \\Leftrightarrow B$$</p>
                                <p>Die Äquivalenz ist genau dann wahr, wenn beide Aussagen denselben Wahrheitswert haben.</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>3. Wahrheitstafeln</h2>
                            <div class="venn-diagram">
                                <svg width="400" height="200">
                                    <rect x="50" y="50" width="300" height="150" fill="white" stroke="black"/>
                                    <text x="100" y="80" font-size="14">A</text>
                                    <text x="200" y="80" font-size="14">B</text>
                                    <text x="300" y="80" font-size="14">A ∧ B</text>
                                    <line x1="150" y1="70" x2="150" y2="200" stroke="black"/>
                                    <line x1="250" y1="70" x2="250" y2="200" stroke="black"/>
                                    <text x="100" y="120" font-size="14">w</text>
                                    <text x="200" y="120" font-size="14">w</text>
                                    <text x="300" y="120" font-size="14">w</text>
                                    <text x="100" y="150" font-size="14">w</text>
                                    <text x="200" y="150" font-size="14">f</text>
                                    <text x="300" y="150" font-size="14">f</text>
                                    <text x="100" y="180" font-size="14">f</text>
                                    <text x="200" y="180" font-size="14">w</text>
                                    <text x="300" y="180" font-size="14">f</text>
                                </svg>
                                <p class="diagram-caption">Wahrheitstafel für die Konjunktion A ∧ B</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>4. Beweistechniken</h2>
                            
                            <div class="important-set">
                                <h3>Direkter Beweis</h3>
                                <p>Man zeigt direkt, dass aus der Voraussetzung die Behauptung folgt.</p>
                                <p class="math-block">$$\\text{Voraussetzung} \\Rightarrow \\text{Behauptung}$$</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Indirekter Beweis</h3>
                                <p>Man nimmt an, die Behauptung sei falsch, und führt dies zu einem Widerspruch.</p>
                                <p class="math-block">$$\\neg \\text{Behauptung} \\Rightarrow \\text{Widerspruch}$$</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Kontraposition</h3>
                                <p>Man beweist die äquivalente Aussage $\\neg B \\Rightarrow \\neg A$ statt $A \\Rightarrow B$.</p>
                                <p class="math-block">$$(A \\Rightarrow B) \\Leftrightarrow (\\neg B \\Rightarrow \\neg A)$$</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>5. Beispiele</h2>
                            
                            <div class="example">
                                <h3>Beispiel 1: Direkter Beweis</h3>
                                <p><strong>Behauptung:</strong> Wenn $n$ eine gerade Zahl ist, dann ist $n^2$ auch gerade.</p>
                                <p class="math-block">$$n = 2k \\Rightarrow n^2 = (2k)^2 = 4k^2 = 2(2k^2)$$</p>
                            </div>
                            
                            <div class="example">
                                <h3>Beispiel 2: Indirekter Beweis</h3>
                                <p><strong>Behauptung:</strong> $\\sqrt{2}$ ist irrational.</p>
                                <p>Annahme: $\\sqrt{2}$ ist rational $\\Rightarrow$ Widerspruch zur Eindeutigkeit der Primfaktorzerlegung.</p>
                            </div>
                            
                            <div class="example">
                                <h3>Beispiel 3: Kontraposition</h3>
                                <p><strong>Behauptung:</strong> Wenn $n^2$ ungerade ist, dann ist $n$ ungerade.</p>
                                <p>Kontraposition: Wenn $n$ gerade ist, dann ist $n^2$ gerade.</p>
                            </div>
                        </div>
                    </div>
                    """
                ),
                MathTopic(
                    title: "Vollständige Induktion",
                    icon: "arrow.up.forward",
                    description: "Die Methode der vollständigen Induktion als Beweistechnik. Ein wichtiges Beweisverfahren für Aussagen über natürliche Zahlen, das aus einem Induktionsanfang und einem Induktionsschritt besteht.",
                    markdownContent: """
                    <div class="content-container">
                        <h1>📘 Vollständige Induktion</h1>
                        
                        <div class="section">
                            <h2>1. Grundprinzip</h2>
                            <blockquote>
                                Die vollständige Induktion ist ein Beweisverfahren für Aussagen über natürliche Zahlen.
                            </blockquote>
                            
                            <h3>Induktionsprinzip:</h3>
                            <p class="math-block">$$\\text{Wenn } A(1) \\text{ wahr ist und } \\forall n \\in \\mathbb{N}: A(n) \\Rightarrow A(n+1), \\text{ dann ist } A(n) \\text{ für alle } n \\in \\mathbb{N} \\text{ wahr.}$$</p>
                        </div>
                        
                        <div class="section">
                            <h2>2. Beweisschema</h2>
                            
                            <div class="operation">
                                <h3>Induktionsanfang</h3>
                                <p>Man zeigt, dass die Aussage für den kleinsten Wert (meist n=1) gilt.</p>
                                <p class="math-block">$$A(1) \\text{ ist wahr}$$</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Induktionsvoraussetzung</h3>
                                <p>Man nimmt an, dass die Aussage für ein beliebiges n gilt.</p>
                                <p class="math-block">$$A(n) \\text{ ist wahr}$$</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Induktionsschritt</h3>
                                <p>Man zeigt, dass die Aussage dann auch für n+1 gilt.</p>
                                <p class="math-block">$$A(n) \\Rightarrow A(n+1)$$</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>3. Beispiele</h2>
                            
                            <div class="example">
                                <h3>Beispiel 1: Summe der ersten n natürlichen Zahlen</h3>
                                <p><strong>Behauptung:</strong> $\\sum_{k=1}^n k = \\frac{n(n+1)}{2}$</p>
                                <p><strong>Induktionsanfang (n=1):</strong> $1 = \\frac{1(1+1)}{2}$ ✓</p>
                                <p><strong>Induktionsschritt:</strong></p>
                                <p class="math-block">$$\\sum_{k=1}^{n+1} k = \\sum_{k=1}^n k + (n+1) = \\frac{n(n+1)}{2} + (n+1) = \\frac{(n+1)(n+2)}{2}$$</p>
                            </div>
                            
                            <div class="example">
                                <h3>Beispiel 2: Geometrische Summe</h3>
                                <p><strong>Behauptung:</strong> $\\sum_{k=0}^n q^k = \\frac{1-q^{n+1}}{1-q}$ für $q \\neq 1$</p>
                                <p><strong>Induktionsanfang (n=0):</strong> $1 = \\frac{1-q}{1-q}$ ✓</p>
                                <p><strong>Induktionsschritt:</strong></p>
                                <p class="math-block">$$\\sum_{k=0}^{n+1} q^k = \\sum_{k=0}^n q^k + q^{n+1} = \\frac{1-q^{n+1}}{1-q} + q^{n+1} = \\frac{1-q^{n+2}}{1-q}$$</p>
                            </div>
                            
                            <div class="example">
                                <h3>Beispiel 3: Ungleichung</h3>
                                <p><strong>Behauptung:</strong> $2^n > n^2$ für $n \\geq 5$</p>
                                <p><strong>Induktionsanfang (n=5):</strong> $32 > 25$ ✓</p>
                                <p><strong>Induktionsschritt:</strong></p>
                                <p class="math-block">$$2^{n+1} = 2 \\cdot 2^n > 2 \\cdot n^2 > (n+1)^2 \\text{ für } n \\geq 5$$</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>4. Varianten der Induktion</h2>
                            
                            <div class="important-set">
                                <h3>Starke Induktion</h3>
                                <p>Man darf annehmen, dass die Aussage für alle Zahlen bis n gilt.</p>
                                <p class="math-block">$$A(1) \\land \\forall k \\leq n: A(k) \\Rightarrow A(n+1)$$</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Induktion mit beliebigem Startwert</h3>
                                <p>Die Aussage gilt für alle n ab einem bestimmten Startwert n₀.</p>
                                <p class="math-block">$$A(n_0) \\land \\forall n \\geq n_0: A(n) \\Rightarrow A(n+1)$$</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Rekursive Definitionen</h3>
                                <p>Viele mathematische Objekte werden durch Induktion definiert.</p>
                                <p class="math-block">$$a_1 = 1, \\quad a_{n+1} = f(a_n)$$</p>
                            </div>
                        </div>
                    </div>
                    """
                ),
                MathTopic(
                    title: "Binomische Formeln",
                    icon: "x.squareroot",
                    description: "Die binomischen Formeln und ihre Anwendungen. Wichtige Formeln der Algebra, die das Potenzieren von Binomen beschreiben, wie (a+b)² = a² + 2ab + b².",
                    markdownContent: """
                    <div class="content-container">
                        <h1>📘 Binomische Formeln</h1>
                        
                        <div class="section">
                            <h2>1. Grundlegende Formeln</h2>
                            <blockquote>
                                Die binomischen Formeln beschreiben das Potenzieren von Binomen (Zweigliedern).
                            </blockquote>
                            
                            <div class="operation">
                                <h3>1. Binomische Formel</h3>
                                <p class="math-block">$$(a + b)^2 = a^2 + 2ab + b^2$$</p>
                                <p>Quadrat eines Binoms mit Pluszeichen.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>2. Binomische Formel</h3>
                                <p class="math-block">$$(a - b)^2 = a^2 - 2ab + b^2$$</p>
                                <p>Quadrat eines Binoms mit Minuszeichen.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>3. Binomische Formel</h3>
                                <p class="math-block">$$(a + b)(a - b) = a^2 - b^2$$</p>
                                <p>Produkt von Summe und Differenz.</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>2. Geometrische Veranschaulichung</h2>
                            <div class="venn-diagram">
                                <svg width="300" height="300">
                                    <rect x="50" y="50" width="200" height="200" fill="none" stroke="black"/>
                                    <line x1="150" y1="50" x2="150" y2="250" stroke="black"/>
                                    <line x1="50" y1="150" x2="250" y2="150" stroke="black"/>
                                    <text x="100" y="100" font-size="14">a²</text>
                                    <text x="200" y="100" font-size="14">ab</text>
                                    <text x="100" y="200" font-size="14">ab</text>
                                    <text x="200" y="200" font-size="14">b²</text>
                                    <text x="75" y="30" font-size="14">a</text>
                                    <text x="200" y="30" font-size="14">b</text>
                                    <text x="30" y="100" font-size="14">a</text>
                                    <text x="30" y="200" font-size="14">b</text>
                                </svg>
                                <p class="diagram-caption">Geometrische Veranschaulichung der 1. Binomischen Formel</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>3. Erweiterte Formeln</h2>
                            
                            <div class="important-set">
                                <h3>Binomischer Lehrsatz</h3>
                                <p class="math-block">$$(a + b)^n = \\sum_{k=0}^n \\binom{n}{k} a^{n-k} b^k$$</p>
                                <p>Allgemeine Formel für beliebige Potenzen.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Pascalsches Dreieck</h3>
                                <p class="math-block">$$\\begin{array}{c}
                                    1 \\\\
                                    1 \\quad 1 \\\\
                                    1 \\quad 2 \\quad 1 \\\\
                                    1 \\quad 3 \\quad 3 \\quad 1 \\\\
                                    1 \\quad 4 \\quad 6 \\quad 4 \\quad 1 \\\\
                                    \\vdots
                                \\end{array}$$</p>
                                <p>Die Koeffizienten der binomischen Formeln.</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>4. Anwendungen</h2>
                            
                            <div class="example">
                                <h3>Beispiel 1: Faktorisieren</h3>
                                <p class="math-block">$$x^2 + 6x + 9 = (x + 3)^2$$</p>
                                <p>Erkennen von vollständigen Quadraten.</p>
                            </div>
                            
                            <div class="example">
                                <h3>Beispiel 2: Vereinfachen</h3>
                                <p class="math-block">$$\\frac{x^2 - 4}{x - 2} = x + 2$$</p>
                                <p>Kürzen durch Faktorisieren.</p>
                            </div>
                            
                            <div class="example">
                                <h3>Beispiel 3: Beweise</h3>
                                <p><strong>Behauptung:</strong> $(a + b)^2 \\geq 4ab$</p>
                                <p class="math-block">$$(a + b)^2 - 4ab = a^2 - 2ab + b^2 = (a - b)^2 \\geq 0$$</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>5. Spezialfälle</h2>
                            
                            <div class="important-set">
                                <h3>Summe/Differenz von Kubikzahlen</h3>
                                <p class="math-block">$$a^3 + b^3 = (a + b)(a^2 - ab + b^2)$$</p>
                                <p class="math-block">$$a^3 - b^3 = (a - b)(a^2 + ab + b^2)$$</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Höhere Potenzen</h3>
                                <p class="math-block">$$(a + b)^3 = a^3 + 3a^2b + 3ab^2 + b^3$$</p>
                                <p class="math-block">$$(a - b)^3 = a^3 - 3a^2b + 3ab^2 - b^3$$</p>
                            </div>
                        </div>
                    </div>
                    """
                ),
                MathTopic(
                    title: "Größter gemeinsamer Teiler",
                    icon: "divide",
                    description: "Der größte gemeinsame Teiler und seine Eigenschaften. Der ggT zweier Zahlen ist die größte natürliche Zahl, die beide Zahlen teilt. Wichtiges Konzept in der Zahlentheorie.",
                    markdownContent: """
                    <div class="content-container">
                        <h1>📘 Größter gemeinsamer Teiler</h1>
                        
                        <div class="section">
                            <h2>1. Grundbegriffe</h2>
                            <blockquote>
                                Der größte gemeinsame Teiler (ggT) zweier Zahlen ist die größte natürliche Zahl, die beide Zahlen teilt.
                            </blockquote>
                            
                            <h3>Definition:</h3>
                            <p class="math-block">$$\\text{ggT}(a,b) = \\max\\{d \\in \\mathbb{N} \\mid d \\mid a \\text{ und } d \\mid b\\}$$</p>
                            
                            <h3>Wichtige Eigenschaften:</h3>
                            <ul>
                                <li>Der ggT ist immer eine natürliche Zahl</li>
                                <li>Der ggT ist eindeutig bestimmt</li>
                                <li>Der ggT ist symmetrisch: $\\text{ggT}(a,b) = \\text{ggT}(b,a)$</li>
                            </ul>
                        </div>
                        
                        <div class="section">
                            <h2>2. Berechnungsmethoden</h2>
                            
                            <div class="operation">
                                <h3>Euklidischer Algorithmus</h3>
                                <p class="math-block">$$\\text{ggT}(a,b) = \\text{ggT}(b, a \\mod b)$$</p>
                                <p>Wiederholte Anwendung bis $b = 0$, dann ist $a$ der ggT.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Erweiterter Euklidischer Algorithmus</h3>
                                <p class="math-block">$$\\text{ggT}(a,b) = x \\cdot a + y \\cdot b$$</p>
                                <p>Berechnet zusätzlich die Koeffizienten $x$ und $y$.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Primfaktorzerlegung</h3>
                                <p class="math-block">$$a = \\prod_{p \\text{ prim}} p^{\\alpha_p}, \\quad b = \\prod_{p \\text{ prim}} p^{\\beta_p}$$</p>
                                <p class="math-block">$$\\text{ggT}(a,b) = \\prod_{p \\text{ prim}} p^{\\min(\\alpha_p, \\beta_p)}$$</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>3. Beispiele</h2>
                            
                            <div class="example">
                                <h3>Beispiel 1: Euklidischer Algorithmus</h3>
                                <p><strong>Berechnung von ggT(48,18):</strong></p>
                                <p class="math-block">$$\\begin{align*}
                                    48 &= 2 \\cdot 18 + 12 \\\\
                                    18 &= 1 \\cdot 12 + 6 \\\\
                                    12 &= 2 \\cdot 6 + 0 \\\\
                                    \\Rightarrow \\text{ggT}(48,18) &= 6
                                \\end{align*}$$</p>
                            </div>
                            
                            <div class="example">
                                <h3>Beispiel 2: Erweiterter Euklidischer Algorithmus</h3>
                                <p><strong>Darstellung von ggT(48,18) als Linearkombination:</strong></p>
                                <p class="math-block">$$\\begin{align*}
                                    6 &= 18 - 1 \\cdot 12 \\\\
                                    &= 18 - 1 \\cdot (48 - 2 \\cdot 18) \\\\
                                    &= 3 \\cdot 18 - 1 \\cdot 48
                                \\end{align*}$$</p>
                            </div>
                            
                            <div class="example">
                                <h3>Beispiel 3: Primfaktorzerlegung</h3>
                                <p><strong>Berechnung von ggT(36,60):</strong></p>
                                <p class="math-block">$$\\begin{align*}
                                    36 &= 2^2 \\cdot 3^2 \\\\
                                    60 &= 2^2 \\cdot 3 \\cdot 5 \\\\
                                    \\text{ggT}(36,60) &= 2^2 \\cdot 3 = 12
                                \\end{align*}$$</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>4. Anwendungen</h2>
                            
                            <div class="important-set">
                                <h3>Kürzen von Brüchen</h3>
                                <p class="math-block">$$\\frac{a}{b} = \\frac{a/\\text{ggT}(a,b)}{b/\\text{ggT}(a,b)}$$</p>
                                <p>Der ggT ermöglicht das vollständige Kürzen von Brüchen.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Diophantische Gleichungen</h3>
                                <p class="math-block">$$a \\cdot x + b \\cdot y = c$$</p>
                                <p>Hat genau dann eine Lösung, wenn $\\text{ggT}(a,b) \\mid c$.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Modulare Arithmetik</h3>
                                <p class="math-block">$$a \\cdot x \\equiv b \\pmod{m}$$</p>
                                <p>Hat genau dann eine Lösung, wenn $\\text{ggT}(a,m) \\mid b$.</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>5. Verwandte Konzepte</h2>
                            
                            <div class="important-set">
                                <h3>Kleinstes gemeinsames Vielfaches (kgV)</h3>
                                <p class="math-block">$$\\text{kgV}(a,b) = \\frac{a \\cdot b}{\\text{ggT}(a,b)}$$</p>
                                <p>Zusammenhang zwischen ggT und kgV.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Teilerfremde Zahlen</h3>
                                <p class="math-block">$$\\text{ggT}(a,b) = 1$$</p>
                                <p>Zwei Zahlen sind teilerfremd, wenn ihr ggT 1 ist.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Eulersche φ-Funktion</h3>
                                <p class="math-block">$$\\varphi(n) = |\\{k \\in \\mathbb{N} \\mid 1 \\leq k \\leq n, \\text{ggT}(k,n) = 1\\}|$$</p>
                                <p>Zählt die teilerfremden Zahlen zu n.</p>
                            </div>
                        </div>
                    </div>
                    """
                ),
                MathTopic(
                    title: "Gruppen",
                    icon: "person.3.fill",
                    description: "Grundlagen der Gruppentheorie. Eine Gruppe ist eine Menge mit einer Verknüpfung, die bestimmte Eigenschaften erfüllt: Assoziativität, Existenz eines neutralen Elements und inverser Elemente.",
                    markdownContent: """
                    <div class="content-container">
                        <h1>📘 Gruppen</h1>
                        
                        <div class="section">
                            <h2>1. Grundbegriffe</h2>
                            <blockquote>
                                Eine Gruppe ist eine Menge mit einer Verknüpfung, die bestimmte Eigenschaften erfüllt.
                            </blockquote>
                            
                            <h3>Definition:</h3>
                            <p>Eine Gruppe $(G, \\circ)$ besteht aus einer Menge $G$ und einer Verknüpfung $\\circ: G \\times G \\to G$ mit:</p>
                            <ul>
                                <li><strong>Assoziativität:</strong> $\\forall a,b,c \\in G: (a \\circ b) \\circ c = a \\circ (b \\circ c)$</li>
                                <li><strong>Neutrales Element:</strong> $\\exists e \\in G \\forall a \\in G: e \\circ a = a \\circ e = a$</li>
                                <li><strong>Inverse Elemente:</strong> $\\forall a \\in G \\exists a^{-1} \\in G: a \\circ a^{-1} = a^{-1} \\circ a = e$</li>
                            </ul>
                        </div>
                        
                        <div class="section">
                            <h2>2. Wichtige Eigenschaften</h2>
                            
                            <div class="operation">
                                <h3>Kommutativität</h3>
                                <p class="math-block">$$\\forall a,b \\in G: a \\circ b = b \\circ a$$</p>
                                <p>Eine Gruppe heißt abelsch (kommutativ), wenn die Verknüpfung kommutativ ist.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Ordnung</h3>
                                <p class="math-block">$$|G| = \\text{Anzahl der Elemente in } G$$</p>
                                <p>Die Ordnung einer Gruppe ist die Anzahl ihrer Elemente.</p>
                            </div>
                            
                            <div class="operation">
                                <h3>Untergruppen</h3>
                                <p class="math-block">$$H \\subseteq G \\text{ ist Untergruppe } \\Leftrightarrow \\forall a,b \\in H: a \\circ b^{-1} \\in H$$</p>
                                <p>Eine Teilmenge, die selbst eine Gruppe ist.</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>3. Beispiele</h2>
                            
                            <div class="example">
                                <h3>Beispiel 1: Additive Gruppe der ganzen Zahlen</h3>
                                <p class="math-block">$$(\\mathbb{Z}, +)$$</p>
                                <ul>
                                    <li>Neutrales Element: 0</li>
                                    <li>Inverses zu $a$: $-a$</li>
                                    <li>Abelsch</li>
                                    <li>Unendliche Ordnung</li>
                                </ul>
                            </div>
                            
                            <div class="example">
                                <h3>Beispiel 2: Multiplikative Gruppe der reellen Zahlen</h3>
                                <p class="math-block">$$(\\mathbb{R}^*, \\cdot)$$</p>
                                <ul>
                                    <li>Neutrales Element: 1</li>
                                    <li>Inverses zu $a$: $\\frac{1}{a}$</li>
                                    <li>Abelsch</li>
                                    <li>Unendliche Ordnung</li>
                                </ul>
                            </div>
                            
                            <div class="example">
                                <h3>Beispiel 3: Symmetrische Gruppe</h3>
                                <p class="math-block">$$(S_n, \\circ)$$</p>
                                <ul>
                                    <li>Menge aller Permutationen von n Elementen</li>
                                    <li>Neutrales Element: Identität</li>
                                    <li>Inverses: Umkehrabbildung</li>
                                    <li>Nicht abelsch für n ≥ 3</li>
                                    <li>Ordnung: n!</li>
                                </ul>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>4. Homomorphismen</h2>
                            
                            <div class="important-set">
                                <h3>Definition</h3>
                                <p class="math-block">$$\\phi: G \\to H \\text{ ist Homomorphismus } \\Leftrightarrow \\forall a,b \\in G: \\phi(a \\circ b) = \\phi(a) * \\phi(b)$$</p>
                                <p>Eine Abbildung, die die Gruppenstruktur erhält.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Kern und Bild</h3>
                                <p class="math-block">$$\\text{Kern}(\\phi) = \\{g \\in G \\mid \\phi(g) = e_H\\}$$</p>
                                <p class="math-block">$$\\text{Bild}(\\phi) = \\{\\phi(g) \\mid g \\in G\\}$$</p>
                                <p>Der Kern ist eine Untergruppe von G, das Bild eine Untergruppe von H.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Isomorphismen</h3>
                                <p class="math-block">$$\\phi \\text{ ist Isomorphismus } \\Leftrightarrow \\phi \\text{ ist bijektiver Homomorphismus}$$</p>
                                <p>Zwei Gruppen sind isomorph, wenn sie strukturgleich sind.</p>
                            </div>
                        </div>
                        
                        <div class="section">
                            <h2>5. Wichtige Sätze</h2>
                            
                            <div class="important-set">
                                <h3>Lagrange-Theorem</h3>
                                <p class="math-block">$$|G| = |H| \\cdot [G:H]$$</p>
                                <p>Die Ordnung einer Untergruppe teilt die Ordnung der Gruppe.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Homomorphiesatz</h3>
                                <p class="math-block">$$G/\\text{Kern}(\\phi) \\cong \\text{Bild}(\\phi)$$</p>
                                <p>Der Quotient nach dem Kern ist isomorph zum Bild.</p>
                            </div>
                            
                            <div class="important-set">
                                <h3>Zyklische Gruppen</h3>
                                <p class="math-block">$$G = \\langle g \\rangle = \\{g^n \\mid n \\in \\mathbb{Z}\\}$$</p>
                                <p>Eine Gruppe heißt zyklisch, wenn sie von einem Element erzeugt wird.</p>
                            </div>
                        </div>
                    </div>
                    """
                ),
                MathTopic(title: "Ringe", icon: "circle.circle.fill", description: "Einführung in die Ringtheorie. Ein Ring ist eine algebraische Struktur mit zwei Verknüpfungen, die bestimmte Eigenschaften erfüllen. Wichtiges Konzept in der Algebra."),
                MathTopic(title: "Körper", icon: "square.grid.3x3.fill", description: "Grundlagen der Körpertheorie. Ein Körper ist eine algebraische Struktur, in der Addition, Subtraktion, Multiplikation und Division (außer durch Null) definiert sind."),
                MathTopic(title: "Komplexe Zahlen", icon: "i.circle.fill", description: "Die komplexen Zahlen und ihre geometrische Interpretation. Erweiterung der reellen Zahlen um die imaginäre Einheit i. Wichtige Anwendungen in Physik und Ingenieurwissenschaften.")
            ]
        ),
        MathTopic(title: "Analysis", icon: "function", description: "Die Analysis beschäftigt sich mit Grenzwerten, Ableitungen und Integralen."),
        MathTopic(title: "Lineare Algebra", icon: "matrix", description: "Die Lineare Algebra untersucht Vektorräume und lineare Abbildungen."),
        MathTopic(title: "Differentialgleichungen", icon: "derivative", description: "Differentialgleichungen beschreiben Änderungsraten in Systemen."),
        MathTopic(title: "Wahrscheinlichkeitstheorie", icon: "dice", description: "Die Wahrscheinlichkeitstheorie beschäftigt sich mit Zufallsexperimenten."),
        MathTopic(title: "Statistik", icon: "chart.bar", description: "Die Statistik analysiert und interpretiert Daten."),
        MathTopic(title: "Numerik", icon: "number", description: "Die Numerik entwickelt Algorithmen für mathematische Probleme."),
        MathTopic(title: "Topologie", icon: "shape", description: "Die Topologie untersucht Eigenschaften von Räumen."),
        MathTopic(title: "Gruppentheorie", icon: "group", description: "Die Gruppentheorie studiert algebraische Strukturen."),
        MathTopic(title: "Funktionalanalysis", icon: "waveform", description: "Die Funktionalanalysis verbindet Analysis und Lineare Algebra."),
        MathTopic(title: "Komplexe Analysis", icon: "infinity", description: "Die Komplexe Analysis untersucht Funktionen komplexer Zahlen.")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Subtle gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.98, green: 0.98, blue: 1.0),
                        Color(red: 0.95, green: 0.97, blue: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Subtle color elements
                GeometryReader { geometry in
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.05))
                            .frame(width: geometry.size.width * 0.8)
                            .offset(x: -geometry.size.width * 0.3, y: -geometry.size.height * 0.2)
                        
                        Circle()
                            .fill(Color.purple.opacity(0.05))
                            .frame(width: geometry.size.width * 0.6)
                            .offset(x: geometry.size.width * 0.3, y: geometry.size.height * 0.2)
                    }
                }
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(topics) { topic in
                            NavigationLink(destination: topic.subTopics != nil ? 
                                AnyView(SubTopicsView(topic: topic)) : 
                                AnyView(TopicDetailView(topic: topic))) {
                                TopicCard(topic: topic)
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Höhere Mathematik")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct TopicCard: View {
    let topic: MathTopic
    
    var body: some View {
        VStack {
            Image(systemName: topic.icon)
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .padding()
            
            Text(topic.title)
                .font(.headline)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.1), lineWidth: 1)
        )
    }
}

struct SubTopicsView: View {
    let topic: MathTopic
    
    var body: some View {
        ZStack {
            // Subtle gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.98, blue: 1.0),
                    Color(red: 0.95, green: 0.97, blue: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Subtle color elements
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.05))
                        .frame(width: geometry.size.width * 0.8)
                        .offset(x: -geometry.size.width * 0.3, y: -geometry.size.height * 0.2)
                    
                    Circle()
                        .fill(Color.purple.opacity(0.05))
                        .frame(width: geometry.size.width * 0.6)
                        .offset(x: geometry.size.width * 0.3, y: geometry.size.height * 0.2)
                }
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    // Learning content section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Lerninhalte")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(topic.subTopics ?? []) { subTopic in
                                NavigationLink(destination: ContentSelectionView(topic: subTopic)) {
                                    TopicCard(topic: subTopic)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ContentSelectionView: View {
    let topic: MathTopic
    
    var body: some View {
        ZStack {
            // Modern gradient background with abstract shapes
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.98, blue: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Abstract background elements
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.03))
                        .frame(width: geometry.size.width * 1.2)
                        .offset(x: -geometry.size.width * 0.2, y: -geometry.size.height * 0.1)
                    
                    Circle()
                        .fill(Color.purple.opacity(0.03))
                        .frame(width: geometry.size.width * 0.8)
                        .offset(x: geometry.size.width * 0.3, y: geometry.size.height * 0.3)
                }
            }
            
            VStack(spacing: 20) {
                Text("Wählen Sie aus:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    // Lerninhalte tile
                    NavigationLink(destination: TopicDetailView(topic: topic)) {
                        TopicCard(topic: MathTopic(
                            title: "Lerninhalte",
                            icon: "book.fill",
                            description: "Zugang zu den Lernmaterialien und Erklärungen."
                        ))
                    }
                    
                    // Übungen tile
                    NavigationLink(destination: ExercisesView(topic: topic)) {
                        TopicCard(topic: MathTopic(
                            title: "Übungen",
                            icon: "pencil.and.list.clipboard",
                            description: "Interaktive Übungen und Aufgaben zum Thema."
                        ))
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ExercisesView: View {
    let topic: MathTopic
    @State private var selectedDifficulty: Difficulty?
    
    var body: some View {
        ZStack {
            // Modern gradient background with abstract shapes
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.98, blue: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Abstract background elements
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.03))
                        .frame(width: geometry.size.width * 1.2)
                        .offset(x: -geometry.size.width * 0.2, y: -geometry.size.height * 0.1)
                    
                    Circle()
                        .fill(Color.purple.opacity(0.03))
                        .frame(width: geometry.size.width * 0.8)
                        .offset(x: geometry.size.width * 0.3, y: geometry.size.height * 0.3)
                }
            }
            
            VStack(spacing: 20) {
                Text("Wählen Sie den Schwierigkeitsgrad:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                HStack(spacing: 16) {
                    ForEach([Difficulty.easy, .medium, .hard], id: \.self) { difficulty in
                        Button(action: {
                            selectedDifficulty = difficulty
                        }) {
                            Text(difficulty.text)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(difficulty.color)
                                        .shadow(color: difficulty.color.opacity(0.3), radius: 5, x: 0, y: 2)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                
                if let selectedDifficulty = selectedDifficulty {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(getExercises(for: topic.title, difficulty: selectedDifficulty), id: \.id) { exercise in
                                ExerciseCard(exercise: exercise)
                            }
                        }
                        .padding()
                    }
                } else {
                    Spacer()
                    Text("Bitte wählen Sie einen Schwierigkeitsgrad aus")
                        .foregroundColor(.gray)
                        .font(.headline)
                    Spacer()
                }
            }
        }
        .navigationTitle("Übungen: \(topic.title)")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func getExercises(for topic: String, difficulty: Difficulty) -> [Exercise] {
        switch topic {
        case "Mengen und Abbildungen":
            switch difficulty {
            case .easy:
                return [
                    Exercise(
                        id: 1,
                        title: "Mengenoperationen",
                        description: "Gegeben sind die Mengen A = {1, 2, 3, 4} und B = {3, 4, 5, 6}. Bestimmen Sie:\n1. A ∪ B\n2. A ∩ B\n3. A \\ B\n4. B \\ A",
                        difficulty: .easy,
                        points: 5
                    ),
                    Exercise(
                        id: 2,
                        title: "Teilmengen",
                        description: "Welche der folgenden Aussagen sind wahr?\n1. {1, 2} ⊆ {1, 2, 3}\n2. {1, 2, 3} ⊆ {1, 2}\n3. ∅ ⊆ {1, 2, 3}\n4. {1, 2, 3} ⊆ ∅",
                        difficulty: .easy,
                        points: 5
                    ),
                    Exercise(
                        id: 3,
                        title: "Kartesisches Produkt",
                        description: "Gegeben sind die Mengen A = {a, b} und B = {1, 2}. Bestimmen Sie A × B.",
                        difficulty: .easy,
                        points: 5
                    )
                ]
            case .medium:
                return [
                    Exercise(
                        id: 4,
                        title: "Abbildungseigenschaften",
                        description: "Untersuchen Sie die Abbildung f: ℝ → ℝ, f(x) = x² auf Injektivität und Surjektivität. Begründen Sie Ihre Antwort.",
                        difficulty: .medium,
                        points: 10
                    ),
                    Exercise(
                        id: 5,
                        title: "Komposition von Abbildungen",
                        description: "Gegeben sind die Abbildungen f: ℝ → ℝ, f(x) = 2x + 1 und g: ℝ → ℝ, g(x) = x².\nBestimmen Sie f∘g und g∘f.",
                        difficulty: .medium,
                        points: 10
                    ),
                    Exercise(
                        id: 6,
                        title: "Mengenidentitäten",
                        description: "Beweisen Sie die Distributivgesetze für Mengen:\n1. A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C)\n2. A ∪ (B ∩ C) = (A ∪ B) ∩ (A ∪ C)",
                        difficulty: .medium,
                        points: 10
                    )
                ]
            case .hard:
                return [
                    Exercise(
                        id: 7,
                        title: "Bijektive Abbildungen",
                        description: "Zeigen Sie, dass die Abbildung f: ℝ → ℝ, f(x) = x³ + 2x bijektiv ist. Bestimmen Sie die Umkehrabbildung f⁻¹.",
                        difficulty: .hard,
                        points: 15
                    ),
                    Exercise(
                        id: 8,
                        title: "Mächtigkeit von Mengen",
                        description: "Beweisen Sie, dass die Menge der rationalen Zahlen ℚ abzählbar unendlich ist.",
                        difficulty: .hard,
                        points: 15
                    ),
                    Exercise(
                        id: 9,
                        title: "Äquivalenzrelationen",
                        description: "Sei M eine nichtleere Menge. Zeigen Sie, dass die Relation R = {(A,B) ∈ P(M) × P(M) | |A| = |B|} eine Äquivalenzrelation auf der Potenzmenge P(M) ist.",
                        difficulty: .hard,
                        points: 15
                    )
                ]
            }
        default:
            return [
                Exercise(
                    id: 1,
                    title: "Beispielaufgabe",
                    description: "Dies ist eine Beispielaufgabe zum Thema \(topic)",
                    difficulty: difficulty,
                    points: difficulty == .easy ? 5 : (difficulty == .medium ? 10 : 15)
                )
            ]
        }
    }
}

struct Exercise: Identifiable {
    let id: Int
    let title: String
    let description: String
    let difficulty: Difficulty
    let points: Int
}

enum Difficulty {
    case easy, medium, hard
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    var text: String {
        switch self {
        case .easy: return "Einfach"
        case .medium: return "Mittel"
        case .hard: return "Schwer"
        }
    }
}

struct ExerciseCard: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(exercise.title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(exercise.points) Punkte")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            Text(exercise.description)
                .font(.body)
                .foregroundColor(.gray)
                .lineSpacing(4)
            
            HStack {
                Text(exercise.difficulty.text)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(exercise.difficulty.color)
                    .cornerRadius(4)
                
                Spacer()
                
                Button(action: {
                    // Action to start the exercise
                }) {
                    Text("Start")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.1), lineWidth: 1)
        )
    }
}

struct TopicDetailView: View {
    let topic: MathTopic
    
    var body: some View {
        ZStack {
            // Modern gradient background with abstract shapes
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.98, blue: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Abstract background elements
            GeometryReader { geometry in
                ZStack {
                    // Large circle
                    Circle()
                        .fill(Color.blue.opacity(0.03))
                        .frame(width: geometry.size.width * 1.2)
                        .offset(x: -geometry.size.width * 0.2, y: -geometry.size.height * 0.1)
                    
                    // Medium circle
                    Circle()
                        .fill(Color.purple.opacity(0.03))
                        .frame(width: geometry.size.width * 0.8)
                        .offset(x: geometry.size.width * 0.3, y: geometry.size.height * 0.3)
                    
                    // Small circle
                    Circle()
                        .fill(Color.blue.opacity(0.02))
                        .frame(width: geometry.size.width * 0.4)
                        .offset(x: -geometry.size.width * 0.1, y: geometry.size.height * 0.6)
                }
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    if let markdownContent = topic.markdownContent {
                        LaTeXView(content: markdownContent)
                            .frame(minHeight: UIScreen.main.bounds.height - 100)
                    } else {
                        Text(topic.description)
                            .font(.body)
                            .foregroundColor(.black)
                            .lineSpacing(8)
                            .padding()
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.blue.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal)
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ContentView()
}
