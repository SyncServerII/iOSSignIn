import SwiftUI
import ServerShared

public protocol SignInServicesHelper {
    var currentSignIn:GenericSignIn? { get }
    var invitation: Invitation? { get set }
}

public class SignInServices: SignInServicesHelper {
    public var currentSignIn: GenericSignIn? {
        return manager.currentSignIn
    }
    
    public let manager: SignInManager
    
    /// Use this View to present the various sign-in options to the user.
    public var signInView: some View {
        return SignInView(controller: controller, width: controller.configuration.width, height: controller.configuration.height)
    }
    
    /// When an invitation is received, assign this.
    #warning("Do we have a mechanism by which an invitation link can be tapped by the user and this assigned?")
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
