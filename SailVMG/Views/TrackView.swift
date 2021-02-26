//
//  TrackView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/27/20.
//

import SwiftUI

struct TrackView: View {
    @EnvironmentObject var trackVM: TrackViewModel
    @EnvironmentObject var mapVM: MapViewModel
    var body: some View {
        if mapVM.loading {
            ProgressView()
        } else {
            VStack(alignment: .leading) {
                MapPreview()
//                URLImageView(image: mapVM.preview)
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
        TrackView()
    }
}
