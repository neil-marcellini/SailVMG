//
//  NoTracksView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/11/21.
//

import SwiftUI

struct NoTracksView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image("map-colored")
                    .resizable()
                    .scaledToFit()
                Spacer()
            }
            Text("No recorded tracks.")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)
            Text("When you're ready, press the play button to start recording a track.")
        }.padding()
        
    }
}

struct NoTracksView_Previews: PreviewProvider {
    static var previews: some View {
        NoTracksView()
    }
}
