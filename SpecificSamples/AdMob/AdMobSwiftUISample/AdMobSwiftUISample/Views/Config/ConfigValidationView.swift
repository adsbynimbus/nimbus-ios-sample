//
//  ConfigValidationView.swift
//  AdMobSwiftUISample
//  Created on 9/19/24
//  Copyright © 2024 Nimbus Advertising Solutions Inc. All rights reserved.
//

import SwiftUI

struct ConfigValidationView: View {
    let viewModel = ConfigViewModel()
    
    var body: some View {
        ForEach(viewModel.items) { item in
            HStack {
                if item.isValid {
                    Image(systemName: "checkmark").foregroundColor(.green)
                } else {
                    Image(systemName: "xmark").foregroundColor(.red)
                }
                
                Text(item.name)
                Spacer()
            }
        }
    }
}

#Preview {
    ConfigValidationView()
}
