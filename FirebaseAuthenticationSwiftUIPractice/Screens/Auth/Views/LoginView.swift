//
//  LoginView.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 11/01/2025.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                CustomLoginSignUpImage(title: "Sign In to Fitness App", subtitle: "Let’s personalize your fitness with AI", customImage: "loginImage")
                
                // Email Field
                TextFieldWithIcon(title: "Email Address", icon: "email", placeholder: "Enter your email", text: $email, isFocused: _isEmailFocused)  // Correct FocusState passing
                
                // Password Field
                PasswordFieldWithIcon(title: "Password", placeholder: "Password", password: $password, isFocused: _isPasswordFocused, isPasswordVisible: $isPasswordVisible)  // Correct FocusState passing
                
                // Sign In Button
                ActionButton(label: "Login", icon: "arrowRight") {
                    // Handle login action here
                }
                
                HStack {
                    Divider()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .background(.white.opacity(0.5))
                    
                    Text("or")
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Divider()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .background(.white.opacity(0.5))
                }
                .foregroundStyle(.white)
                
                Button(action: {
                    // Handle Apple sign-in
                }) {
                }
                .buttonStyle(SignInButtonStyle(image: Image(systemName: "apple.logo"), title: "Sign in with Apple"))
                
                Button(action: {
                    // Handle Google sign-in
                }) {
                }
                .buttonStyle(SignInButtonStyle(image: Image("google"), title: "Sign in with Google"))
                
                // Forgot Password and Sign Up Links
                HStack {
                    Text("Don't have an account?")
                        .font(.footnote)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                    
                    Button {
                        // Handle Sign Up navigation here
                    } label: {
                        Text("Sign up")
                            .font(.footnote)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color.init(hex: "F97316"))
                            .underline(color: Color.init(hex: "F97316"))
                    }
                }
                
                Button {
                    // Handle Forgot Password here
                } label: {
                    Text("Forgot Password")
                        .font(.footnote)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.init(hex: "F97316"))
                        .underline(color: Color.init(hex: "F97316"))
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal)
        }
        .background(Color.black.opacity(1))
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
}
