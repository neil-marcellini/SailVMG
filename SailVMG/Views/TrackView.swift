//
//  TrackView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/27/20.
//

import SwiftUI

struct TrackView: View {
    let trackVM: TrackViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Track")
            HStack {
                Text("Start time: \(trackVM.startTime())")
                Text("End time: \(trackVM.endTime())")
            }
            
        }
        
    }
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(trackVM: TrackViewModel(Track(id: nil, start_time: Date(), end_time: nil)))
    }
}
