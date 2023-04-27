//
//  PlannedInspetionsViewModel.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/4/25.
//

import Foundation
import Combine

class PlannedInspetionsViewModel:  ObservableObject {

  @Published var data: PlannedInspetion? = nil
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
        if case .failure(let error) = completion {
          self.errorMessage = error.description
        }
      }, receiveValue: { [weak self] data in
        self?.data = data
      })
      .store(in: &subscription)
  }
}

