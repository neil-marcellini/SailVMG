//
//  URLImageView.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/24/21.
//

import SwiftUI

struct URLImageView: View {
    var image: UIImage?
    
    var body: some View {
        Image(uiImage: image ?? URLImageView.defaultImage!)
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 300)
    }
    
    static var defaultImage = UIImage(named: "Preview")
}

struct URLImageView_Previews: PreviewProvider {
    static var previews: some View {
        URLImageView(image: nil)
    }
}
