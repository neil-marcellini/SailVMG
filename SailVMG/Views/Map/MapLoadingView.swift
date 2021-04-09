//
//  MapLoadingView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 4/9/21.
//

import SwiftUI

struct MapLoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Loading Track Map")
        }
    }
}

struct MapLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        MapLoadingView()
    }
}
