//
//  SignupView.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 12/01/2025.
//

import SwiftUI

struct SignupView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @FocusState private var isFirstNameFocused: Bool
    @FocusState private var isLastNameFocused: Bool
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isConfirmPasswordFocused: Bool
    
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    
    @State private var didPasswordMatch: Bool = true
    @State private var navigateToForgotPassword: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    
                    signUpImageView
                    
                    textFields
                    
                    signUpButton
                    
                    signInButtonWithText
                    
                    
                }
                .padding(.horizontal)
            }
            .background(Color.black)
            .ignoresSafeArea()
            .navigationDestination(isPresented: $navigateToForgotPassword) {
                OTPView(email: email, password: password)
            }
        }
    }
    
    private var signUpImageView: some View {
        CustomLoginSignUpImage(title: "Sign Up For Free", subtitle: "Get Started", customImage: "loginImage")
    }
    
    private var textFields: some View {
        VStack {
            // User Name
            HStack(spacing: 24) {
                TextFieldWithIcon(title: "Your Name", icon: nil, placeholder: "First name", text: $firstName, isFocused: _isFirstNameFocused)
                TextFieldWithIcon(title: "", icon: nil, placeholder: "Last name", text: $lastName, isFocused: _isLastNameFocused)
            }
            
            // Email Field
            TextFieldWithIcon(title: "Email Address", icon: "email", placeholder: "Enter your email", text: $email, isFocused: _isEmailFocused)
            
            // Password Field
            PasswordFieldWithIcon(title: "Password", placeholder: "Password", password: $password, isFocused: _isPasswordFocused, isPasswordVisible: $isPasswordVisible)
            
            // Confirm Password Field
            PasswordFieldWithIcon(title: "Confirm Password", placeholder: "Confirm Password", password: $confirmPassword, isFocused: _isConfirmPasswordFocused, isPasswordVisible: $isConfirmPasswordVisible)
            
            // Password Match Error
            if !didPasswordMatch {
                ErrorMessage(message: "ERROR: Password does not match")
            }
        }
    }
    
    private var signUpButton: some View {
        // Sign Up Button
        ActionButton(label: "Sign Up", icon: "arrowRight") {
            if (!password.isEmpty && !confirmPassword.isEmpty) && (password != confirmPassword) {
                withAnimation {
                    didPasswordMatch = false
                }
            } else {
                // Handle sign-up action
                navigateToForgotPassword = true
            }
        }
    }
    
    private var signInButtonWithText: some View {
        HStack {
            Text("Already have an account?")
                .font(.footnote)
                .fontWeight(.heavy)
                .foregroundStyle(.white)
            
            Button {
                // Handle Sign In navigation here
                dismiss()
            } label: {
                Text("Sign In")
                    .font(.footnote)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.init(hex: "F97316"))
                    .underline(color: Color.init(hex: "F97316"))
            }
        }
        .padding(.bottom, 24)
    }
    
}

#Preview {
    SignupView()
}
