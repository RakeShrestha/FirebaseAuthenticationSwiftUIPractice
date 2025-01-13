//
//  AccountSettingsView.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 13/01/2025.
//

import SwiftUI

struct AccountSettingsView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Spacer()
            if let currentUser = authViewModel.currentUser {
                Text(currentUser.email)
            }
            else {
                ProgressView("Please Wait....")
            }
            Spacer()
            Button("Logout") {
                authViewModel.signOut()
            }
        }
    }
}

#Preview {
    AccountSettingsView()
}
