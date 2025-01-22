//
//  OTPView.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 21/01/2025.
//

import SwiftUI

struct OTPView: View {
    let receivedOTP = "1234"
    @State private var enteredOTP: String = ""
    
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
                        OTPTextField(numberOfPinFields: 4, enteredOTP: $enteredOTP)
                        Spacer()
                    }
                    Spacer()
                    
                    Button {
                            if verifyOTP() {
                                // OTP matches
                                print("OTP Verified Successfully!")
                            } else {
                                // OTP does not match
                                print("Incorrect OTP")
                            }
                    } label: {
                        HStack {
                            Text("Confirm")
                                .foregroundStyle(Color.white)
                                .padding(.vertical)
                            
                            Image("arrowRight")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 4)
                        }
                    }
                        
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(enteredOTP.count == 4 ? Capsule().fill(Color.init(hex: "F97316")) : Capsule().fill(Color.gray.opacity(0.2)))
                    .padding(.vertical, 12)
                    .disabled(enteredOTP.count != 4)
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
    
    func verifyOTP() -> Bool {
        return enteredOTP == receivedOTP
    }
    
}

#Preview {
    OTPView()
}
