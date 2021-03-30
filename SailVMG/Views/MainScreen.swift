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
    @StateObject var nav = NavigationControl()
    var body: some View {
        VStack(spacing: 0) {
            NavigationView {
                VStack {
                    if trackRepository.hasNoTracks() {
                        NoTracksView()
                        Spacer()
                    } else {
                        TrackList().environmentObject(trackRepository)
                    }
                    Button(action: {
                        nav.selection = "TWDSetup"
                    }){
                        Image(systemName: "play.circle").font(.system(size: 100))
                    }
                    NavigationLink(destination: TWDSetup(),
                                   tag: "TWDSetup",
                                   selection: $nav.selection){
                        EmptyView()
                    }
                    NavigationLink(destination: RecordingView(),
                                   tag: "RecordingView",
                                   selection: $nav.selection) { EmptyView()}
                    
                }.navigationTitle("SailVMG")
            }
            .environmentObject(nav)
            .environmentObject(locationViewModel)
            .environmentObject(trackRepository)
        }
       
    }
}


struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .previewDevice("iPhone 11")
    }
}
