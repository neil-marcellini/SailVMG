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
    @EnvironmentObject var trackRepository: TrackRespository
    @StateObject var trackpointRepository = TrackpointRespository()
    @StateObject var nav = NavigationControl()
    @StateObject var audioSettings = AudioSettings()
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationView {
                VStack {
                    if trackRepository.hasNoTracks() {
                        NoTracksView()
                        Spacer()
                    } else {
                        TrackList()
                    }
                    Button(action: {
                        if locationViewModel.locationManager.authorizationStatus == .denied {
                            locationViewModel.promptLocation = true
                        } else {
                            nav.selection = "TWDSetup"
                        }
                        
                    }){
                        Image(systemName: "play.circle")
                            .font(.custom("BButton", size: 80, relativeTo: .body))
                    }.alert(isPresented: $locationViewModel.promptLocation) {
                        Alert(title: Text("Location is Required to Record Tracks"), message: Text("Please enable location while using the app."), primaryButton: .default(Text("Settings"), action: {
                            locationViewModel.promptLocation = false
                            // open the app permission in Settings app
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                            
                        }), secondaryButton: .cancel())
                    }
                    NavigationLink(destination: TWDSetup(isReset: false),
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
            .environmentObject(trackpointRepository)
            .environmentObject(audioSettings)
        }
        .onAppear {
            trackRepository.afterTracks = trackpointRepository.getAllTrackpoints
        }  
    }
}


struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .previewDevice("iPhone 11")
    }
}
