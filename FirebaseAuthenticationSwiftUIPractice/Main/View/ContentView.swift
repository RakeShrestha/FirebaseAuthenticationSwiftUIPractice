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
                WorkoutVideoPlayerView(videoURL: "https://res.cloudinary.com/du7pn6pke/video/upload/v1738063486/nepal%20excaliber/Anime_vid_template6-VEED_pbsnnc.mp4")
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
