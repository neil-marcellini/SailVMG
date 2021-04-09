//
//  ShareButton.swift
//  SailVMG
//
//  Created by Neil Marcellini on 3/30/21.
//

import SwiftUI

struct ShareButton: View {
    @EnvironmentObject var trackVM: TrackViewModel
    let gpx_export = GPXExporter()
    var body: some View {
        Button(action: {
            let gpx_data = gpx_export.getGPXFile(trackVM: trackVM)
            let items = [gpx_data]
            let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(ac, animated: true, completion: nil)
        }, label: {Image(systemName: "square.and.arrow.up")})
    }
}

struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
        ShareButton()
    }
}
