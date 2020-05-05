import Foundation

public protocol GenericSignInDelegate: class {
    func signInStarted(_ signIn: GenericSignIn)
    func haveCredentials(_ signIn: GenericSignIn, credentials: GenericCredentials)
    func signInCompleted(_ signIn: GenericSignIn, autoSignIn:Bool)
    func userIsSignedOut(_ signIn:GenericSignIn)
}
