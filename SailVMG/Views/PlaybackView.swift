//
//  ContentView.swift
//  MapExperiments
//
//  Created by Neil Marcellini on 11/6/20.
//

import SwiftUI
import MapKit
import CoreGPX
import SwiftUICharts


class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MKMapView

    init(_ parent: MKMapView) {
        self.parent = parent
    }
}

struct PlaybackView: View {
    @State var route: MKPolyline?
    let trackVM: TrackViewModel
    let trackpointRepository = TrackpointRespository()
    
    var body: some View {
        VStack {
            ZStack {
                MapView(route: $route, mapViewDelegate: MapViewDelegate(trackVM)).onAppear() {
                    addTrack()
                }
                HStack {
                    Spacer()
                    ColorScale(trackVM: trackVM)
                }
            }
            
            LineView(data: trackVM.getVMGs(), title: "VMG kts")
                .padding(.horizontal)
        }
            
    }
    
}

private extension PlaybackView {
    func addTrack() {
        trackpointRepository.getCoordinates(trackVM.track) { coordinates in
            let track_line = MKPolyline(coordinates: coordinates, count: coordinates.count)
            route = track_line
        }
        
    }
}


func getCoordinates()->[CLLocationCoordinate2D] {
    var coordinates = Array<CLLocationCoordinate2D>()
    guard let fileURL = Bundle.main.url(forResource: "Crissy-8-13", withExtension: "gpx") else { return coordinates}
    guard let gpx = GPXParser(withURL: fileURL)?.parsedData() else { return coordinates }
    for track in gpx.tracks {
        for seg in track.tracksegments {
            for trackpoint in seg.trackpoints {
                let lat = trackpoint.latitude
                let lng = trackpoint.longitude
                if lat != nil && lng != nil {
                    coordinates.append(CLLocationCoordinate2D(latitude: lat!, longitude: lng!))
                }
            }
        }
    }
    return coordinates
}



    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackView(trackVM: TrackViewModel(Track(id: nil, start_time: Date(), end_time: nil)))
    }
}
