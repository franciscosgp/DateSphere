//
//  DetailView.swift
//  DateSphere
//

import SwiftUI

struct DetailView: View {
    let event: EventDomainModel
    @State private var scale: CGFloat = 1.0

    var body: some View {
        VStack {
            Circle()
                .fill(event.backgroundColor ?? .clear)
                .frame(width: 200, height: 200)
                .overlay {
                    Image(systemName: event.iconName ?? "questionmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: event.backgroundColor == nil ? 180 : 100, height: event.backgroundColor == nil ? 180 : 100, alignment: .center)
                        .foregroundStyle(event.foregroundColor ?? .accentColor)
                        .scaleEffect(scale)
                }
                .onTapGesture {
                    withAnimation(.interpolatingSpring(stiffness: 150, damping: 5)) {
                        self.scale = 1.2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.interpolatingSpring(stiffness: 150, damping: 5)) {
                            self.scale = 1.0
                        }
                    }
                }
                .padding()
            if event.date.isInFuture {
                Text("Quedan \(event.date.numberOfDays) días")
                    .font(.title)
                    .padding()
            } else {
                Text("Llevamos \(event.date.numberOfDays) días")
                    .font(.title)
                    .padding()
            }
            Text(event.date.dateFormatted)
                .font(.title2)
                .padding()
            if let description = event.description {
                Text(description)
                    .font(.title3)
                    .padding()
            }
        }.navigationTitle(event.name)
    }
}

#Preview {
    NavigationView {
        DetailView(event: EventDomainModel(name: "Example", description: "This is a example", iconName: "heart", foregroundColor: .black, backgroundColor: .white, date: Date()))
    }
}
