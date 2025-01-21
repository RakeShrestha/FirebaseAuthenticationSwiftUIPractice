//
//  OTPView.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 21/01/2025.
//

import SwiftUI

struct OTPView: View {
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Verification Code")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("We have sent the verification code to your email address")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.7))
                    HStack(alignment: .center) {
                        Spacer()
                        OTPTextField(numberOfPinFields: 4)
                        Spacer()
                    }
                    Spacer()
                    ActionButton(label: "Confirm", icon: "arrowRight") {
                        
                    }
                }
                
                HStack {
                    Text("Didn't receive code?")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                    Button {
                        
                    } label: {
                        Text("Request again")
                            .foregroundStyle(Color.init(hex: "F97316"))
                    }
                }
            }
            .padding(.all, 32)
        }
        .background(.black)
    }
}

#Preview {
    OTPView()
}
