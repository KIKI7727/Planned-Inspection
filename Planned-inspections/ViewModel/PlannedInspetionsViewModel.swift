//
//  PlannedInspetionsViewModel.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/4/25.
//

import Combine
import Foundation

class PlannedInspetionsViewModel: ObservableObject {
  @Published var data: PlannedInspetion?
  @Published var dates: [DaysModel] = []
  @Published var errorMessage: String = ""
  private var subscription: Set<AnyCancellable> = []
  let service: DataService

  init(service: DataService = NetworkService()) {
    self.service = service
  }

  func fetchData() {
    service.fetchData(url: "https://raw.githubusercontent.com/nancymi/planned-inspection-bff/main/planned_inspections.json")
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        if case let .failure(error) = completion {
          self.errorMessage = error.description
        }
      }, receiveValue: { [weak self] data in
        self?.data = data
        self?.dates = self?.data?.generateScrollDateData() ?? []
      })
      .store(in: &subscription)
  }
}
