public protocol SignInManagerDelegate: AnyObject {
    // This needs to carry out the process that was `completeSignInProcess` in individual GenericSignIn's before.
    func signInCompleted(_ manager: SignInManager, signIn: GenericSignIn)
    
    func userIsSignedOut(_ manager: SignInManager, signIn:GenericSignIn)
}
