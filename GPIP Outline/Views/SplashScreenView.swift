//
//  SplashScreenView.swift
//  CoreDataAppDevelopment (PRACTICE)
//
//  Created by Albert Huynh on 7/5/23.
//

import SwiftUI


struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive{
            SignInView(showSignInView: .constant(true))
        }
        else{
            ZStack{
                Color("Background").edgesIgnoringSafeArea(.all)
                    VStack{
                        Image(systemName: "cross.case.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.red)
                        Text("Heal'm").font(Font.custom("Baskerville-Bold", size: 40))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear{
                        withAnimation(.easeIn(duration: 1.2)){
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        withAnimation{
                            self.isActive = true
                        }
                        
                    }
                }
            }
        }
        
    }

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SplashScreenView()
            
            SplashScreenView()
                .environment(\.colorScheme, .dark)

        }
    }
}
