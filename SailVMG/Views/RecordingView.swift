//
//  RecordingView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import SwiftUI

struct RecordingView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var trackRepository: TrackRespository
    @EnvironmentObject var nav: NavigationControl
    @StateObject var audioSettings = AudioSettings()
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
                        let end_time = Date()
                        locationViewModel.track!.end_time = end_time
                        trackRepository.addTrackVM(track: locationViewModel.track!)
                        nav.selection = nil
                    },
                    .destructive(Text("Discard Track")){
                        locationViewModel.discardTrack()
                        nav.selection = nil
                    },
                    .cancel(Text("Resume Tracking")){
                        locationViewModel.resume()
                        audioSettings.startSound()
                    }
                    
                ])
            })
            NavigationLink(destination: SettingsView(), isActive: $audioSettings.showSettings) { EmptyView() }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Toggle("Audio Feedback", isOn: $audioSettings.audioFeedback)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {audioSettings.showSettings = true}) {
                    Image(systemName: "gear")
                        .font(.title)
                }
            }
        }
        .onAppear {
            locationViewModel.updateHook = audioSettings.trackpointUpdated
            if audioSettings.audioFeedback {
                audioSettings.startSound()
            }
        }
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}
