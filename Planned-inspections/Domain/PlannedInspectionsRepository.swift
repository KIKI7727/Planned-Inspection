//
//  Repository.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/4/28.
//

import Combine
import Foundation

protocol PlannedInspectionsRepositoryProtocol {
  func getPlannedInspections() -> AnyPublisher<PlannedInspectionsContent, NetworkError>
  func getPlannedInspections(date: String) -> PlannedInspections?
}

class PlannedInspectionsRespository: PlannedInspectionsRepositoryProtocol {
  static let shared = PlannedInspectionsRespository(service: NetworkService.shared)

  private let service: NetworkService

  private init(service: NetworkService) {
    self.service = service
  }

  private var cache = [String: PlannedInspections]()
  private var numInspectionsOne = ""
  private var numInspectionsPlural = ""

  func getPlannedInspections() -> AnyPublisher<PlannedInspectionsContent, NetworkError> {
    service.fetchData(url: "https://raw.githubusercontent.com/nancymi/planned-inspection-bff/main/planned_inspections.json")
      .map { data -> PlannedInspectionsContent in
        self.numInspectionsOne = data.data.planner.displayStrings.dateSummary.numInspectionsTemplatedOne
        self.numInspectionsPlural = data.data.planner.displayStrings.dateSummary.numInspectionsTemplatedPlural
        let dates = data.generateScrollDateData()
        let inspections = data.data.planner.dates.map { date in
          let value: PlannedInspections = self.convert(date)
          self.cache.updateValue(value, forKey: date.date.display.longDate)
          return value
        }
        let planned = PlannedInspectionsContent(
          dates: dates,
          plannedInspections: inspections,
          noEventTips: data.data.planner.displayStrings.noEvents.forDate
        )

        return planned
      }
      .eraseToAnyPublisher()
  }

  func getPlannedInspections(date: String) -> PlannedInspections? {
    return cache[date]
  }

  // 替代循环的高阶函数
  private func convertToDictionary(by data: PlannedInspetion) {
    for date in data.data.planner.dates {
      cache.updateValue(convert(date), forKey: date.date.display.longDate)
    }
  }

  private func convert(_ data: DateElement) -> PlannedInspections {
    let inspectionCount = data.times.reduce(0) {
      if $1.entries.count != 2 {
        return $0 + $1.entries.count
      } else {
        return $0
      }
    }
    let template = inspectionCount == 1 ? numInspectionsOne : numInspectionsPlural
    return PlannedInspections(
      title: data.date.display.longDate,
      subTitle: template.replacingOccurrences(of: "{count}", with: String(inspectionCount)),
      plannedCard: convertCardInfo(data.times)
    )
  }

  private func convertCardInfo(_ times: [TimeElement]) -> [PlannedCardInfo] {
    return times.map {
      PlannedCardInfo(
        timeslot: $0.time.display,
        inspection: $0.entries.map {
          InspectionInfo(
            title: $0.title,
            address: $0.address,
            imageURL: $0.listing.media.mainImage.templatedUrl,
            bathrooms: $0.listing.generalFeatures.bathrooms.value,
            bedrooms: $0.listing.generalFeatures.bedrooms.value,
            parkingSpaces: $0.listing.generalFeatures.parkingSpaces.value
          )
        }
      )
    }
  }
}
