//
//  DatePickerCellView.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/4/28.
//

import Foundation
import SwiftUI

struct DatePickerCellView: View {
  let isSelected: Bool
  let hasPlanned: Bool
  let dayWeek: String
  let dayMonth: String

  var bgColor: Color {
    if isSelected {
      return .black
    } else {
      return .clear
    }
  }

  var fgColor: Color {
    if isSelected {
      return .white
    } else if !hasPlanned {
      return .gray
    } else {
      return .black
    }
  }

  var body: some View {
    VStack(spacing: 15) {
      Text(dayWeek.prefix(3))
        .foregroundColor(hasPlanned ? .black : .gray)
      dayCell()
    }
    .bold()
  }

  func dayCell() -> some View {
    ZStack {
      Circle()
        .fill(bgColor)
        .frame(width: 45, height: 45)
      Text(dayMonth)
        .foregroundColor(fgColor)
    }
  }
}

struct DatePickerCellView_Previews: PreviewProvider {
  static var previews: some View {
    HStack(spacing: 100) {
      DatePickerCellView(isSelected: true, hasPlanned: true, dayWeek: "Wed", dayMonth: "26")
      DatePickerCellView(isSelected: false, hasPlanned: false, dayWeek: "Wed", dayMonth: "26")
    }
  }
}
