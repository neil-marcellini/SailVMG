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
        VStack(spacing: 10) {
            HStack {
                VStack {
                    Text("TWA")
                    Text(locationViewModel.twaDisplay())
                        .font(.title)
                }
                .foregroundColor(.gray)
                Spacer()
                VStack {
                    Text("SOG")
                    Text(locationViewModel.speedDisplay())
                        .font(.title)
                }
                .foregroundColor(.blue)
                Spacer()
                VStack {
                    Text("TWD")
                    Text(locationViewModel.twdDisplay())
                        .font(.title)
                }
                .foregroundColor(.red)
            }
            VStack {
                Text("COG")
                Text(locationViewModel.courseDisplay())
                    .font(.title)
            }.foregroundColor(.blue)
            Spacer()
            GeometryReader { geo in
                VStack {
                    RecordingCompass(size: min(geo.size.width / 2, geo.size.height / 2))
                }.frame(width: geo.size.width,
                        height: geo.size.height,
                        alignment: .center)
            }.padding(40)
            Spacer()
            VStack {
                Text("VMG")
                Text(locationViewModel.vmgDisplay())
                    .font(.title)
            }
            .foregroundColor(.green)
            Button(action: {
                locationViewModel.pause()
                audioSettings.soundControl.stop()
            }){
                Image(systemName: locationViewModel.isPaused ? "play.circle" : "pause.circle").font(.custom("BButton", size: 80, relativeTo: .body))
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
            NavigationLink(destination: TWDSetup(isReset: true), isActive: $nav.showTWDReset) { EmptyView() }
        }
        .padding(.horizontal)
        .padding(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {audioSettings.audioFeedback.toggle()}) {
                    Image(systemName: audioSettings.audioFeedback ? "speaker.wave.2" : "speaker.slash")
                        .font(.largeTitle)
                }
            }
            ToolbarItem(placement: .principal) {
                Button(action: {
                    nav.showTWDReset = true
                }){
                    Text("Reset TWD")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(5)
                }.background(RoundedRectangle(cornerRadius: 8).fill(Color(.red)))
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
