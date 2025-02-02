//
//  DSLoadingView.swift
//  DSComponents
//

import SwiftUI

// MARK: - DSLoadingView struct

public struct DSLoadingView: View {

    // MARK: Size enum

    public enum Size {

        // MARK: Cases

        case small
        case large

        // MARK: Variables

        var minScale: CGFloat {
            switch self {
            case .small: return 1.0
            case .large: return 2.0
            }
        }

        var maxScale: CGFloat {
            switch self {
            case .small: return 1.25
            case .large: return 4.5
            }
        }

    }

    // MARK: Variables

    let size: Size
    @State private var scale: CGFloat
    @State private var rotation: Double = .zero

    // MARK: Initializers

    public init(size: Size) {
        self.size = size
        self.scale = size.minScale
    }

    // MARK: Body

    public var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    scale = size.maxScale
                }
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }

}

// MARK: - Preview

#Preview {
    DSLoadingView(size: .large)
}
