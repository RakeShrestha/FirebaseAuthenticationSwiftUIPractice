//
//  OnboardingModel.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 16/01/2025.
//

import Foundation
import SwiftUI

struct OnboardingContent: Identifiable {
    var id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
    let description: String
}

