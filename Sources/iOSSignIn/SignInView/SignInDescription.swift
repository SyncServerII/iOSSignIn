import UIKit
import ServerShared

public struct SignInDescription: Identifiable, Hashable {
    public let id = UUID()
    
    // This isn't displayed in the UI, but determines the order in which the signins appear -- they are sorted on this. It needs to match the GenericSignIn `signInName`.
    let signInName: String
    
    let userType: UserType
    
    let button: UIView
    
    public init(signInName: String, userType: UserType, button: UIView) {
        self.signInName = signInName
        self.button = button
        self.userType = userType
    }
}
