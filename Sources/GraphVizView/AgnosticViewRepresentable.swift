// Credit: https://gist.github.com/insidegui/97d821ca933c8627e7f614bc1d6b4983

import SwiftUI

#if os(iOS) || os(tvOS)
public typealias PlatformView = UIView
public typealias PlatformViewRepresentable = UIViewRepresentable
#elseif os(macOS)
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

#if os(iOS) || os(tvOS) || os(visionOS)
public extension PlatformAgnosticViewRepresentable where ViewType == UIViewType {
    func makeUIView(context: Context) -> UIViewType {
        makeView(context: context)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateView(uiView, context: context)
    }
}
#elseif os(macOS)
public extension AgnosticViewRepresentable where ViewType == NSViewType {
    func makeNSView(context: Context) -> NSViewType {
        makeView(context: context)
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        updateView(nsView, context: context)
    }
}
#endif
