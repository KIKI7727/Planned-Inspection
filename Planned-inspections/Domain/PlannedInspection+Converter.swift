//
//  PlannedInspection+Converter.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/5/8.
//

extension PlannedInspetion {
  func generateScrollDateData() -> [DaysModel] {
    return self.data.planner.dates.map {
      DaysModel(
        date: $0.date.display.longDate,
        dayofWeek: $0.date.display.dayOfWeek,
        dayofMonth: $0.date.display.dayOfMonth,
        planned: !$0.times.isEmpty
      )
    }
  }
}
