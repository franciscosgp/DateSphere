//
//  DSIconView.swift
//  DSComponents
//

import SwiftUI

// MARK: - DSIconView struct

public struct DSIconView: View {

    // MARK: Constants

    enum Constants {
        static let scaleWithBackground: CGFloat = 0.8
        static let noIconBackgroundColor: Color = .gray.opacity(0.2)
    }

    // MARK: Variables

    @Binding var systemSymbolName: String?
    @Binding var mainColor: Color
    @Binding var secondaryColor: Color
    @Binding var backgroundColor: Color
    @State private var isVisible: Bool = true
    let size: CGFloat
    let noIconText: String?
    let bounceOnTap: Bool

    // MARK: Initializers

    public init(systemSymbolName: Binding<String?>,
                mainColor: Binding<Color>,
                secondaryColor: Binding<Color> = .constant(.clear),
                backgroundColor: Binding<Color> = .constant(.clear),
                size: CGFloat = 150,
                noIconText: String? = nil,
                bounceOnTap: Bool = false) {
        self._systemSymbolName = systemSymbolName
        self._mainColor = mainColor
        self._secondaryColor = secondaryColor
        self._backgroundColor = backgroundColor
        self.size = size
        self.noIconText = noIconText
        self.bounceOnTap = bounceOnTap
    }

    public init(systemSymbolName: String? = nil,
                mainColor: Color,
                secondaryColor: Color = .clear,
                backgroundColor: Color = .clear,
                size: CGFloat = 60,
                noIconText: String? = nil,
                bounceOnTap: Bool = false) {
        self._systemSymbolName = .constant(systemSymbolName)
        self._mainColor = .constant(mainColor)
        self._secondaryColor = .constant(secondaryColor)
        self._backgroundColor = .constant(backgroundColor)
        self.size = size
        self.noIconText = noIconText
        self.bounceOnTap = bounceOnTap
    }

    // MARK: Body

    public var body: some View {
        Circle()
            .fill(systemSymbolName == nil ? Constants.noIconBackgroundColor : backgroundColor)
            .scaledToFit()
            .frame(width: size, height: size)
            .overlay {
                if let systemSymbolName = systemSymbolName {
                    Image(systemName: systemSymbolName)
                        .resizable()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(mainColor, secondaryColor.isClear ? mainColor : secondaryColor)
                        .scaledToFit()
                        .frame(width: size * (backgroundColor.isClear ? 1 : Constants.scaleWithBackground),
                               height: size * (backgroundColor.isClear ? 1 : Constants.scaleWithBackground),
                               alignment: .center)
                        .modifier(DSBounceAnimationOnTapViewModifier(enabled: bounceOnTap))
                } else {
                    if let noIconText {
                        Text(noIconText)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                    } else {
                        Image(systemName: "questionmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: size * Constants.scaleWithBackground,
                                   height: size * Constants.scaleWithBackground,
                                   alignment: .center)
                            .foregroundStyle(Color.gray.opacity(0.8))
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isVisible)
                            .onAppear {
                                isVisible.toggle()
                            }
                    }
                }
            }

    }

}

// MARK: - Preview

#Preview {
    DSIconView(systemSymbolName: "heart.fill",
               mainColor: .red,
               secondaryColor: .blue,
               backgroundColor: .green,
               size: 200,
               noIconText: "No icon",
               bounceOnTap: true)
}
