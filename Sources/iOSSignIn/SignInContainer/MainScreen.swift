import SwiftUI

// Shows the Sign-in and Create Account buttons.
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
            
            Spacer().frame(minHeight: 10, maxHeight: 50)
            
            Button(action: {
                // TODO
            }) {
                Text("Create Account")
            }
        }
        // I needed this in order to have the VStack expand out further than minimum.
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

