import Foundation

extension Bundle {
    var vizJSLibrary: String {
        let url = url(forResource: "viz-standalone", withExtension: "js")

        if let url, let content = try? String(contentsOf: url) {
            return content
        } else {
            fatalError("viz-standalone.js not found in resources")
        }
    }
}
