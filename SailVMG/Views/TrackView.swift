//
//  TrackView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/27/20.
//

import SwiftUI

struct TrackView: View {
    @ObservedObject var trackVM: TrackViewModel
    var body: some View {
        VStack(alignment: .leading) {
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


struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(trackVM: TrackViewModel(Track(id: nil, start_time: Date(), end_time: nil)))
    }
}
