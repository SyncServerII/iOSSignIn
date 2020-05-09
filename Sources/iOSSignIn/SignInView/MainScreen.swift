import SwiftUI

// Shows the Sign-in and Create Account buttons.
struct MainScreen: View {
    @ObservedObject var model:SignInModel
    weak var delegate: SignInDelegate!
    
    // A public init is necessary for making the View publically visible!
    public init(model:SignInModel, delegate: SignInDelegate?) {
        self.model = model
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut) {
                    self.delegate?.mainScreenSignInButtonTapped()
                }
            }) {
                Text("Sign-in")
            }
            
            Spacer().frame(minHeight: 10, maxHeight: 50)
            
            Button(action: {
                withAnimation(.easeInOut) {
                    self.delegate?.mainScreenCreateAccountButtonTapped()
                }
            }) {
                Text("Create Account")
            }
        }
        // I needed this in order to have the VStack expand out further than minimum.
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear() {
            self.delegate?.mainScreenIsDisplayed()
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(model: SignInModel(), delegate: nil)
    }
}

