//
//  DSBounceAnimationOnTapViewModifier.swift
//  DSComponents
//

import SwiftUI

// MARK: - DSBounceAnimationOnTapViewModifier struct

public struct DSBounceAnimationOnTapViewModifier: ViewModifier {

    // MARK: Variables

    let enabled: Bool
    let maxScale: CGFloat
    @State var scale: CGFloat = 1.0

    // MARK: Initializers

    public init(enabled: Bool, maxScale: CGFloat = 1.2) {
        self.enabled = enabled
        self.maxScale = maxScale
    }

    // MARK: Body

    public func body(content: Content) -> some View {
        if enabled {
            content
                .scaleEffect(scale)
                .onTapGesture {
                    withAnimation(.interpolatingSpring(stiffness: 150, damping: 5)) {
                        self.scale = self.maxScale
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.interpolatingSpring(stiffness: 150, damping: 5)) {
                            self.scale = 1.0
                        }
                    }
                }
        } else {
            content
        }
    }

}
