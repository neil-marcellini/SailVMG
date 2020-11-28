//
//  RecordingView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import SwiftUI

struct RecordingView: View {
    @StateObject var recordingState: RecordingState
    @ObservedObject var locationViewModel: LocationViewModel
    var body: some View {
            VStack {
                Text("SOG")
                    .font(.title)
                    .foregroundColor(.red)
                Text("\(locationViewModel.speed)")
                
                Text("COG")
                    .font(.title)
                    .foregroundColor(.red)
                Text("\(locationViewModel.course)")
                
                
                Button(action: {
                    recordingState.pause()
                }){
                    Image(systemName: recordingState.isPaused ? "play.circle" : "pause.circle").font(.system(size: 100))
                }.actionSheet(isPresented: $recordingState.isPaused, content: {
                    ActionSheet(title: Text("Tracking Paused"), message: nil, buttons: [
                        .default(Text("Save Track")){
                            recordingState.saveTrack()
                        },
                        .destructive(Text("Discard Track")){
                            recordingState.discardTrack()
                        },
                        .cancel(Text("Resume Tracking")){
                            recordingState.resume()
                        }
                        
                        ])
                })
            }.navigationBarTitle("SailVMG")
            .navigationBarBackButtonHidden(true)
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(recordingState: RecordingState(), locationViewModel: LocationViewModel())
    }
}
