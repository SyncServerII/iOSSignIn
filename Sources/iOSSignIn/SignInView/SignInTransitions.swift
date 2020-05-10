public protocol SignInTransitions {
    func signInStarted(_ signIn: GenericSignIn)
    func signInCancelled(_ signIn: GenericSignIn)
    func signInCompleted(_ signIn: GenericSignIn)
    func userIsSignedOut(_ signIn: GenericSignIn)
}
