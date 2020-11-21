//
//  ContentView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/13/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Tracks").underline()
                Spacer()
                Button(action: {}){
                    Image(systemName: "play.circle").font(.system(size: 100))
                }
                }.navigationBarTitle("SailVMG")
            }
            
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
