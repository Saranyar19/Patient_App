//
//  ContentView.swift
//  Test_1
//
//  Created by Arun Skyraan on 30/08/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            HomeView()
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
