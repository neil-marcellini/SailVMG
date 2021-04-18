//
//  ArrowTest.swift
//  SailVMG
//
//  Created by Neil Marcellini on 4/18/21.
//

import SwiftUI

struct ArrowTest: View {
    let vmg_len: CGFloat = 10 + 20
    var body: some View {
        Arrow()
            .frame(width: 10, height: vmg_len)
            .foregroundColor(.green)
            .offset(x: 0, y: -(abs(vmg_len) / 2))
    }
}

struct ArrowTest_Previews: PreviewProvider {
    static var previews: some View {
        ArrowTest()
    }
}
