/// Inspiration and Credit
/// https://gist.github.com/insidegui/97d821ca933c8627e7f614bc1d6b4983

import SwiftUI

#if canImport(UIKit)
public typealias PlatformView = UIView
public typealias PlatformViewRepresentable = UIViewRepresentable
#elseif canImport(AppKit)
public typealias PlatformView = NSView
public typealias PlatformViewRepresentable = NSViewRepresentable
#endif

/// Implementers get automatic `UIViewRepresentable` conformance on iOS
/// and `NSViewRepresentable` conformance on macOS.
public protocol AgnosticViewRepresentable: PlatformViewRepresentable {
    associatedtype ViewType

    func makeView(context: Context) -> ViewType
    func updateView(_ view: ViewType, context: Context)
}

#if canImport(UIKit)
public extension AgnosticViewRepresentable where ViewType == UIViewType {
    func makeUIView(context: Context) -> UIViewType {
        makeView(context: context)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateView(uiView, context: context)
    }
}
#elseif canImport(AppKit)
public extension AgnosticViewRepresentable where ViewType == NSViewType {
    func makeNSView(context: Context) -> NSViewType {
        makeView(context: context)
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        updateView(nsView, context: context)
    }
}
#endif
