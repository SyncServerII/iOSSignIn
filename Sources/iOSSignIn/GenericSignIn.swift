import Foundation
import UIKit

public enum UserType : String {
    // user doesn't own cloud storage (e.g., Facebook user)
    // aka. social user or social account
    case sharing
    
    // user owns cloud storage (e.g., Google user)
    case owning

    // Maximum length of a UserType as a string.
    public static var maxStringLength: Int {
        return 20
    }
}

public protocol GenericSignIn : class {
    /// Some services, e.g., Facebook, are only suitable for sharing users-- i.e., they don't have cloud storage.
    var userType:UserType { get }
    
    /// For owning userType's, this gives the specific cloud storage type. For sharing userType's, this is nil.
    var cloudStorageType: String? {get}

    var delegate:GenericSignInDelegate? {get set}
    
    var managerDelegate:SignInManagerDelegate! {get set}
    
    /// `userSignedIn`, when true, indicates that the user was signed-in with this GenericSignIn last time, and not signed out.
    func appLaunchSetup(userSignedIn: Bool, withLaunchOptions options:[UIApplication.LaunchOptionsKey : Any]?)
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    
    /// To enable sticky sign-in, and the GenericSignIn to refresh credentials if that wasn't possible at app launch, this will be called when network connectivity changes state.
    func networkChangedState(networkIsOnline: Bool)

    /// The UI element to use to allow signing in. A successful result will give a non-nil UI element. Each time this method is called, the same element instance is returned. Passing nil will bypass the parameters required if any.
    func signInButton(configuration:[String:Any]?) -> UIView?
    
    /// Sign-in is sticky. Once signed-in, they tend to stay signed-in.
    var userIsSignedIn: Bool {get}

    /// Non-nil if userIsSignedIn is true.
    var credentials:GenericCredentials? { get }

    func signUserOut()
}
