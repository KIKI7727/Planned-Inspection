//
//  ContentView.swift
//  Planned-inspections
//
//  Created by cai dongyu on 2023/4/25.
//

import SwiftUI

struct ContentView: View {
  @State private var date = Date.now
  var body: some View {
    VStack{
      Text("Planned inspections")
        .font(.title2)
      HStack {
        DatePicker("Enter your birthday", selection: $date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxHeight: 400)
      }
      Spacer()

    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
