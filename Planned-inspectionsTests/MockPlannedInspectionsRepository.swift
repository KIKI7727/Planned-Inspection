//
//  MockPlannedInspectionsRepository.swift
//  Planned-inspectionsTests
//
//  Created by cai dongyu on 2023/5/10.
//

import Combine
@testable import Planned_inspections
import XCTest

class MockPlannedInspectionsRepository: PlannedInspectionsRepositoryProtocol {
  var isSuccess = true
  var plannedInspectionsContent: PlannedInspectionsContent = PlannedInspectionsContent(dates: [], plannedInspections: [], noEventTips: "")

  func getPlannedInspections() -> AnyPublisher<PlannedInspectionsContent, NetworkError> {
    if isSuccess {
      return Just(plannedInspectionsContent)
        .setFailureType(to: NetworkError.self)
        .eraseToAnyPublisher()
    } else {
      return Fail(error: NetworkError.badDecode)
        .eraseToAnyPublisher()
    }
  }

  func getPlannedInspections(date: String) -> PlannedInspections? {
    if date != "26" { return nil }

    return PlannedInspections(title: "inspection", subTitle: "4 inspection", plannedCard: [PlannedCardInfo(inspection: [InspectionInfo(title: "title", address: "address", imageURL: "imageURL", bathrooms: 2, bedrooms: 3, parkingSpaces: 4)])])
  }
}
