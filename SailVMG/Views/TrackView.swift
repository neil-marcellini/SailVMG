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
        if trackVM.loading || mapVM.loading {
            ProgressView()
        } else {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(trackVM.getDate())
                        Text(trackVM.location)
                    }.font(.headline)
                    HStack {
                        Image(systemName: "clock")
                        Text(trackVM.getDuration())
                    }
                    Text(trackVM.maxVMG)
                    Spacer()
                }
                MapPreview()
            }
        }
        
    }
}


struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}
