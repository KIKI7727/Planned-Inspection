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
  func getPlannedInspections(date: String) -> PlannedInspections
}

class DataRespository: PlannedInspectionsRepositoryProtocol {
  static let shared = DataRespository(service: NetworkService.shared)

  private let service: NetworkService

  private init(service: NetworkService) {
    self.service = service
  }

  private var cache = [String: PlannedInspections]()

  func getPlannedInspections() -> AnyPublisher<PlannedInspectionsContent, NetworkError> {
    service.fetchData(url: "https://raw.githubusercontent.com/nancymi/planned-inspection-bff/main/planned_inspections.json")
      .map { data -> PlannedInspectionsContent in
        let dates = data.generateScrollDateData()
        let inspections = data.data.planner.dates.map { date in
          let value: PlannedInspections = self.convert(date)
          self.cache.updateValue(value, forKey: date.date.display.longDate)
          return value
        }

        let planned = PlannedInspectionsContent(dates: dates, plannedInspections: inspections)

        return planned
      }
      .eraseToAnyPublisher()
  }

  func getPlannedInspections(date: String) -> PlannedInspections {
    return cache[date] ?? PlannedInspections(title: "", subTitle: "", plannedCard: [])
  }

  private func convertToDictionary(by data: PlannedInspetion) {
    for date in data.data.planner.dates {
      cache.updateValue(convert(date), forKey: date.date.display.longDate)
    }
  }

  private func convert(_ data: DateElement) -> PlannedInspections {
    let inspectionCount = data.times.reduce(0) { $0 + $1.entries.count }
    return PlannedInspections(
      title: data.date.display.longDate,
      subTitle: inspectionCount > 1 ? "\(inspectionCount) inspections" : "\(inspectionCount) inspection",
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
            bathrooms: $0.listing.generalFeatures.bathrooms.value,
            bedrooms: $0.listing.generalFeatures.bedrooms.value,
            parkingSpaces: $0.listing.generalFeatures.parkingSpaces.value
          )
        }
      )
    }
  }
}
