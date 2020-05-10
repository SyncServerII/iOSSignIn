public protocol SignInTransitions {
    // TODO: When we're getting nearer to completing, change signInName: String to signIn: GenericSignIn
    func signInStarted(_ signInName: String)
    func signInCompleted(_ signInName: String)
    func userIsSignedOut(_ signInName: String)
}
