//
//  DSFeedbackView.swift
//  DSComponents
//

import SwiftUI

// MARK: - DSFeedbackView struct

public struct DSFeedbackView: View {

    // MARK: Enum

    public enum Style {

        // MARK: Cases

        case success
        case warning
        case error

        // MARK: Variables

        var image: some View {
            switch self {
            case .success:
                return Image(systemName: "checkmark.circle")
                        .resizable()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.blue, color)
            case .warning:
                return Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, color)
            case .error:
                return Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, color)
            }
        }

        var color: Color {
            switch self {
            case .success:
                return .green
            case .warning:
                return .yellow
            case .error:
                return .red
            }
        }

    }

    // MARK: Button

    public struct Button {

        // MARK: Cases

        let title: String
        let action: () -> Void

        // MARK: Variables

        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }

    }

    // MARK: Variables

    let style: Style
    let title: String
    let message: String?
    let button: Button?

    // MARK: Initializers

    public init(style: Style = .error, title: String, message: String? = nil, button: Button? = nil) {
        self.style = style
        self.title = title
        self.message = message
        self.button = button
    }

    // MARK: Body

    public var body: some View {
        DSCenteredScrollView {

            style.image
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()

            Text(title)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let message = message {
                Text(message)
                    .lineLimit(4)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 2)
            }

            if let button = button {
                SwiftUI.Button(button.title) {
                    button.action()
                }
                .font(.headline)
                .buttonStyle(.borderedProminent)
                .accentColor(style.color)
                .padding()
            }

        }
    }

}

#Preview {
    DSFeedbackView(title: "This view is empty",
                   button: .init(title: "Retry",
                                 action: { print("Button pressed") }))
}
