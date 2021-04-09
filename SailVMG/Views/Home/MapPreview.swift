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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var body: some View {
        if let light_preview = trackVM.light_preview,
           let dark_preview = trackVM.dark_preview {
            Image(uiImage: colorScheme == .light ? light_preview : dark_preview)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
        } else {
            // download the image
            if let light_url = trackVM.track.light_preview_url,
               let dark_url = trackVM.track.dark_preview_url {
                URLImage(url: colorScheme == .light ? light_url : dark_url) { image in
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
