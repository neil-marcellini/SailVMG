//
//  TrackList.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/11/21.
//

import SwiftUI

struct TrackList: View {
    @EnvironmentObject var trackRepository: TrackRespository
    @EnvironmentObject var trackpointRepo: TrackpointRespository
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    trackRepository.showDeleteConfirmation = true
                }){
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $trackRepository.showDeleteConfirmation) {
                    Alert(title: Text("Delete All Tracks"), message: Text("Are you sure you want to permanently delete all of your recorded tracks?"), primaryButton: .default(Text("Yes"), action: {
                        trackpointRepo.trackpoints = [:]
                        trackRepository.deleteAll()
                    }), secondaryButton: .cancel())
                }
                .padding()
            }
            
            List {
                ForEach(trackRepository.trackVMs, id: \.track.id) { trackVM in
                    TrackListItem(trackVM: trackVM)
                }.onDelete { offset in
                    offset.forEach { index in
                        let trackVM = trackRepository.trackVMs[index]
                        trackpointRepo.trackpoints[trackVM.track.id] = nil
                        trackRepository.discardTrack(trackVM.track)
                        trackRepository.removeTrackVM(index: index)
                    }
                }
            }.id(UUID()) // id prevents crash when deleting last item
        }
    }
}

struct TrackList_Previews: PreviewProvider {
    static var previews: some View {
        TrackList()
    }
}
