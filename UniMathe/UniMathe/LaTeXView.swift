import SwiftUI
import WebKit

struct LaTeXView: UIViewRepresentable {
    let content: String
    @Binding var height: CGFloat

    private static let sharedProcessPool = WKProcessPool()
    private static func makeConfiguration(coordinator: Coordinator) -> WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.processPool = sharedProcessPool
        config.websiteDataStore = .default()
        config.userContentController = WKUserContentController()
        config.userContentController.add(coordinator, name: "sizeHandler")
        return config
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: Self.makeConfiguration(coordinator: context.coordinator))
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.navigationDelegate = context.coordinator
        // Allow horizontal scrolling inside overflow elements; prevent rubber-banding
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = false
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Only reload HTML when the content actually changes to prevent scroll resets
        guard context.coordinator.lastContent != content else {
            // Content unchanged: request a height re-measure in case width changed (e.g., rotation)
            let script = "window.requestAnimationFrame(() => { try { window.webkit.messageHandlers.sizeHandler.postMessage(document.body.scrollHeight); } catch(e){} });"
            uiView.evaluateJavaScript(script, completionHandler: nil)
            return
        }

        let mathJaxBundleURL = Bundle.main.url(forResource: "MathJax", withExtension: "bundle")
        let resourceBaseURL = mathJaxBundleURL ?? Bundle.main.resourceURL
        let mathJaxSrc: String
        let polyfillSrc: String
        if mathJaxBundleURL != nil {
            mathJaxSrc = "es5/tex-mml-chtml.js"
            polyfillSrc = "polyfill.min.js"
        } else {
            mathJaxSrc = "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"
            polyfillSrc = "https://polyfill.io/v3/polyfill.min.js?features=es6"
        }

        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
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
            <script src="\(polyfillSrc)"></script>
            <script id="MathJax-script" defer src="\(mathJaxSrc)"></script>
            <script>
                let lastHeight = { value: null };
                function postContentHeight() {
                    try {
                        const height = document.body.scrollHeight;
                        if (lastHeight.value === null || Math.abs(lastHeight.value - height) > 0.5) {
                            lastHeight.value = height;
                            window.webkit.messageHandlers.sizeHandler.postMessage(height);
                        }
                    } catch (e) {
                        // no-op
                    }
                }
                window.addEventListener('load', postContentHeight);
                window.addEventListener('resize', postContentHeight);
                if (typeof ResizeObserver !== 'undefined') {
                    new ResizeObserver(postContentHeight).observe(document.body);
                }
                // Fallback periodic checks in case MathJax layout updates asynchronously
                setTimeout(postContentHeight, 100);
                setTimeout(postContentHeight, 300);
                setTimeout(postContentHeight, 600);
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
                    overflow-y: hidden; /* prevent inner vertical scrollbars */
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
                     -webkit-overflow-scrolling: touch; /* smooth horizontal scroll */
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
        context.coordinator.lastContent = content
        uiView.loadHTMLString(html, baseURL: resourceBaseURL)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: LaTeXView
        var lastContent: String?
        var lastReportedHeight: CGFloat?
        
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
            // MathJax posts numeric height; handle Double/NSNumber safely and avoid redundant updates
            let newHeight: CGFloat?
            if let number = message.body as? NSNumber {
                newHeight = CGFloat(truncating: number)
            } else if let doubleValue = message.body as? Double {
                newHeight = CGFloat(doubleValue)
            } else if let intValue = message.body as? Int {
                newHeight = CGFloat(intValue)
            } else {
                newHeight = nil
            }

            guard let heightValue = newHeight else { return }

            DispatchQueue.main.async {
                // Update only if height changed meaningfully
                let epsilon: CGFloat = 0.5
                if let last = self.lastReportedHeight, abs(last - heightValue) <= epsilon, abs(self.parent.height - heightValue) <= epsilon {
                    return
                }
                self.lastReportedHeight = heightValue
                self.parent.height = heightValue
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
