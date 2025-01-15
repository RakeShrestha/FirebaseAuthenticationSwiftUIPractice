//
//  OnboardingScreen1.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 15/01/2025.
//

import SwiftUI

struct OnboardingScreen1: View {
    var body: some View {
        ZStack {
            Image("onboarding1")
                .resizable()
                .scaledToFill()
            VStack(spacing: 24) {
                
                Spacer()
                
                Image("appLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                VStack {
                    Text("Welcome To")
                    Text(" Fitness App!")
                }
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                
                Text("Look Good, Feel Good!")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 32)
                
                
                ActionButton(label: "Get Started", icon: "arrowRight") {
                    
                }
                .frame(width: 200, height: 64)
                .padding(.bottom, 70)
            }
            .padding()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingScreen1()
}
