# Mengen und Abbildungen

## 1. Grundbegriffe der Mengenlehre

Eine **Menge** ist eine Zusammenfassung bestimmter, wohlunterschiedener Objekte zu einem Ganzen (Georg Cantor, 1895).55

### Wichtige Eigenschaften:
- Jedes Objekt gehört entweder zur Menge oder nicht
- Die Reihenfolge der Elemente ist unwichtig
- Jedes Element kommt nur einmal vor

### Beispiele:
- Menge der natürlichen Zahlen: $\mathbb{N} = \{1, 2, 3, \dots\}$
- Menge der ganzen Zahlen: $\mathbb{Z} = \{\dots, -2, -1, 0, 1, 2, \dots\}$
- Menge der rationalen Zahlen: $\mathbb{Q} = \left\{ \frac{p}{q} \mid p \in \mathbb{Z}, q \in \mathbb{N} \right\}$
- Menge der reellen Zahlen: $\mathbb{R}$

## 2. Mengenoperationen

### Vereinigung
$A \cup B = \{ x \mid x \in A \text{ oder } x \in B \}$
Die Vereinigung enthält alle Elemente, die in A oder B vorkommen.

### Durchschnitt
$A \cap B = \{ x \mid x \in A \text{ und } x \in B \}$
Der Durchschnitt enthält nur die Elemente, die in beiden Mengen vorkommen.

### Differenz
$A \setminus B = \{ x \in A \mid x \notin B \}$
Die Differenz enthält die Elemente von A, die nicht in B vorkommen.

### Komplement
$A^c = \{ x \mid x \notin A \}$
Das Komplement enthält alle Elemente, die nicht in A vorkommen.

## 3. Beziehungen zwischen Mengen

### Teilmenge
$A \subseteq B \Leftrightarrow \forall x \in A: x \in B$
A ist Teilmenge von B, wenn jedes Element von A auch in B enthalten ist.

### Echte Teilmenge
$A \subset B \Leftrightarrow A \subseteq B \text{ und } A \neq B$
A ist echte Teilmenge von B, wenn A Teilmenge von B ist und A ungleich B ist.

### Gleichheit
$A = B \Leftrightarrow A \subseteq B \text{ und } B \subseteq A$
Zwei Mengen sind gleich, wenn sie dieselben Elemente enthalten.

## 4. Wichtige Mengen

### Leere Menge
$\emptyset = \{ \}$
Die Menge ohne Elemente.

### Potenzmenge
$\mathcal{P}(A) = \{ X \mid X \subseteq A \}$
Die Menge aller Teilmengen von A.

### Kartesisches Produkt
$A \times B = \{ (a,b) \mid a \in A, b \in B \}$
Die Menge aller geordneten Paare (a,b) mit a aus A und b aus B.

## 5. Abbildungen zwischen Mengen

### Definition einer Abbildung
$f: A \to B$
Eine Abbildung $f$ von $A$ nach $B$ ordnet jedem Element $a \in A$ genau ein Element $b \in B$ zu.

### Eigenschaften von Abbildungen
- **Injektiv:** $\forall a_1, a_2 \in A: f(a_1) = f(a_2) \Rightarrow a_1 = a_2$
- **Surjektiv:** $\forall b \in B \exists a \in A: f(a) = b$
- **Bijektiv:** injektiv und surjektiv

### Komposition von Abbildungen
$(g \circ f)(x) = g(f(x))$
Die Komposition zweier Abbildungen $f: A \to B$ und $g: B \to C$ ist eine neue Abbildung $g \circ f: A \to C$.

### Umkehrabbildung
$f^{-1}: B \to A$
Die Umkehrabbildung $f^{-1}$ existiert genau dann, wenn $f$ bijektiv ist.

## 6. Wichtige Abbildungen

### Identitätsabbildung
$\text{id}_A: A \to A, \quad \text{id}_A(a) = a$
Die Identitätsabbildung bildet jedes Element auf sich selbst ab.

### Konstante Abbildung
$f: A \to B, \quad f(a) = b_0 \text{ für alle } a \in A$
Eine konstante Abbildung bildet alle Elemente auf denselben Wert ab.

### Einschränkung einer Abbildung
$f|_C: C \to B, \quad f|_C(c) = f(c) \text{ für } C \subseteq A$
Die Einschränkung einer Abbildung auf eine Teilmenge des Definitionsbereichs. 
