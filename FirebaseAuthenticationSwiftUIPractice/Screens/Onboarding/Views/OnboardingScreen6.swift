//
//  OnboardingScreen6.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 15/01/2025.
//

import SwiftUI

struct OnboardingScreen6: View {
    var body: some View {
        ZStack {
            Image("onboarding6")
                .resizable()
                .scaledToFill()
            VStack(spacing: 24) {
                
                Spacer()
                
                VStack {
                    Text("Virtual AI Coach")
                    Text("Mentoring")
                }
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                
                Text("Say goodbye to manual coaching! 👋")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 32)
                
                HStack(spacing: 20) {
                    Button {
                    } label: {
                            Image("arrowLeft")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 4)
                    }
                    .frame(height: 96, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(Color.init(hex: "393C43")))
                    
                    Button {
                    } label: {
                            Image("arrowRight")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 4)
                    }
                    .frame(height: 96, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(Color.init(hex: "393C43")))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 90)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [Color.black.opacity(0), Color.black.opacity(0.6)], startPoint: .top, endPoint: .bottom))
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingScreen6()
}
