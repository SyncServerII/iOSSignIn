import Foundation

// Delegate adopted by GenericSignIn's. E.g., by iOSDropbox or iOSFacebook.
public protocol GenericSignInDelegate: AnyObject {
    func signInStarted(_ signIn: GenericSignIn)
    func signInCancelled(_ signIn: GenericSignIn)
    func haveCredentials(_ signIn: GenericSignIn, credentials: GenericCredentials)
    func signInCompleted(_ signIn: GenericSignIn, autoSignIn:Bool)
    func userIsSignedOut(_ signIn:GenericSignIn)
}
