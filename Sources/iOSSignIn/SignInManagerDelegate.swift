
// Enables a class using the SignInManager to be informed about main changes in sign-in state.
public protocol SignInManagerDelegate: AnyObject {
    // This needs to carry out the process that was `completeSignInProcess` in individual GenericSignIn's before.
    
    /// Gets called after a particular sign-in completes.
    func signInCompleted(_ manager: SignInManager, signIn: GenericSignIn, mode: AccountMode, autoSignIn: Bool)
    
    func userIsSignedOut(_ manager: SignInManager, signIn:GenericSignIn)
}
