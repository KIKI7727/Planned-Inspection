//
//  Repository.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/4/28.
//

import Foundation

struct DaysModel {
  let date: String
  let dayofWeek: String
  let dayofMonth: String
  let planned: Bool
}

struct PlannedRespository {
  var title: String = ""
  var inspectionCount: Int = 0
  var plannedCard: [PlannedCardInfo] = []
}

struct PlannedCardInfo {
  var timeslot: String = ""
  var inspection: [InspectionInfo] = []
}

struct InspectionInfo {
  var title: String = ""
  var address: String = "19.05/116  Bathurst Street, Sydney, NSW 2000"
  var bathrooms: Int = 0
  var bedrooms: Int = 0
  var parkingSpaces: Int = 0
}
