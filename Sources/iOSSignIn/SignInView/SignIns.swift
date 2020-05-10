import SwiftUI

public class SignIns {
    let width: CGFloat
    let height: CGFloat
    let controller: SignInController
    let descriptions: [SignInDescription]
    
    /// The methods provided with this object need to be called to signal sign in transitions for the specific sign-ins.
    public var transitions: SignInTransitions {
        return controller
    }
    
    /// Use this View to present the various sign-ins to the user.
    public var signInView: some View {
        return SignInView(controller: controller, width: width, height: height)
    }
    
    public init(configuration: SignInConfiguration, descriptions: [SignInDescription], width: CGFloat = 250, height: CGFloat = 300) {
        self.descriptions = descriptions
        self.width = width
        self.height = height
        self.controller = SignInController(signIns: descriptions, configuration: configuration)
    }
}
