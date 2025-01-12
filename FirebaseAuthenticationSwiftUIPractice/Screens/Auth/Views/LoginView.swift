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
                
                signInImage
                
                textFieldView
                
                signInButton
                
                dividerView
                
                appleSignInButton
                
                googleSignInButton
                
                signUpButtonWithText
                
                forgotPasswordButton
                
            }
            .padding(.horizontal)
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
    
    private var signInImage: some View {
        CustomLoginSignUpImage(title: "Sign In to Fitness App", subtitle: "Let’s personalize your fitness with AI", customImage: "loginImage")
    }
    
    private var textFieldView: some View {
        VStack {
            // Email Field
            TextFieldWithIcon(title: "Email Address", icon: "email", placeholder: "Enter your email", text: $email, isFocused: _isEmailFocused)
            
            // Password Field
            PasswordFieldWithIcon(title: "Password", placeholder: "Password", password: $password, isFocused: _isPasswordFocused, isPasswordVisible: $isPasswordVisible)
        }
    }
    
    private var signInButton: some View {
        // Sign In Button
        ActionButton(label: "Login", icon: "arrowRight") {
            // Handle login action here
        }
    }
    
    private var dividerView: some View {
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
    }
    
    private var appleSignInButton: some View {
        Button(action: {
            // Handle Apple sign-in
        }) {
        }
        .buttonStyle(SignInButtonStyle(image: Image(systemName: "apple.logo"), title: "Sign in with Apple"))
    }
    
    private var googleSignInButton: some View {
        Button(action: {
            // Handle Google sign-in
        }) {
        }
        .buttonStyle(SignInButtonStyle(image: Image("google"), title: "Sign in with Google"))
    }
    
    private var signUpButtonWithText: some View {
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
    }
    
    private var forgotPasswordButton: some View {
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
    
}

#Preview {
    LoginView()
}
