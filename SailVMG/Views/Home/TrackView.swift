//
//  TrackView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/27/20.
//

import SwiftUI

struct TrackView: View {
    @EnvironmentObject var trackVM: TrackViewModel
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(trackVM.getDate()) \(trackVM.startTime())")
                    .font(.headline)
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text(trackVM.locationDisplay())
                }
                HStack {
                    Image(systemName: "clock")
                    Text(trackVM.getDuration())
                }
                Text("Max VMG:")
                Text(trackVM.displayMaxVMG())
            }
            Spacer()
            VStack {
                MapPreview()
                Spacer()
            }
        }
    }
}


struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}
