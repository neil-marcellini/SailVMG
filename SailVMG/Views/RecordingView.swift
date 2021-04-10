//
//  RecordingView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import SwiftUI
import Combine

struct RecordingView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var trackRepository: TrackRespository
    @EnvironmentObject var trackpointRepository: TrackpointRespository
    @EnvironmentObject var nav: NavigationControl
    @EnvironmentObject var audioSettings: AudioSettings
    @StateObject var mapVM = MapViewModel()
    var body: some View {
        VStack {
            TWDControl()
            VStack {
                Text("TWA")
                    .font(.title)
                Text(locationViewModel.twaDisplay())
            }
            Spacer()
            Image(systemName: "location.north.fill")
                .font(.system(size: 150))
                .foregroundColor(.blue)
                .rotationEffect(.radians(locationViewModel.boatRotation()))
            Spacer()
            VStack {
                Text("VMG")
                    .font(.title)
                    .foregroundColor(.blue)
                Text(locationViewModel.vmgDisplay())
            }.padding()
            
            HStack {
                Spacer()
                VStack {
                    Text("SOG")
                        .font(.title)
                        .foregroundColor(.red)
                    Text(locationViewModel.speedDisplay())
                }
                Spacer()
                VStack {
                    Text("COG")
                        .font(.title)
                        .foregroundColor(.red)
                    Text(locationViewModel.courseDisplay())
                }
                Spacer()
            }
            Spacer()
            Button(action: {
                locationViewModel.pause()
                audioSettings.soundControl.stop()
            }){
                Image(systemName: locationViewModel.isPaused ? "play.circle" : "pause.circle").font(.system(size: 100))
            }.actionSheet(isPresented: $locationViewModel.isPaused, content: {
                ActionSheet(title: Text("Tracking Paused"), message: nil, buttons: [
                    .default(Text("Save Track")){
                        let end_time = trackpointRepository.getEndTime(track: locationViewModel.track!)
                        locationViewModel.track!.end_time = end_time
                        trackRepository.updateTrack(newTrack: locationViewModel.track!)
                        if let trackpoints = trackpointRepository.trackpoints[locationViewModel.track!.id] {
                            trackRepository.addTrackVM(track: locationViewModel.track!, trackpoints: trackpoints)
                        } else { print("Error, no trackpoints when saving")}
                        trackpointRepository.trackpointUpdates?.cancel()
                        nav.selection = nil
                    },
                    .destructive(Text("Discard Track")){
                        // remove from trackpointRepository
                        trackpointRepository.trackpoints[locationViewModel.track!.id] = nil
                        trackRepository.discardTrack(locationViewModel.track!)
                        trackpointRepository.trackpointUpdates?.cancel()
                        locationViewModel.track = nil
                        nav.selection = nil
                    },
                    .cancel(Text("Resume Tracking")){
                        locationViewModel.resume()
                        if audioSettings.audioFeedback {
                            audioSettings.startSound()
                        }  
                    }
                    
                ])
            })
            NavigationLink(destination: SettingsView(), isActive: $audioSettings.showSettings) { EmptyView() }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {audioSettings.audioFeedback.toggle()}) {
                    Image(systemName: audioSettings.audioFeedback ? "speaker.wave.2" : "speaker.slash")
                        .font(.largeTitle)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {audioSettings.showSettings = true}) {
                    Image(systemName: "gear")
                        .font(.largeTitle)
                }
            }
        }
        .onAppear {
            locationViewModel.updateHook = audioSettings.trackpointUpdated
            if audioSettings.audioFeedback {
                audioSettings.startSound()
            }
            trackpointRepository.trackpointUpdates = locationViewModel.$trackpoint.sink { newTrackpoint in
                guard let track = locationViewModel.track else {return}
                guard let trackpoint = newTrackpoint else {return}
                print("newTrackpoint = \(trackpoint)")
                self.trackpointRepository.addTrackpoint(to: track, trackpoint: trackpoint)
            }
    }
}
}
struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}
