import SwiftUI
import WebKit

struct LaTeXView: UIViewRepresentable {
    let content: String
    @Binding var height: CGFloat
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.navigationDelegate = context.coordinator
        
        // Add message handler for size updates
        webView.configuration.userContentController.add(context.coordinator, name: "sizeHandler")
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
            <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
            <script>
                MathJax = {
                    tex: {
                        inlineMath: [['$', '$'], ['\\(', '\\)']],
                        displayMath: [['$$', '$$'], ['\\[', '\\]']],
                        processEscapes: true,
                        processEnvironments: true,
                        packages: ['base', 'ams', 'noerrors', 'noundefined']
                    },
                    options: {
                        skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre'],
                        ignoreHtmlClass: 'tex2jax_ignore',
                        processHtmlClass: 'tex2jax_process'
                    },
                    svg: {
                        fontCache: 'global'
                    },
                    startup: {
                        pageReady: () => {
                            return MathJax.startup.defaultPageReady().then(() => {
                                window.webkit.messageHandlers.sizeHandler.postMessage(document.body.scrollHeight);
                            });
                        }
                    }
                };
            </script>
            <style>
                :root {
                    --primary-color: #007AFF;
                    --text-color: #1C1C1E;
                    --background-color: #FFFFFF;
                    --card-background: rgba(255, 255, 255, 0.9);
                    --border-radius: 12px;
                    --spacing-unit: 8px;
                }
                
                * {
                    box-sizing: border-box;
                    margin: 0;
                    padding: 0;
                }
                
                body {
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                    font-size: 16px;
                    line-height: 1.5;
                    color: var(--text-color);
                    background-color: transparent;
                    padding: var(--spacing-unit);
                    -webkit-text-size-adjust: 100%;
                }
                
                .content-container, .exercise-content {
                    word-break: break-word;
                    overflow-wrap: anywhere;
                    max-width: 100%;
                    box-sizing: border-box;
                }
                
                .section {
                    background: var(--card-background);
                    border-radius: var(--border-radius);
                    padding: calc(var(--spacing-unit) * 2);
                    margin-bottom: calc(var(--spacing-unit) * 2);
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                }
                
                h1 {
                    font-size: 1.5em;
                    color: var(--text-color);
                    margin-bottom: var(--spacing-unit);
                    font-weight: 700;
                }
                
                h2 {
                    font-size: 1.3em;
                    color: var(--text-color);
                    margin: calc(var(--spacing-unit) * 1.5) 0 var(--spacing-unit);
                    font-weight: 600;
                }
                
                h3 {
                    font-size: 1.1em;
                    color: var(--text-color);
                    margin: var(--spacing-unit) 0;
                    font-weight: 500;
                }
                
                p {
                    margin: var(--spacing-unit) 0;
                    font-size: 0.95em;
                }
                
                .math {
                    font-size: 1.2em;
                    padding: 8px;
                }
                
                .math-inline {
                    font-size: 1em;
                    display: inline;
                }
                
                .math-block {
                    display: block;
                    text-align: center;
                    margin: var(--spacing-unit) 0;
                    overflow-x: auto;
                    background: rgba(0, 122, 255, 0.05);
                    padding: var(--spacing-unit);
                    border-radius: var(--border-radius);
                }
                
                .operation, .relation, .important-set {
                    background: var(--card-background);
                    padding: var(--spacing-unit);
                    border-radius: var(--border-radius);
                    margin-bottom: var(--spacing-unit);
                    border: 1px solid rgba(0, 0, 0, 0.1);
                }
                
                .operation h3, .relation h3, .important-set h3 {
                    color: var(--primary-color);
                    margin-bottom: calc(var(--spacing-unit) * 0.5);
                }
                
                .venn-diagram {
                    width: 100%;
                    max-width: 300px;
                    margin: var(--spacing-unit) auto;
                    text-align: center;
                }
                
                .venn-diagram svg {
                    width: 100%;
                    height: auto;
                    margin-bottom: var(--spacing-unit);
                }
                
                .diagram-caption {
                    font-size: 0.9em;
                    color: #666;
                    text-align: center;
                    margin-top: var(--spacing-unit);
                }
                
                ul {
                    list-style-type: none;
                    padding-left: 0;
                    margin-left: 0;
                    overflow-x: hidden;
                }
                
                li {
                    margin-bottom: var(--spacing-unit);
                    padding-left: calc(var(--spacing-unit) * 2);
                    position: relative;
                    font-size: 0.95em;
                    text-indent: -1em;
                    overflow-x: hidden;
                }
                
                li:before {
                    content: "•";
                    color: var(--primary-color);
                    position: absolute;
                    left: 0;
                }
                
                blockquote {
                    border-left: 3px solid var(--primary-color);
                    margin: var(--spacing-unit) 0;
                    padding: var(--spacing-unit);
                    background-color: rgba(0, 122, 255, 0.05);
                    border-radius: var(--border-radius);
                    font-size: 0.95em;
                }
                
                @media (min-width: 768px) {
                    .operation, .relation, .important-set {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: var(--spacing-unit);
                    }
                    
                    .operation h3, .relation h3, .important-set h3 {
                        grid-column: 1 / -1;
                    }
                }
            </style>
        </head>
        <body>
            <div class="content-container">
                \(content)
            </div>
        </body>
        </html>
        """
        uiView.loadHTMLString(html, baseURL: nil)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: LaTeXView
        
        init(_ parent: LaTeXView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let script = """
                window.webkit.messageHandlers.sizeHandler.postMessage(document.body.scrollHeight);
            """
            webView.evaluateJavaScript(script)
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if let height = message.body as? CGFloat {
                parent.height = height
            }
        }
    }
}

extension UIColor {
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
} 