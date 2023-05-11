//
//  InspectionView.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/5/7.
//

import SwiftUI

struct InspectionView: View {
  let data: PlannedInspections

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {
        Text(data.title)
          .font(.title2).bold()
        Text(data.subTitle)

        ForEach(Array(data.plannedCard.enumerated()), id: \.offset) { index, card in
          HStack {
            indexWithBackgroundView(index: index + 1)
            Text(card.timeslot).bold()
          }
          ForEach(card.inspection, id: \.self) { inspection in
            InspectionCardView(card: inspection)
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(5)
    }
  }
}

struct InspectionCardView: View {
  let card: InspectionInfo

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        VStack(alignment: .leading, spacing: 10) {
          Text("Inspection").bold()
          Text(card.address).lineLimit(2)

          HStack {
            if card.bedrooms != 0 {
              Image(systemName: "bed.double")
              Text("\(card.bedrooms)")
            }
            Image(systemName: "bathtub")
            Text("\(card.bathrooms)")
            if card.parkingSpaces != 0 {
              Image(systemName: "parkingsign.circle")
              Text("\(card.parkingSpaces)")
            }
          }
        }

        AsyncImage(url: URL(string: card.imageURL), content: { phase in
          if let image = phase.image {
            image
              .resizable()
              .frame(width: 100, height: 80)
          } else {
            Image(systemName: "photo.on.rectangle.angled")
              .resizable()
              .frame(width: 100, height: 80)
          }
        })
      }
      Divider()
      Button {} label: {
        HStack {
          Spacer()
          Image(systemName: "arrow.turn.up.right")
          Text("Get directions")
          Spacer()
        }
      }
    }
    .padding()
    .frame(width: UIScreen.main.bounds.width - 40)
    .background(
      Color.white
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.5), radius: 2, x: 0, y: 0))
  }
}

struct indexWithBackgroundView: View {
  let index: Int
  let color: Color = .black

  var body: some View {
    Text("\(index)")
      .foregroundColor(.white)
      .padding()
      .background(Circle().frame(width: 30))
  }
}
