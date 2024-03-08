import SwiftUI
import WebKit

#if os(macOS)
import AppKit

struct GraphView: NSViewRepresentable {
    let graph: String
    let scale: Scale

    func makeNSView(context: Context) -> some WKWebView {
        let webView = WKWebView.webViewWithGraph(graph, scale: scale)
        webView.allowsMagnification = true
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateNSView(_ webView: some WKWebView, context: Context) {
        webView.updateWebView(scale: scale)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
#endif

#if os(iOS)
struct GraphView: UIViewRepresentable {
    let graph: String
    let scale: Scale

    func makeUIView(context: Context) -> some WKWebView {
        let webView = WKWebView.webViewWithGraph(graph, scale: scale)
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: some WKWebView, context: Context) {
        webView.updateWebView(scale: scale)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
#endif

class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        print(message)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        return .cancel
    }
}


struct Preview: PreviewProvider {
    static var previews: some View {
        GraphView(
            graph: """
                digraph {
                  a -> b
                }
            """,
            scale: .original
        )
    }
}

extension WKWebView {
    static func webViewWithGraph(_ graph: String, scale: Scale) -> WKWebView {
        let webView = WKWebView()

        let html = """
            <!DOCTYPE html>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <script>
                \(Bundle.module.vizJSLibrary)

                Viz.instance().then(
                    function(viz) {
                        const svg = viz.renderSVGElement(
                            '\(graph.replacing("\n", with: "\\n"))'
                        );

                        svg.id = "svg";
                        svg.style = "width:100%; height: 100%";

                        document.body.appendChild(svg);
                    }
                );

            </script>
            </html>
        """

        webView.loadHTMLString(html, baseURL: nil)

        return webView
    }

    func updateWebView(scale: Scale) {
        let style = switch scale {
        case .original:
            ""
        case .relative(let percentage):
            "width:\(percentage * 100)%; height:\(percentage * 100)%;"
        }

        evaluateJavaScript(
            """
            var graph = document.getElementById("svg");

            // set new style
            graph.style = '\(style)';

            var graphWidth = graph.getBoundingClientRect().width;
            var graphHeight = graph.getBoundingClientRect().height;
            var viewportWidth = document.documentElement.clientWidth;
            var viewportHeight = document.documentElement.clientHeight;

            // set scroll position
            document.documentElement.scrollLeft = (graphWidth - viewportWidth) / 2;
            document.documentElement.scrollTop = (graphHeight - viewportHeight) / 2;
            """
        )
    }
}

enum Scale: Hashable {
    case original
    case relative(percentage: Float)

    static var sizeToFit: Self {
        .relative(percentage: 1)
    }
}
