import SwiftUI
import WebKit

public struct GraphVizView: AgnosticViewRepresentable {
    public enum Scale: Hashable {
        case original
        case relative(percentage: Float)

        public static var sizeToFit: Self {
            .relative(percentage: 1)
        }
    }

    let graph: String
    let scale: Scale

    public init(graph: String, scale: Scale) {
        self.graph = graph
        self.scale = scale
    }

    public func makeView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator

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

    public func updateView(_ webView: WKWebView, context: Context) {
        let style = switch scale {
        case .original:
            ""
        case .relative(let percentage):
            "width:\(percentage * 100)%; height:\(percentage * 100)%;"
        }

        webView.evaluateJavaScript(
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

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    public class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
            print(message)
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            .allow
        }
    }
}

// MARK: - Previews

struct Previews: PreviewProvider {
    static var previews: some View {
        GraphVizView(
            graph: """
            digraph {
                A -> B
                B -> C
                B -> D
            }
            """,
            scale: .original
        )
    }
}
