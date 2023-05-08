//
//  PlannedInspectionsModel.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/5/8.
//

import Foundation

struct DaysModel {
  let date: String
  let dayofWeek: String
  let dayofMonth: String
  let planned: Bool
}

struct PlannedInspections {
  let title: String
  let subTitle: String
  let plannedCard: [PlannedCardInfo]
}

struct PlannedCardInfo {
  var timeslot: String = ""
  let inspection: [InspectionInfo]
}

struct InspectionInfo: Hashable {
  let title: String
  let address: String
  let bathrooms: Int
  let bedrooms: Int
  let parkingSpaces: Int
}

struct PlannedInspectionsContent {
  let dates: [DaysModel]
  let plannedInspections: [PlannedInspections]
}
