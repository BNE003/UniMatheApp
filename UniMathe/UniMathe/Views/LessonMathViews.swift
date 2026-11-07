//
//  LessonMathViews.swift
//  UniMathe
//
//  Darstellung von Mathematik in den Schritt-für-Schritt-Lektionen:
//  - LessonRichText: Fließtext, der Inline-Formeln der Form \( … \) mit MathJax setzt.
//    Enthält der Text keine Formel, wird ganz normal ein SwiftUI-Text angezeigt.
//  - LessonFormulaView: abgesetzte Formel in einem horizontal scrollbaren Bereich
//    mit dauerhaft sichtbarer Scrollleiste, sobald die Formel breiter als der Kasten ist.
//

import SwiftUI

private func escapeHTML(_ text: String) -> String {
    text
        .replacingOccurrences(of: "&", with: "&amp;")
        .replacingOccurrences(of: "<", with: "&lt;")
        .replacingOccurrences(of: ">", with: "&gt;")
}

// MARK: - Fließtext mit Inline-Formeln

struct LessonRichText: View {
    let text: String
    var fontSize: CGFloat = 17
    var bold = false

    @State private var height: CGFloat

    init(_ text: String, fontSize: CGFloat = 17, bold: Bool = false) {
        self.text = text
        self.fontSize = fontSize
        self.bold = bold
        // Grobe Startschätzung, damit der Kasten beim Laden nicht stark springt.
        let estimatedLines = CGFloat(text.count) / 30 + CGFloat(text.components(separatedBy: "\n").count)
        _height = State(initialValue: max(24, estimatedLines * fontSize * 1.45))
    }

    static func containsMath(_ text: String) -> Bool {
        text.contains("\\(")
    }

    var body: some View {
        if Self.containsMath(text) {
            LaTeXView(content: html, height: $height, isScrollEnabled: false)
                .frame(height: height)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            Text(text)
                .font(.system(size: fontSize, weight: bold ? .semibold : .regular))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    /// Verhindert Zeilenumbrüche zwischen einer Inline-Formel und direkt anschließender
    /// Klammer bzw. Satzzeichen, z. B. „… \(A\)).“ würde sonst „).“ allein in die nächste Zeile setzen.
    private static let mathWithPunctuation = try? NSRegularExpression(
        pattern: #"([(„]?)(\\\(.*?\\\))([.,;:!?)“]*)"#
    )

    private static func keepPunctuationWithMath(_ html: String) -> String {
        guard let regex = mathWithPunctuation else { return html }
        let range = NSRange(html.startIndex..., in: html)
        return regex.stringByReplacingMatches(
            in: html,
            range: range,
            withTemplate: "<span style=\"white-space: nowrap\">$1$2$3</span>"
        )
    }

    private var html: String {
        let body = Self.keepPunctuationWithMath(escapeHTML(text))
            .replacingOccurrences(of: "\n", with: "<br>")
        return """
        <style>
            body { padding: 0 !important; }
            .content-container { overflow-wrap: break-word !important; word-break: normal !important; }
            .lesson-text {
                font-size: \(Int(fontSize))px;
                font-weight: \(bold ? 600 : 400);
                line-height: 1.45;
                text-align: left;
                -webkit-hyphens: auto;
                hyphens: auto;
            }
            .lesson-text mjx-container { font-size: 105% !important; }
        </style>
        <div class="lesson-text" lang="de">\(body)</div>
        """
    }
}

// MARK: - Abgesetzte Formel mit sichtbarer Scrollleiste

struct LessonFormulaView: View {
    let formula: String
    @State private var height: CGFloat = 60

    var body: some View {
        LaTeXView(content: html, height: $height, isScrollEnabled: false)
            .frame(height: height)
            .frame(maxWidth: .infinity)
    }

    private var html: String {
        let hint = SettingsModel.shared.language == .english
            ? "Swipe to see more"
            : "Wischen für mehr"
        return """
        <style>
            body { padding: 0 !important; overflow: hidden; }
            .fx-scroll {
                overflow-x: auto;
                overflow-y: hidden;
                -webkit-overflow-scrolling: touch;
                scrollbar-width: none;
            }
            .fx-scroll::-webkit-scrollbar { display: none; }
            .fx-inner { width: max-content; min-width: 100%; text-align: center; }
            .fx-inner mjx-container[display="true"] { margin: 0.3em 0 !important; font-size: 94% !important; }
            .fx-track {
                display: none;
                position: relative;
                height: 6px;
                margin: 10px 2px 0;
                border-radius: 3px;
                background: rgba(128, 128, 128, 0.25);
            }
            .fx-thumb {
                position: absolute;
                top: 0;
                height: 100%;
                border-radius: 3px;
                background: var(--primary-color);
            }
            .fx-hint {
                display: none;
                margin-top: 6px;
                font-size: 12px;
                text-align: center;
                color: var(--muted-text-color);
            }
        </style>
        <div class="fx-scroll" id="fx-scroll"><div class="fx-inner" id="fx-inner">$$\(escapeHTML(formula))$$</div></div>
        <div class="fx-track" id="fx-track"><div class="fx-thumb" id="fx-thumb"></div></div>
        <div class="fx-hint" id="fx-hint">← \(hint) →</div>
        <script>
            (function () {
                var scroller = document.getElementById('fx-scroll');
                var inner = document.getElementById('fx-inner');
                var track = document.getElementById('fx-track');
                var thumb = document.getElementById('fx-thumb');
                var hint = document.getElementById('fx-hint');
                function update() {
                    var overflow = scroller.scrollWidth - scroller.clientWidth;
                    var visible = overflow > 3;
                    var display = visible ? 'block' : 'none';
                    if (track.style.display !== display) {
                        track.style.display = display;
                        hint.style.display = display;
                    }
                    if (visible) {
                        var trackWidth = track.clientWidth;
                        var thumbWidth = Math.max(28, trackWidth * scroller.clientWidth / scroller.scrollWidth);
                        thumb.style.width = thumbWidth + 'px';
                        thumb.style.left = ((trackWidth - thumbWidth) * scroller.scrollLeft / overflow) + 'px';
                    }
                    if (typeof postContentHeight === 'function') { postContentHeight(); }
                }
                // Etwas zu breite Formeln leicht verkleinern (höchstens auf 78 %),
                // damit sie ohne Scrollen in den Kasten passen. Nur deutlich breitere
                // Formeln bleiben scrollbar.
                var fitted = false;
                function fit() {
                    if (fitted) { return; }
                    var natural = inner.scrollWidth;
                    var available = scroller.clientWidth;
                    if (natural <= 0 || available <= 0) { return; }
                    fitted = true;
                    if (natural > available + 2) {
                        var factor = Math.max(0.78, (available - 4) / natural);
                        inner.style.fontSize = (factor * 100).toFixed(1) + '%';
                    }
                    update();
                }
                function whenTypeset(callback) {
                    if (window.MathJax && MathJax.startup && MathJax.startup.promise) {
                        MathJax.startup.promise.then(callback);
                    } else {
                        setTimeout(function () { whenTypeset(callback); }, 50);
                    }
                }
                whenTypeset(fit);
                scroller.addEventListener('scroll', update, { passive: true });
                window.addEventListener('load', update);
                window.addEventListener('resize', update);
                if (typeof ResizeObserver !== 'undefined') {
                    new ResizeObserver(update).observe(inner);
                }
                [100, 400, 900, 1600].forEach(function (t) { setTimeout(update, t); });
            })();
        </script>
        """
    }
}
