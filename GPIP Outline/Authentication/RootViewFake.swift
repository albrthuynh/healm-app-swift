//
//  RootViewFake.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 7/21/23.
//

import SwiftUI

struct RootViewFake: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack{ 
            NavigationStack{
                ContentView(showSignInView: $showSignInView)
            }
        }
        .onAppear{
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack{
                //AuthenticationView FOR NOW
                SignInView(showSignInView: $showSignInView)
            }
        }
    }
}

struct RootViewFake_Previews: PreviewProvider {
    static var previews: some View {
        RootViewFake()
    }
}
