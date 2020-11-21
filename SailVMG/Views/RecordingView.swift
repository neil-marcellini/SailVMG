//
//  RecordingView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/20/20.
//

import SwiftUI

struct RecordingView: View {
    @StateObject var recordingState: RecordingState
    var body: some View {
//        NavigationView {
            VStack {
                Text("Sog")
                Text("Cog")
                Button(action: {recordingState.isPaused = true}){
                    Image(systemName: recordingState.isPaused ? "play.circle" : "pause.circle").font(.system(size: 100))
                }.actionSheet(isPresented: $recordingState.isPaused, content: {
                    ActionSheet(title: Text("Tracking Paused"), message: nil, buttons: [
                        .default(Text("Save Track")){recordingState.isRecording.toggle()},
                        .destructive(Text("Discard Track")){},
                        .cancel(Text("Resume Tracking")){recordingState.isPaused = false}
                        
                        ])
                })
            }.navigationBarTitle("SailVMG")
            .navigationBarBackButtonHidden(true)
//        }
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(recordingState: RecordingState())
    }
}
