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
        VStack(spacing: 0) {
            NavigationView {
                VStack {
                    HStack {
                        Text("Tracks")
                            .font(.headline)
                        Spacer()
                    }.padding(.horizontal)
                    if trackRepository.hasNoTracks() {
                        NoTracksView()
                        Spacer()
                    } else {
                        TrackList().environmentObject(trackRepository)
                    }
                    Button(action: {
                        locationViewModel.startRecording()
                    }){
                        Image(systemName: "play.circle").font(.system(size: 100))
                    }
                    NavigationLink(destination: RecordingView()
                                    .environmentObject(locationViewModel)
                                    .environmentObject(trackRepository), isActive: $locationViewModel.isRecording) { EmptyView()}
                }.navigationTitle("SailVMG")
            }
        }
       
    }
}


struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .previewDevice("iPhone 11")
    }
}
