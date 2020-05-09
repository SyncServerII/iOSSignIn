import UIKit
import ServerShared

public struct SignInDescription: Identifiable {
    public var id = UUID()
    
    // This isn't displayed in the UI, but determines the order in which the signins appear -- they are sorted on this.  It is also passed in the delegate method `signInButtonTapped`.
    let signInName: String
    
    let userType: UserType
    
    let button: UIView
    
    public init(signInName: String, userType: UserType, button: UIView) {
        self.signInName = signInName
        self.button = button
        self.userType = userType
    }
}
