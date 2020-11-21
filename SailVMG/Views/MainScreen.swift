//
//  MainScreen.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/13/20.
//

import SwiftUI
import CoreData

struct MainScreen: View {
    @StateObject var recordingState = RecordingState()
    var body: some View {
        NavigationView {
            VStack {
                Text("Tracks").underline()
                Spacer()
                Button(action: {recordingState.isRecording.toggle()}){
                    Image(systemName: "play.circle").font(.system(size: 100))
                }
                NavigationLink(destination: RecordingView(recordingState: recordingState), isActive: $recordingState.isRecording) { EmptyView()}
            }.navigationBarTitle("SailVMG")
        }
            
        }
    }


struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .previewDevice("iPhone 11")
    }
}
