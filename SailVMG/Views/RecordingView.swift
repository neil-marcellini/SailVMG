//
//  RecordingView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import SwiftUI

struct RecordingView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @ObservedObject var trackRepository: TrackRespository
    @StateObject var recordingViewModel = RecordingViewModel()
    @State private var audioFeedback = UserDefaults.standard.bool(forKey: "audioFeedback")
    var body: some View {
            VStack {
             
                Text("TWD")
                    .font(.title)
                    .foregroundColor(.black)
                HStack {
                    Button(action: { locationViewModel.minusTwd() }){
                        Image(systemName: "minus.square.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                    Text(recordingViewModel.twdDisplay(locationViewModel.twd))
                        .frame(width: 50)
                    Button(action: { locationViewModel.plusTwd() }){
                        Image(systemName: "plus.app.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                }
             
                Slider(value: $locationViewModel.twd, in: 0...359, step: 1)
                    .frame(width: 150)
                
                Image(systemName: "arrow.down")
                    .font(.system(size: 80))
                    .foregroundColor(.black)
                
                ZStack {
                    Image(systemName: "location.north.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.blue)
                        .rotationEffect(.radians(locationViewModel.boatRotation()))
                    Circle()
                        .strokeBorder(Color.black, lineWidth: 2)
                        
                }
                
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
                        Text("TWA")
                            .font(.title)
                        Text(recordingViewModel.twaDisplay(locationViewModel.twa))
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
                
               
                
                
                Button(action: {
                    locationViewModel.pause()
                }){
                    Image(systemName: locationViewModel.isPaused ? "play.circle" : "pause.circle").font(.system(size: 100))
                }.actionSheet(isPresented: $locationViewModel.isPaused, content: {
                    ActionSheet(title: Text("Tracking Paused"), message: nil, buttons: [
                        .default(Text("Save Track")){
                            locationViewModel.saveTrack()
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
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(trackRepository: TrackRespository())
    }
}
