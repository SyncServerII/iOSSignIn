import SwiftUI
import ServerShared

public class SignInServices {
    public let manager: SignInManager
    
    /// Use this View to present the various sign-in options to the user.
    public var signInView: some View {
        return SignInView(controller: controller, width: controller.configuration.width, height: controller.configuration.height)
    }
    
    public var invitation: Invitation? {
        didSet {
            controller.invitation = invitation
        }
    }
    
    private let controller:SignInController
    
    public init(descriptions: [SignInDescription], configuration: UIConfiguration) {
        controller = SignInController(signIns: descriptions, configuration: configuration)
        manager = SignInManager(controlDelegate: controller)
    }
}
