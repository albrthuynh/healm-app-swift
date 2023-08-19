//
//  LogOutView.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 7/23/23.
//

import SwiftUI

//SETTINGS VIEW

@MainActor
final class settingsViewModel: ObservableObject{
    
    func signOut() throws{
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws{
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else{
            throw URLError(.fileDoesNotExist)
        }
                
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws{
        let email = "123@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "hello123"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}

struct LogOutView: View {
    @StateObject private var viewModel = settingsViewModel()
    @Binding var showSignInView: Bool
    @State private var showingAlert = false
    var body: some View {
        List{
            Section{
                Button("Log Out"){
                    Task{
                        do {
                            try viewModel.signOut()
                            showSignInView = true
                            print("LOGGED OUT")
                        } catch{
                            print(error)
                        }
                    }
                }
                
                Button(action: {
                    showingAlert = true
                }) {
                    Text("Delete account")
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Delete Account"),
                        message: Text("Are you sure you want to delete your account? If you proceed go back to the main screen towards the Login screen"),
                        primaryButton: .destructive(Text("Delete")) {
                            Task {
                                do {
                                    try await viewModel.deleteAccount()
                                    showSignInView = true
                                } catch {
                                    print(error)
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .foregroundColor(.red)
                
            }
            
            Group{
                
                Button("Reset Password"){
                    Task{
                        do {
                            try await viewModel.resetPassword()
                            print("PASSWORD RESET IS RUN")
                        } catch {
                            print(error)
                        }
                    }
                }
                
                Button("Update Password"){
                    Task{
                        do {
                            try await viewModel.updatePassword()
                            print("PASSWORD UPDATE")
                        } catch {
                            print(error)
                        }
                    }
                }
                
                Button("Update email"){
                    Task{
                        do {
                            try await viewModel.updateEmail()
                            print("EMAIL UPDATED")
                        } catch {
                            print(error)
                        }
                    }
                }
                
                NavigationLink(destination: TwoFactorAuthenticationView() ) {
                    Text("Enroll 2FA")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct LogOutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            LogOutView(showSignInView: .constant(false))
        }
    }
}
