import SwiftUI
import ServerShared

public protocol SignInServicesHelper: AnyObject {
    var currentCredentials: GenericCredentials? { get }
    
    // For cloud storage owning accounts, the cloud storage type for the currentCredentials.
    var cloudStorageType: CloudStorageType? { get }
    
    var userType: UserType? { get }
    
    // Sign the current user out.
    func signUserOut()
    
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

    /// `signIns` is the main integration point with iOSBasics. It must be the
    /// `SignIns` object you also pass to the SyncServer constructor with iOSBasics.
    /// This object is weakly retained.
    public init(descriptions: [SignInDescription], configuration: UIConfiguration, signIns: SignInManagerDelegate) {
        controller = SignInController(signIns: descriptions, configuration: configuration)
        manager = SignInManager(signIns: signIns)
        manager.controlDelegate = controller
    }
}
