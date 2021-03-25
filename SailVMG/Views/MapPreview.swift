//
//  MapPreview.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/25/21.
//

import SwiftUI

struct MapPreview: View {
    @EnvironmentObject var mapVM: MapViewModel
    var body: some View {
        if let preview = mapVM.preview {
            Image(uiImage: preview)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
        }
    }
}

struct MapPreview_Previews: PreviewProvider {
    static var previews: some View {
        MapPreview()
    }
}
