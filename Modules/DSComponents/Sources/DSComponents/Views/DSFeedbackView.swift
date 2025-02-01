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

        case success(customTitle: String? = nil)
        case warning(customTitle: String? = nil)
        case error(customTitle: String? = nil)

        // MARK: Variables

        var title: String {
            switch self {
            case .success(let customTitle):
                return customTitle ?? "feedback_success_title".localized
            case .warning(let customTitle):
                return customTitle ?? "feedback_warning_title".localized
            case .error(let customTitle):
                return customTitle ?? "feedback_error_title".localized
            }
        }

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
    let message: String?
    let button: Button?
    @State private var isScrollEnabled: Bool = true

    // MARK: Initializers

    public init(style: Style = .error(), message: String? = nil, button: Button? = nil) {
        self.style = style
        self.message = message
        self.button = button
    }

    // MARK: Body

    public var body: some View {
        GeometryReader { geometry in
            ScrollView(isScrollEnabled ? .vertical : []) {
                VStack {

                    style.image
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()

                    Text(style.title)
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
                .frame(minHeight: geometry.size.height)
                .background(
                    GeometryReader { contentGeometry in
                        Color.clear
                            .onAppear {
                                isScrollEnabled = contentGeometry.size.height > geometry.size.height
                            }
                    }
                )
            }
        }


    }

}

#Preview {
    DSFeedbackView(message: "This view is empty",
                   button: .init(title: "Retry",
                                 action: { print("Button pressed") }))
}
