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
    @EnvironmentObject var trackVM: TrackViewModel
    @EnvironmentObject var trackpointRepo: TrackpointRespository
    var body: some View {
        if trackpointRepo.trackpoints[trackVM.track.id] != nil {
            VStack {
                ZStack {
                    MapView()
                    HStack {
                        Spacer()
                        ColorScale()
                    }
                }
                VMGChartView()
                
            }.navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: ShareButton())
            .onAppear() {
                trackVM.trackpoints = trackpointRepo.trackpoints[trackVM.track.id]
                mapVM.addTrack(trackpoints: trackpointRepo.trackpoints[trackVM.track.id]!)
            }
            .environmentObject(mapVM)
        } else {
            MapLoadingView()
        }
        
            
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        return PlaybackView()
    }
}
