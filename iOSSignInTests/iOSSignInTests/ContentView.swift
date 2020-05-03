//
//  ContentView.swift
//  iOSSignInTests
//
//  Created by Christopher G Prince on 5/2/20.
//  Copyright © 2020 Spastic Muffin, LLC. All rights reserved.
//

import SwiftUI
import iOSSignIn

struct ContentView: View {
    let padding:CGFloat = 50
    var body: some View {
        VStack {
            SignInContainer()
        }.padding(EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
