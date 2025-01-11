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
                ZStack {
                    Image("loginImage")
                        .resizable()
                        .scaledToFit()
                        .overlay(
                            VStack {
                                Spacer()
                                Text("Sign In to Fitness App")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(.bottom, 4)
                                
                                Text("Let’s personalize your fitness with AI")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                            }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.bottom, 40)
                                .background(RadialGradient(colors: [Color.black.opacity(0.06), Color.black.opacity(0.7)], center: .bottom, startRadius: 300, endRadius: 50))
                        )
                }
                
                // text field
                VStack(alignment: .leading) {
                    Text("Email Address")
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    HStack {
                        Image("email")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 4)
                        
                        TextField("", text: $email, prompt: Text("Enter your email").foregroundStyle(.white.opacity(0.5)))
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .tint(Color.white)
                            .focused($isEmailFocused)
                    }
                    .padding()
                    .background(Color(hex: "111214"))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .strokeBorder(
                                isEmailFocused ? Color.init(hex: "F97316") .opacity(0.4) : Color.clear, lineWidth: 5.5
                            )
                            .padding(-5)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isEmailFocused)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(isEmailFocused ? Color.init(hex: "F97316") : Color.clear, lineWidth: 2)
                            .animation(.easeInOut(duration: 0.3), value: isEmailFocused)
                    )
                    
                    Text("Password")
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.top, 4)
                    
                    HStack {
                        Image("password")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 4)
                        
                        if isPasswordVisible {
                            TextField("", text: $password, prompt: Text("Password").foregroundStyle(.white.opacity(0.5)))
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .focused($isPasswordFocused)
                        }
                        
                        else {
                            SecureField("", text: $password, prompt: Text("Password").foregroundStyle(.white.opacity(0.5)))
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .focused($isPasswordFocused)
                        }
                        
                        
                        Image("showPassword")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 8)
                            .onTapGesture{
                                isPasswordVisible.toggle()
                            }
                    }
                    .padding()
                    .background(Color(hex: "111214"))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .strokeBorder(
                                isPasswordFocused ? Color.init(hex: "F97316") .opacity(0.4) : Color.clear, lineWidth: 5.5
                            )
                            .padding(-5)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isPasswordFocused)
                        
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(isPasswordFocused ? Color.init(hex: "F97316") : Color.clear, lineWidth: 2)
                            .animation(.easeInOut(duration: 0.3), value: isPasswordFocused)
                    )
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Text("Login")
                                .foregroundStyle(Color.white)
                                .padding()
                            
                            Image("arrowRight")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 4)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Capsule().fill(Color.init(hex: "F97316")))
                    }
                    .padding(.vertical, 12)
                    
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
                    
                    Button {
                        
                    } label: {
                        Label("Sign in with Apple", systemImage: "apple.logo")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.init(hex: "F97316"), lineWidth: 2)
                    )
                    .padding(.vertical, 12)
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image("google")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 4)
                            Text("Sign in with Google")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.init(hex: "F97316"), lineWidth: 2)
                    )
                    .padding(.vertical, 12)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Don't have an account?")
                        .font(.footnote)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                    
                    Button {
                        
                    } label: {
                        Text("Sign up")
                            .font(.footnote)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color.init(hex: "F97316"))
                            .underline(color: Color.init(hex: "F97316"))
                    }
                }
                
                Button {
                    
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
        .background(Color.black.opacity(1))
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
}
