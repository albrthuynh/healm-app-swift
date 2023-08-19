//
//  2FA View.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 7/28/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseMessaging

struct TwoFactorAuthenticationView: View {
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var isCodeSent: Bool = false
    @State private var verificationId: String? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Phone Number", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: sendVerificationCode) {
                Text(isCodeSent ? "Resend Verification Code" : "Send Verification Code")
                    .padding()
                    .foregroundColor(.white)
                    .background(isCodeSent ? Color.blue.opacity(0.7) : Color.blue)
                    .cornerRadius(8)
            }
            .disabled(isCodeSent)
            
            TextField("Verification Code", text: $verificationCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(!isCodeSent)
            
            Button(action: enroll2FA) {
                Text("Enroll 2FA")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .disabled(verificationCode.isEmpty || verificationId == nil)
            Spacer()
        }
        .padding()
        .navigationBarTitle("Two-Factor Authentication")
        
    }
    
    
    func sendVerificationCode() {
        guard !phoneNumber.isEmpty else {
            print("ENTER A VALID PHONE NUMBER")
            return
        }
        
        let firebaseAuthSettings = Auth.auth().settings
        
        
        PhoneAuthProvider.provider().verifyPhoneNumber(
            phoneNumber,
            uiDelegate: nil,
            multiFactorSession: nil) { (verificationId, error) in
            if let error = error {
                // Handle the error (e.g., show an alert)
                print("Error sending verification code: \(error.localizedDescription)")
                return
            }
            self.verificationId = verificationId
            self.isCodeSent = true
        }
    }
    
    func enroll2FA() {
        guard let verificationId = verificationId else {
            print("Verification ID not sent")
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: verificationCode)
        
        // Assuming you have already obtained the 'authResult' before showing this view
        let user = Auth.auth().currentUser
        
        let assertion = PhoneMultiFactorGenerator.assertion(with: credential)
        
        user?.multiFactor.enroll(with: assertion, displayName: nil) { (error) in
            if let error = error {
                // Handle the enrollment error (e.g., show an alert)
                print("Error enrolling 2FA: \(error.localizedDescription)")
                return
            }
            
            // 2FA enrollment successful. You can perform any further actions here, such as navigating to the main app screen.
            print("2FA enrollment successful.")
        }
    }
}

struct TwoFactorAuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TwoFactorAuthenticationView()
        }
    }
}
