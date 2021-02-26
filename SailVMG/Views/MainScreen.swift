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
    @StateObject var trackRepository = TrackRespository()
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Tracks")
                        .font(.headline)
                    Spacer()
                }.padding(.horizontal)
                List {
                    ForEach(trackRepository.trackVMs, id: \.track.id) { trackVM in
                        TrackListItem(trackVM: trackVM, mapVM: MapViewModel(trackpoints: trackVM.trackpoints) )
                    }.onDelete { offset in
                        offset.forEach { index in
                            let trackVM = trackRepository.trackVMs[index]
                            locationViewModel.trackManager.discardTrack(trackVM.track)
                            trackRepository.trackVMs.remove(at: index)
                        }
                    }
                }.listStyle(PlainListStyle())
                Button(action: {
                    locationViewModel.startRecording()
                }){
                    Image(systemName: "play.circle").font(.system(size: 100))
                }
                NavigationLink(destination: RecordingView(), isActive: $locationViewModel.isRecording) { EmptyView()}
            }.navigationTitle("SailVMG")
        }
            
        }
    }


struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .previewDevice("iPhone 11")
    }
}
