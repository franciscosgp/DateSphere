//
//  IconPickerView.swift
//  DSComponents
//

import SFSafeSymbols
import SwiftUI

// MARK: Icon Picker View

public struct DSIconPickerView: View {

    // MARK: Variables

    @Environment(\.dismiss) private var dismiss

    @Binding private var selectedIcon: String?
    @State private var searchText: String = ""

    private var filteredSymbols: [String] {
        if searchText.isEmpty {
            return SFSymbol.allSymbols.map(\.rawValue)
        } else {
            return SFSymbol.allSymbols.map(\.rawValue).filter { icon in
                searchText.split(separator: " ").allSatisfy { searchText in
                    icon.lowercased().contains(searchText.lowercased())
                }
            }
        }
    }

    let columns = [
        GridItem(.adaptive(minimum: 74), spacing: 16)
    ]

    // MARK: Initializers

    public init(selectedIcon: Binding<String?>) {
        self._selectedIcon = selectedIcon
    }

    // MARK: Body

    public var body: some View {
        NavigationStack {
            ZStack {
                if filteredSymbols.isEmpty {
                    DSFeedbackView(style: .warning,
                                   title: "no_icons_found".localized)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(filteredSymbols, id: \.self) { symbol in
                                Image(systemName: symbol)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(symbol == selectedIcon ? .accentColor : .primary)
                                    .onTapGesture {
                                        selectedIcon = symbol
                                        dismiss()
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("select_icon".localized)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.gray.opacity(0.1))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "photo.circle")
                            .resizable()
                            .scaledToFit()
                            .symbolRenderingMode(.palette)
                            .foregroundColor(.accentColor)
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.gray, .gray.opacity(0.2))
                            .font(.title2)
                    }
                }
            }
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .automatic),
                        prompt: "search_icon".localized)
        }
    }
}

// MARK: Preview

#Preview {
    DSIconPickerView(selectedIcon: .constant("heart.fill"))
}
