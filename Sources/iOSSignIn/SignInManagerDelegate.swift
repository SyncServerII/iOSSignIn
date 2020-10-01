import ServerShared
import Foundation

public protocol SignInsDelegate: AnyObject {
    /// Gets called after a particular sign-in completes.
    func signInCompleted(_ manager: SignInManager, signIn: GenericSignIn, mode: AccountMode, autoSignIn: Bool)
    
    func userIsSignedOut(_ manager: SignInManager, signIn:GenericSignIn)
}

// Enables a class using the SignInManager to be informed about main changes in sign-in state.
public protocol SignInManagerDelegate: SignInsDelegate {
    // Current signed in user needs to redeem a new sharing invitation.
    func sharingInvitationForSignedInUser(_ manager: SignInManager, invitation: Invitation)
}
