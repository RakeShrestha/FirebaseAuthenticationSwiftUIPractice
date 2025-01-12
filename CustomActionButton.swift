//
//  CustomActionButton.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 12/01/2025.
//

import SwiftUI

struct ActionButton: View {
    let label: String
    let icon: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .foregroundStyle(Color.white)
                    .padding(.vertical)
                
                Image(icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 4)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Capsule().fill(Color.init(hex: "F97316")))
        }
        .padding(.vertical, 12)
    }
}
