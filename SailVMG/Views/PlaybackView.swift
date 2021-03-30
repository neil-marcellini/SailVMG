//
//  ContentView.swift
//  MapExperiments
//
//  Created by Neil Marcellini on 11/6/20.
//

import SwiftUI
import MapKit
import CoreGPX



class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MKMapView

    init(_ parent: MKMapView) {
        self.parent = parent
    }
}

struct PlaybackView: View {
    @EnvironmentObject var mapVM: MapViewModel
    var body: some View {
        VStack {
            ZStack {
                MapView().onAppear() {
                    mapVM.addTrack()
                }
                HStack {
                    Spacer()
                    ColorScale()
                }
            }
            VMGChartView()
            
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: ShareButton())
            
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        return PlaybackView()
    }
}
