//
//  CustomTextField.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 12/01/2025.
//

import SwiftUI

struct TextFieldWithIcon: View {
    let title: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            
            HStack {
                Image(icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 4)
                    TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(.white.opacity(0.5)))
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .tint(Color.white)
                        .focused($isFocused)
            }
            .padding()
            .background(Color(hex: "111214"))
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .strokeBorder(
                        isFocused ? Color.init(hex: "F97316") .opacity(0.4) : Color.clear, lineWidth: 5.5
                    )
                    .padding(-5)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isFocused)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(isFocused ? Color.init(hex: "F97316") : Color.clear, lineWidth: 2)
                    .animation(.easeInOut(duration: 0.3), value: isFocused)
            )
        }
    }
}

struct PasswordFieldWithIcon: View {
    let title: String
    let placeholder: String
    @Binding var password: String
    @FocusState var isFocused: Bool
    @Binding var isPasswordVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            
            HStack {
                Image("password")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 4)
                
                if isPasswordVisible {
                    TextField("", text: $password, prompt: Text(placeholder).foregroundStyle(.white.opacity(0.5)))
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .focused($isFocused)
                } else {
                    SecureField("", text: $password, prompt: Text(placeholder).foregroundStyle(.white.opacity(0.5)))
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .focused($isFocused)
                }
                
                Image("showPassword")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 8)
                    .onTapGesture {
                        isPasswordVisible.toggle()
                    }
            }
            .padding()
            .background(Color(hex: "111214"))
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .strokeBorder(
                        isFocused ? Color.init(hex: "F97316") .opacity(0.4) : Color.clear, lineWidth: 5.5
                    )
                    .padding(-5)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isFocused)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(isFocused ? Color.init(hex: "F97316") : Color.clear, lineWidth: 2)
                    .animation(.easeInOut(duration: 0.3), value: isFocused)
            )
        }
    }
}
