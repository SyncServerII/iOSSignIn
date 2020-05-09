import UIKit
import ServerShared

public struct SignInDescription: Identifiable {
    public var id = UUID()
    
    // This isn't displayed in the UI, but determines the order in which the signins appear -- they are sorted on this.
    let sortingName: String
    
    let userType: UserType
    
    let button: UIView
    
    public init(sortingName: String, userType: UserType, button: UIView) {
        self.sortingName = sortingName
        self.button = button
        self.userType = userType
    }
}
