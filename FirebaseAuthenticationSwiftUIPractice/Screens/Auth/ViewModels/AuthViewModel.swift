//
//  AuthViewModel.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 13/01/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isError: Bool = false
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    init() {
        Task {
            await loadCurrentUser()
        }
    }
    
    func createUserAccount(email: String, password: String) async {
        do {
            let authResult = try await auth.createUser(withEmail: email, password: password) // creating user entry in auth
            await storeUserInFirestore(uid: authResult.user.uid, email: email) // storing extra user details in database
        } catch {
            isError = true
        }
    }
    
    func storeUserInFirestore(uid: String, email: String) async {
        
        let user = User(uid: uid, email: email)
        
        do {
            try firestore.collection("users").document(uid).setData(from: user)
        } catch {
            isError = true
        }
    }
    
    func login(email: String, password: String) async {
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            userSession = authResult.user
            await fetchUserData(by: authResult.user.uid)
        } catch {
            isError = true
        }
    }
    
    func fetchUserData(by uid: String) async {
        do {
            let document = try await firestore.collection("users").document(uid).getDocument()
            currentUser = try document.data(as: User.self)
            print(currentUser)
        } catch {
            isError = true
        }
    }
    
    func loadCurrentUser() async {
        if let user = auth.currentUser {
            userSession = user
            await fetchUserData(by: user.uid)
        }
    }
    
    func signOut() {
        do {
            userSession = nil
            currentUser = nil
            try auth.signOut()
        } catch {
            isError = true
        }
    }
    
}
