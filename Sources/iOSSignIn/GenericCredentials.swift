import Foundation

public enum GenericCredentialsError: Error {
    case noRefreshAvailable
}

public protocol GenericCredentials: GenericCredentialsBasics {
    var httpRequestHeaders:[String:String] { get }

    /// If your credentials scheme enables a refresh, i.e., on the credentials expiring.
    /// If your credentials scheme doesn't have a refresh capability, then immediately call the callback with a non-nil Error.
    func refreshCredentials(completion: @escaping (Error?) ->())
}
