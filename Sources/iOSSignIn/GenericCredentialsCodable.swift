import Foundation

// A utility protocol for implementations-- not required but possibly useful in testing and if their credentials need to be saved in the keychain or other local places.
public protocol GenericCredentialsCodable: GenericCredentialsBasics, Codable {
}

extension GenericCredentialsCodable {
    public static func fromData(_ data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
    
    public static func fromJSON(file: URL) throws -> Self {
        let data = try Data(contentsOf: file)
        return try fromData(data)
    }
    
    public func toData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}
