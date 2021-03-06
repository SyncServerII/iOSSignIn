// So the SignInManager can operate on the SignInController
protocol SignInManagerControlDelegate: AnyObject {
    func signInStarted(_ signIn: GenericSignIn)
    func signInCancelled(_ signIn: GenericSignIn)
    func signInCompleted(_ signIn: GenericSignIn)
    func userIsSignedOut(_ signIn: GenericSignIn)
    func silentSignIn(_ signIn: GenericSignIn)
    func accountMode(_ signIn: GenericSignIn) -> AccountMode?
    
    // Show an alert that just neeeds an OK button.
    func showAlert(_ signIn: GenericSignIn, title: String, message: String?)
}
