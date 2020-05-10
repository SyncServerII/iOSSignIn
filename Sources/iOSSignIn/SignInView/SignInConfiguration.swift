public struct SignInConfiguration {
    // Title strings
    let signIntoExisting:String
    let signingIntoExisting:String
    let signedIntoExisting:String
    let createNewAccount:String
    let creatingNewAccount:String
    let createdNewAccount:String
    
    public init(
        signIntoExisting: String = "Sign into Existing Account",
        signingIntoExisting:String = "Signing into Existing Account",
        signedIntoExisting:String = "Signed into Existing Account",
        createNewAccount:String = "Create New Account",
        creatingNewAccount:String = "Creating New Account",
        createdNewAccount:String = "Created New Account") {
        
        self.signIntoExisting = signIntoExisting
        self.signingIntoExisting = signingIntoExisting
        self.signedIntoExisting = signedIntoExisting
        self.createNewAccount = createNewAccount
        self.creatingNewAccount = creatingNewAccount
        self.createdNewAccount = createdNewAccount
    }
}
