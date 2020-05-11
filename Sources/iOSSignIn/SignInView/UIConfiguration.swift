import UIKit

public struct UIConfiguration {
    // Title & help strings
    let signIntoExisting:String
    let signingIntoExisting:String
    let signedIntoExisting:String
    let createNewAccount:String
    let creatingNewAccount:String
    let createdNewAccount:String
    let helpTextWhenCreatingNewAccount:String
    
    public static let defaultHelpText = "Creating a new account will give you a new account in the app. Your cloud storage account (e.g., Dropbox) will be used to save the files you create."
    
    // Default size of main sign-in view.
    let width: CGFloat
    let height: CGFloat
    
    public init(
        signIntoExisting: String = "Sign into Existing Account",
        signingIntoExisting:String = "Signing into Existing Account",
        signedIntoExisting:String = "Signed into Existing Account",
        createNewAccount:String = "Create New Account",
        creatingNewAccount:String = "Creating New Account",
        createdNewAccount:String = "Created New Account",
        helpTextWhenCreatingNewAccount:String = Self.defaultHelpText,
        width: CGFloat = 250,
        height: CGFloat = 300) {
        
        self.signIntoExisting = signIntoExisting
        self.signingIntoExisting = signingIntoExisting
        self.signedIntoExisting = signedIntoExisting
        self.createNewAccount = createNewAccount
        self.creatingNewAccount = creatingNewAccount
        self.createdNewAccount = createdNewAccount
        self.helpTextWhenCreatingNewAccount = helpTextWhenCreatingNewAccount
        self.width = width
        self.height = height
    }
}
