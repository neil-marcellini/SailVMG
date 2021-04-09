//
//  VMGChartView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/25/21.
//

import SwiftUI
import SwiftUICharts

struct VMGChartView: View {
    @EnvironmentObject var trackVM: TrackViewModel
    var body: some View {
        LineView(data: trackVM.getVMGs(), title: "VMG kts")
            .padding(.horizontal)
    }
}

struct VMGChartView_Previews: PreviewProvider {
    static var previews: some View {
        VMGChartView()
    }
}
