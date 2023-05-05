//
//  ScrollDatePickerView.swift
//  ScrollDatePicker
//
//  Created by cai dongyu on 2023/4/27.
//

import SwiftUI

struct ScrollDatePickerView: View {
  @StateObject var viewModel: PlannedInspetionsViewModel
  @State private var selectedIndex: Int = 0

  var body: some View {
    ZStack {
      Color.white
        .frame(height: 100)
        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)

      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(Array(viewModel.dates.enumerated()), id: \.offset) { index, date in
            DatePickerCellView(
              isSelected: self.selectedIndex == index ? true : false,
              hasPlanned: date.planned,
              dayWeek: date.dayofWeek,
              dayMonth: date.dayofMonth
            )
            .onTapGesture {
              if date.planned {
                self.selectedIndex = index
              }
            }
          }
        }.padding(.horizontal, 15)
      }
    }
  }
}
