import SwiftUI
import ServerShared

public protocol SignInServicesHelper: AnyObject {
    var currentCredentials: GenericCredentials? { get }
    
    // For cloud storage owning accounts, the cloud storage type for the currentCredentials.
    var cloudStorageType: CloudStorageType? { get }
    
    var userType: UserType? { get }
    
    // Sign the current user out.
    func signUserOut()
}

enum SignInServicesError: Error {
    case userSignedIn
}

public class SignInServices {
    public let manager: SignInManager
    public let sharingInvitation: SharingInvitation
    
    /// Use this View to present the various sign-in options to the user.
    public var signInView: some View {
        return SignInView(controller: controller, width: controller.configuration.width, height: controller.configuration.height)
    }

    private let controller:SignInController
    private weak var helper: SharingInvitationHelper!

    /// `signIns` is the main integration point with iOSBasics. It must be the
    /// `SignIns` object you also pass to the SyncServer constructor with iOSBasics.
    /// This object is weakly retained.
    public init(descriptions: [SignInDescription], configuration: UIConfiguration, appBundleIdentifier: String, signIns: SignInsDelegate, sharingInvitationHelper: SharingInvitationHelper) {
        controller = SignInController(signIns: descriptions, configuration: configuration)
        manager = SignInManager(signIns: signIns)
        manager.controlDelegate = controller
        sharingInvitation = SharingInvitation(appBundleIdentifier: appBundleIdentifier, helper: sharingInvitationHelper)
        helper = sharingInvitationHelper
        sharingInvitation.delegate = self
    }
    
    /// This is for invitations received via UI-- to allow user to copy/paste an invitation code.
    /// This drives the sign-in UI to allow the user to sign in. We're assuming they don't yet have an account on SyncServer. This will enable them to create an account on SyncServer.
    public func copyPaste(invitation: Invitation) throws {
        guard !manager.userIsSignedIn else {
            throw SignInServicesError.userSignedIn
        }
        
        controller.invitation = invitation
    }
}

extension SignInServices: SharingInvitationDelegate {
    func sharingInvitationReceived(_ sharingInvitation: SharingInvitation, invite: Invitation) {
        if manager.userIsSignedIn {
            // Since the user is signed in, redeeming the new invitation doesn't need any more work in terms of signing-in. So, just pass the invitation along.
            manager.delegate.sharingInvitationForSignedInUser(manager, invitation: invite)
        }
        else {
            // User first needs to sign in. We're assuming they don't yet have an account on SyncServer. This will enable them to create an account on SyncServer.
            controller.invitation = invite
        }
    }
}
