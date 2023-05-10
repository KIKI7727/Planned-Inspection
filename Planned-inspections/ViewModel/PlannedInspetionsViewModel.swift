//
//  PlannedInspetionsViewModel.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/4/25.
//

import Combine
import Foundation

class PlannedInspetionsViewModel: ObservableObject {
  @Published var dates: [DaysModel] = []
  @Published var plannedData: PlannedInspections?
  @Published var errorMessage: String = ""
  private var subscription: Set<AnyCancellable> = []
  @Published var plannedInspections: [PlannedInspections] = []
  let dataRespository: PlannedInspectionsRepositoryProtocol
  var noEventTips: String = ""

  init(dataRespository: PlannedInspectionsRepositoryProtocol = PlannedInspectionsRespository.shared) {
    self.dataRespository = dataRespository
  }

  func fetchData() {
    dataRespository.getPlannedInspections()
      .sink { completion in
        if case let .failure(error) = completion {
          self.errorMessage = error.description
        }
      } receiveValue: { [weak self] data in
        self?.dates = data.dates
        self?.plannedInspections = data.plannedInspections
        self?.noEventTips = data.noEventTips
        self?.showDefaultInspections()
      }
      .store(in: &subscription)
  }

  func showInspectionsByDate(by date: String) {
    self.plannedData = dataRespository.getPlannedInspections(date: date)
  }

  func showDefaultInspections() {
    if let date = dates.first {
      showInspectionsByDate(by: date.date)
    }
  }
}
