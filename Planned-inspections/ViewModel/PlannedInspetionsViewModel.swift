//
//  PlannedInspetionsViewModel.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/4/25.
//

import Foundation
import Combine

class PlannedInspetionsViewModel:  ObservableObject {
  @Published var data: PlannedInspetion?
  @Published var errorMessage: String = ""
  private var subscription: Set<AnyCancellable> = []
  let service: DataService
  
  init(service: DataService = NetworkService()) {
    self.service = service
  }
  
  func fetchData() {
    let data: AnyPublisher<PlannedInspetion, Error> = service.fetchData(url: "https://raw.githubusercontent.com/nancymi/planned-inspection-bff/main/planned_inspections.json")
    data
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          self.errorMessage = (error as? NetworkError)?.description ?? ""
        }
      }, receiveValue: { [weak self] data in
        self?.data = data
//        print(self?.data)
      })
      .store(in: &subscription)
  }
}
