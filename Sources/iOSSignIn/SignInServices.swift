import SwiftUI
import ServerShared

public protocol SignInServicesHelper {
    var currentCredentials: GenericCredentials? { get }
    
    // For cloud storage owning accounts, the cloud storage type for the currentCredentials.
    var cloudStorageType: CloudStorageType? { get }
    
    // Set the current `Invitation` to nil.
    func resetCurrentInvitation()
}

public class SignInServices {
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

extension SignInServices: SignInServicesHelper {
    public var currentCredentials: GenericCredentials? {
        return manager.currentSignIn?.credentials
    }
    
    public var cloudStorageType: CloudStorageType? {
        return manager.currentSignIn?.cloudStorageType
    }
    
    public func resetCurrentInvitation() {
        invitation = nil
    }
}
