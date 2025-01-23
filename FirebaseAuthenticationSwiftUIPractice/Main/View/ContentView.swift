//
//  ContentView.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 11/01/2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.userSession == nil {
                LoginView()
            }
            else {
                HomeScreen()
            }
        }
        .environmentObject(authViewModel)
    }
}

#Preview {
    ContentView()
}
