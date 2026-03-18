//
//  DSCenteredScrollView.swift
//  DSComponents
//

import SwiftUI

// MARK: - DSCenteredScrollView struct

public struct DSCenteredScrollView<Content: View>: View {

    // MARK: Variables

    let content: Content
    @State private var isScrollEnabled: Bool = true

    // MARK: Initializers

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: Variables

    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    content
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: geometry.size.height)
                    .background(
                        GeometryReader { contentGeometry in
                            Color.clear
                                .onAppear {
                                    isScrollEnabled = contentGeometry.size.height > geometry.size.height
                                }
                                .onChange(of: contentGeometry.size.height) { newValue in
                                    isScrollEnabled = newValue > geometry.size.height
                                }
                        }
                    )
            }
            .scrollDisabled(!isScrollEnabled)
        }
    }

}
