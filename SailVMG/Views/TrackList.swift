//
//  TrackList.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/11/21.
//

import SwiftUI

struct TrackList: View {
    @EnvironmentObject var trackRepository: TrackRespository
    @EnvironmentObject var locationViewModel: LocationViewModel
    var body: some View {
        List {
            ForEach(trackRepository.trackVMs, id: \.track.id) { trackVM in
                TrackListItem(trackVM: trackVM, mapVM: MapViewModel(trackpoints: trackVM.trackpoints) )
            }.onDelete { offset in
                offset.forEach { index in
                    let trackVM = trackRepository.trackVMs[index]
                    locationViewModel.trackManager.discardTrack(trackVM.track)
                    trackRepository.removeTrackVM(index: index)
                }
            }
        }.listStyle(PlainListStyle())
    }
}

struct TrackList_Previews: PreviewProvider {
    static var previews: some View {
        TrackList()
    }
}
