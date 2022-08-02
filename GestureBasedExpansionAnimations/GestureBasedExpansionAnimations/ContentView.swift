//
//  ContentView.swift
//  GestureBasedExpansionAnimations
//
//  Created by Hugo L on 2022/8/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Home()
                .navigationTitle("Toolbar Animation")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
