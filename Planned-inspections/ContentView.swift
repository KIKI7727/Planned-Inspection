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
    VStack {
      Text("Planned inspections")
        .font(.title2)
      ScrollDatePickerView(viewModel: viewModel)

      if let plannedData = viewModel.plannedData {
        InspectionView(data: plannedData)
          .padding()
      } else {
        Spacer()
        Text(viewModel.noEventTips)
        Spacer()
      }
      Spacer()
    }
    .edgesIgnoringSafeArea(.bottom)
    .onAppear {
      viewModel.fetchData()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
