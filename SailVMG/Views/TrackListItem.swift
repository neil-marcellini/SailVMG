//
//  SwiftUIView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/25/21.
//

import SwiftUI

struct TrackListItem: View {
    @StateObject var trackVM: TrackViewModel
    @StateObject var mapVM: MapViewModel
    var body: some View {
        VStack {
            NavigationLink(destination: PlaybackView().environmentObject(trackVM)
                            .environmentObject(mapVM)){
                TrackView().environmentObject(trackVM)
                    .environmentObject(mapVM)
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TrackListItem(trackVM: TrackViewModel(Track(id: nil, start_time: Date(), end_time: nil, userId: nil, preview_url: nil)), mapVM: MapViewModel(trackpoints: []))
    }
}
