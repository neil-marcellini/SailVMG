//
//  MapPreview.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/9/21.
//

import SwiftUI

struct MapPreview: View {
    @ObservedObject var previewVM: MapViewModel
    var body: some View {
        if let preview = previewVM.preview {
            Image(uiImage: preview)
        }
        
    }
}

struct MapPreview_Previews: PreviewProvider {
    static var previews: some View {
        MapPreview(previewVM: MapViewModel(trackVM: TrackViewModel(Track(id: nil, start_time: Date(), end_time: nil, userId: nil))))
    }
}
