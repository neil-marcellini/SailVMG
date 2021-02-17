//
//  TrackView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/27/20.
//

import SwiftUI

struct TrackView: View {
    @ObservedObject var trackVM: TrackViewModel
    @ObservedObject var mapVM: MapViewModel
    
    var body: some View {
        if trackVM.loading || mapVM.loading {
            ProgressView()
        } else {
            VStack(alignment: .leading) {
                MapPreview(previewVM: mapVM)
                HStack {
                    Text(trackVM.getDate())
                    Text(trackVM.location)
                }
                HStack {
                    Text("Start: \(trackVM.startTime())")
                    Text("End: \(trackVM.endTime())")
                }
                Text(trackVM.maxVMG)
                
            }
        }
        
    }
}


struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        let trackVM = TrackViewModel(Track(id: nil, start_time: Date(), end_time: nil))
        TrackView(trackVM: trackVM, mapVM: MapViewModel(trackVM: trackVM))
    }
}
