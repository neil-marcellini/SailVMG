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
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(trackVM.getDate()) \(trackVM.startTime())")
                        .font(.headline)
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(trackVM.location)
                    }
                    HStack {
                        Image(systemName: "clock")
                        Text(trackVM.getDuration())
                    }
                    Text("Max VMG:")
                    Text(trackVM.maxVMG)
                    Spacer()
                }
                Spacer()
                VStack {
                    MapPreview()
                    Spacer()
                }
            }
        }
        
    }
}


struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}
