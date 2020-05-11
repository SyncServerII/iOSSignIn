public protocol SignInManagerDelegate: AnyObject {
    func signInCompleted(_ manager: SignInManager, signIn: GenericSignIn)
    func userIsSignedOut(_ manager: SignInManager, signIn:GenericSignIn)
}
