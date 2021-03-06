import ServerShared

public protocol GenericCredentialsBasics {
    /// A unique identifier for the user for the specific account type. E.g., for Google this is their `sub`.
    var userId:String { get }

    /// This is sent to the server as a human-readable means to identify the user.
    var username:String? { get }

    /// A name suitable for identifying the user via the UI. If available this should be the users email. Otherwise, it could be the same as the username.
    var uiDisplayName:String? { get }
    
    /// The users email address. Every effort should be made to get this. We need to store it on the backend in case needed to contact users.
    var emailAddress: String! { get }
}
