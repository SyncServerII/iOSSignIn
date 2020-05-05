import Foundation

public enum GenericCredentialsError: Error {
    case noRefreshAvailable
}

public protocol GenericCredentials {
    /// A unique identifier for the user for the specific account type. E.g., for Google this is their `sub`.
    var userId:String { get }

    /// This is sent to the server as a human-readable means to identify the user.
    var username:String? { get }

    /// A name suitable for identifying the user via the UI. If available this should be the users email. Otherwise, it could be the same as the username.
    var uiDisplayName:String? { get }

    var httpRequestHeaders:[String:String] { get }

    /// If your credentials scheme enables a refresh, i.e., on the credentials expiring.
    /// If your credentials scheme doesn't have a refresh capability, then immediately call the callback with a non-nil Error.
    func refreshCredentials(completion: @escaping (Error?) ->())
}
