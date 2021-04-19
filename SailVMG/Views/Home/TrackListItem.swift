//
//  SwiftUIView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/25/21.
//

import SwiftUI
import Combine

struct TrackListItem: View {
    @StateObject var trackVM: TrackViewModel
    @StateObject var mapVM = MapViewModel()
    @EnvironmentObject var trackpointRepo: TrackpointRespository
    @EnvironmentObject var trackRepo: TrackRespository
    var body: some View {
        ZStack {
            if trackVM.loading {
                HStack {
                    ProgressView()
                    Spacer()
                }.onAppear {
                    if let trackpoints = trackpointRepo.trackpoints[trackVM.track.id] {
                        makeTrackPreviews(trackpoints: trackpoints)
                    } else {
                        print("Waiting for trackpoints")
                        trackVM.trackpointLoadingSub = trackpointRepo.$trackpoints.sink { newTrackpoints in
                            print("trackVM track id = \(String(describing: trackVM.track.id))")
                            print("keys = \(newTrackpoints.keys)")
                            if let trackpoints = newTrackpoints[trackVM.track.id] {
                                print("New trackpoints")
                                trackVM.trackpointLoadingSub?.cancel()
                                makeTrackPreviews(trackpoints: trackpoints)
                            }
                        }
                    }
                }
            } else {
                TrackView()
                    .environmentObject(trackVM)
                NavigationLink(destination: PlaybackView()
                                .environmentObject(trackVM)
                                .environmentObject(mapVM)
                ){
                    EmptyView()
                }.buttonStyle(PlainButtonStyle())
            }
            
        }
    }
}

extension TrackListItem {
    func makeTrackPreviews(trackpoints: [Trackpoint]) {
        mapVM.getPreview(trackpoints: trackpoints, trackVM: trackVM, afterPreviews: { newTrackVM in
            self.trackVM.dark_preview = newTrackVM.dark_preview
            self.trackVM.light_preview = newTrackVM.light_preview
            self.trackVM.track.light_preview_url = newTrackVM.track.light_preview_url
            self.trackVM.track.dark_preview_url = newTrackVM.track.dark_preview_url
        })
        trackRepo.processTrackVM(trackVM: trackVM, trackpoints: trackpoints)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TrackListItem(trackVM: TrackViewModel(track: Track(id: nil, start_time: Date())))
    }
}
