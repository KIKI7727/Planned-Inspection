//
//  NetworkService.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/4/25.
//

import Foundation
import Combine

protocol DataService {
  func fetchData(url: String) -> AnyPublisher<PlannedInspetion, NetworkError>
}

enum NetworkError: Error, CustomStringConvertible {
  case badURL
  case badNetwork(error: Error)
  case badDecode
  case unknown
  
  var description: String {
    switch self {
    case .badURL:
      return "无效的URL"
    case .badNetwork(let error):
      return "网络错误: \(error.localizedDescription)_"
    case .badDecode:
      return "解码错误"
    case .unknown:
      return "未知错误"
    }
  }
}

class NetworkService: DataService {
  func fetchData(url: String) -> AnyPublisher <PlannedInspetion, NetworkError> {
    return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
      .tryMap { response in
        guard let httpResponse = response.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          throw URLError(.badServerResponse)
        }
        return response.data
      }
      .decode(type: PlannedInspetion.self, decoder: JSONDecoder())
      .mapError { error -> NetworkError in
        switch error {
        case is URLError:
          return .badNetwork(error: error)
        case is DecodingError:
          return .badDecode
        default:          
          return error as? NetworkError ?? .unknown
        }
      }
      .eraseToAnyPublisher()
  }
}
