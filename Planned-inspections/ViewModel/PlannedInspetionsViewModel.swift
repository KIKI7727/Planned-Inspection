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
  @Published var plannedData: PlannedInspections = PlannedInspections(title: "", subTitle: "", plannedCard: [])
  @Published var errorMessage: String = ""
  private var subscription: Set<AnyCancellable> = []
  @Published var plannedInspections: [PlannedInspections] = []
  private let dataRespository: PlannedInspectionsRepositoryProtocol

  init(dataRespository: PlannedInspectionsRepositoryProtocol = DataRespository.shared) {
    self.dataRespository = dataRespository
  }

  func fetchData() {
    dataRespository.getPlannedInspections()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        if case let .failure(error) = completion {
          self.errorMessage = error.description
        }
      } receiveValue: { [weak self] data in
        self?.dates = data.dates
        self?.plannedInspections = data.plannedInspections
      }
      .store(in: &subscription)
  }

  func showInspectionsByDate(by date: String) {
    self.plannedData = dataRespository.getPlannedInspections(date: date)
    print(self.plannedData)
  }

  func showDefaultInspections() {
    if dates.count > 0 {
      showInspectionsByDate(by: dates[0].date)
    }
  }
}
