//
//  MainScreen.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/13/20.
//

import SwiftUI
import CoreData

struct MainScreen: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @ObservedObject var trackRepository = TrackRespository()
    var body: some View {
        NavigationView {
            VStack {
                Text("Tracks").underline()
                List {
                    ForEach(trackRepository.trackVMs, id: \.track.id) { trackVM in
                        NavigationLink(destination: PlaybackView(track: trackVM.track)){
                            TrackView(trackVM: trackVM)
                        }
                        
                    }.onDelete { offset in
                        offset.forEach { index in
                            let trackVM = trackRepository.trackVMs[index]
                            trackRepository.discardTrack(trackVM.track)
                        }
                    }
                }.listStyle(PlainListStyle())
                Button(action: {
                    locationViewModel.startRecording()
                }){
                    Image(systemName: "play.circle").font(.system(size: 100))
                }
                NavigationLink(destination: RecordingView(), isActive: $locationViewModel.isRecording) { EmptyView()}
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
