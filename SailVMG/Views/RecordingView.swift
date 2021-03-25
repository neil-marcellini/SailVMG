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
    @StateObject var recordingViewModel = RecordingViewModel()
    let labelColor = Color(UIColor.label)
    var body: some View {
        VStack {
            TWDControl()
            VStack {
                Text("TWA")
                    .font(.title)
                Text(recordingViewModel.twaDisplay(locationViewModel.twa))
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
                Text(recordingViewModel.vmgDisplay(locationViewModel.vmg))
            }.padding()
            
            HStack {
                Spacer()
                VStack {
                    Text("SOG")
                        .font(.title)
                        .foregroundColor(.red)
                    Text(recordingViewModel.speedDisplay(locationViewModel.speed))
                }
                Spacer()
                VStack {
                    Text("COG")
                        .font(.title)
                        .foregroundColor(.red)
                    Text(recordingViewModel.courseDisplay(locationViewModel.course))
                }
                Spacer()
            }
            Spacer()
            Button(action: {
                locationViewModel.pause()
            }){
                Image(systemName: locationViewModel.isPaused ? "play.circle" : "pause.circle").font(.system(size: 100))
            }.actionSheet(isPresented: $locationViewModel.isPaused, content: {
                ActionSheet(title: Text("Tracking Paused"), message: nil, buttons: [
                    .default(Text("Save Track")){
                        locationViewModel.saveTrack()
                        let end_time = Date()
                        locationViewModel.track!.end_time = end_time
                        trackRepository.addTrackVM(track: locationViewModel.track!)
                    },
                    .destructive(Text("Discard Track")){
                        locationViewModel.discardTrack()
                    },
                    .cancel(Text("Resume Tracking")){
                        locationViewModel.resume()
                    }
                    
                ])
            })
        }.navigationBarTitle("SailVMG")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: Toggle("Audio Feedback", isOn: $locationViewModel.audioFeedback))
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}
