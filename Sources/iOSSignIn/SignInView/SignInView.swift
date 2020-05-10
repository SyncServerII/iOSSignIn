import SwiftUI

// Displays a collection of sign-ins, and allows the user to either sign in to an existing account, or create a new account
struct SignInView: View {    
    private let controller:SignInController
    private var model: SignInModel {
        return controller.model
    }
    
    private let width:CGFloat
    private let height:CGFloat
    
    init(controller:SignInController, width: CGFloat = 250, height: CGFloat = 300) {
        self.width = width
        self.height = height
        self.controller = controller
    }
        
    var body: some View {
        SignInContainerView(model: self.model, delegate: self.controller)
            .border(Color(UIColor.lightGray))
            .frame(maxWidth: self.width, maxHeight: self.height)
    }
}
