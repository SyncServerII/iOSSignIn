import SwiftUI

public class SignInController {
    let signIntoExisting:String
    let signingIntoExisting:String
    let signedIntoExisting:String
    let createNewAccount:String
    let creatingNewAccount:String
    let createdNewAccount:String
    let helpTitle = "Help"
    let helpMessage = "Select a sign in type. Select a sign in type. Select a sign in type. Select a sign in type. Select a sign in type. Select a sign in type. Select a sign in type. Select a sign in type."
    
    private enum AccountMode {
        case signIn
        case create
    }
    
    private var accountMode:AccountMode = .signIn

    public let model:SignInModel
    let allSignIns: [SignInDescription]
    public var singleSignIn: Bool {
        return model.currentSignIns.count == 1
    }
    
    public init(signIns: [SignInDescription],
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
        
        allSignIns = signIns.sorted(by: { (s1, s2) -> Bool in
            return s1.signInName < s2.signInName
        })
        
        model = SignInModel()
        model.navBarOptions = .none
    }
}

extension SignInController: SignInDelegate {
    public func helpInfo() -> (title: String, message: String) {
        return (
            title: helpTitle,
            message: helpMessage
        )
    }
    
    public func signInButtonTapped(signInName: String) {
        if singleSignIn {
            // User has tapped button when there is a single one. They want to sign out.
            
            withAnimation(.easeInOut) {
                model.screenState = .main
                model.navBarOptions = .none
            }
        }
        else {
            // Transitional state. User has tapped sign in button -- they want to create an account or to sign into an existing account.
            
            let navBarTitle: String
            switch accountMode {
            case .create:
                navBarTitle = creatingNewAccount
            case .signIn:
                navBarTitle = signingIntoExisting
            }
            
            model.currentSignIns = allSignIns.filter{ $0.signInName == signInName }
            model.navBarOptions = .title
            model.navBarTitle = navBarTitle
        }
    }
    
    public func infoButtonTapped() {
        model.showHelpInfo.toggle()
    }
    
    public func mainScreenIsDisplayed() {
    }
    
    public func backButtonTapped() {
        model.screenState = .main
        model.navBarOptions = .none
    }
    
    public func mainScreenSignInButtonTapped() {
        accountMode = .signIn
        model.currentSignIns = allSignIns
        model.screenState = .list
        model.navBarOptions = .all
        model.navBarTitle = signIntoExisting
    }
    
    public func mainScreenCreateAccountButtonTapped() {
        accountMode = .create
        model.currentSignIns = allSignIns.filter{ $0.userType == .owning }
        model.screenState = .list
        model.navBarOptions = .all
        model.navBarTitle = createNewAccount
    }
}
