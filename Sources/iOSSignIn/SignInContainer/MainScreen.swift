import SwiftUI

public struct MainScreen: View {
    // A public init is necessary for making the View publically visible!
    public init() {
    }
    
    public var body: some View {
        VStack {
            Button(action: {
                // TODO
            }) {
                Text("Sign-in")
            }
            
            Button(action: {
                // TODO
            }) {
                Text("Create Account")
            }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

