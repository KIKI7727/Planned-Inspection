//
//  ContentView.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/4/25.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel: PlannedInspetionsViewModel = PlannedInspetionsViewModel()
  @State var data: String = ""
  var body: some View {
    VStack{
      Text("Planned inspections")
        .font(.title2)
      Button("search") {
        viewModel.fetchData()
      }
      VStack {
        if viewModel.errorMessage != "" {
          Text(viewModel.errorMessage)
        } else {
          Text (viewModel.data?.data.planner.dates.first?.date.value ?? "Date")
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
