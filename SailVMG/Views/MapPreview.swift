//
//  MapPreview.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/25/21.
//

import SwiftUI
import URLImage

struct MapPreview: View {
    @EnvironmentObject var trackVM: TrackViewModel
    var body: some View {
        if let preview = trackVM.trackPreview {
            Image(uiImage: preview)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
        } else {
            // download the image
            if let url = trackVM.track.preview_url {
                URLImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
        }
    }
}

struct MapPreview_Previews: PreviewProvider {
    static var previews: some View {
        MapPreview()
    }
}
