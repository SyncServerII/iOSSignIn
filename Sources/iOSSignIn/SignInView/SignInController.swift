import SwiftUI

class SignInController {
    let configuration: SignInConfiguration
    let helpTitle = "Help"
    let helpMessage = "Select a sign in type. Select a sign in type. Select a sign in type. Select a sign in type. Select a sign in type. Select a sign in type. Select a sign in type. Select a sign in type."
    
    private enum AccountMode {
        case signIn
        case create
    }
    
    private var accountMode:AccountMode = .signIn

    let model:SignInModel
    let allSignIns: [SignInDescription]
    
    init(signIns: [SignInDescription],
        configuration: SignInConfiguration) {
        self.configuration = configuration
        
        allSignIns = signIns.sorted(by: { (s1, s2) -> Bool in
            return s1.signInName < s2.signInName
        })
        
        model = SignInModel()
        model.navBarOptions = .none
    }
}

extension SignInController: SignInDelegate {
    func helpInfo() -> (title: String, message: String) {
        return (
            title: helpTitle,
            message: helpMessage
        )
    }
    
    func infoButtonTapped() {
        model.showHelpInfo.toggle()
    }
    
    func mainScreenIsDisplayed() {
    }
    
    func backButtonTapped() {
        model.screenState = .main
        model.navBarOptions = .none
    }
    
    func mainScreenSignInButtonTapped() {
        accountMode = .signIn
        model.currentSignIns = allSignIns
        model.screenState = .list
        model.navBarOptions = .all
        model.navBarTitle = configuration.signIntoExisting
    }
    
    func mainScreenCreateAccountButtonTapped() {
        accountMode = .create
        model.currentSignIns = allSignIns.filter{ $0.userType == .owning }
        model.screenState = .list
        model.navBarOptions = .all
        model.navBarTitle = configuration.createNewAccount
    }
}

extension SignInController: SignInTransitions {
    func signInStarted(_ signIn: GenericSignIn) {
        // Transitional state. User has tapped sign in button -- they want to create an account or to sign into an existing account.
        
        let navBarTitle: String
        switch accountMode {
        case .create:
            navBarTitle = configuration.creatingNewAccount
        case .signIn:
            navBarTitle = configuration.signingIntoExisting
        }
        
        model.currentSignIns = allSignIns.filter{ $0.signInName == signIn.signInName }
        model.navBarOptions = .title
        model.navBarTitle = navBarTitle
    }
    
    func signInCancelled(_ signIn: GenericSignIn) {
        let navBarTitle: String
        
        switch accountMode {
        case .create:
            navBarTitle = configuration.createNewAccount
            model.currentSignIns = allSignIns.filter{ $0.userType == .owning }
        case .signIn:
            navBarTitle = configuration.signIntoExisting
            model.currentSignIns = allSignIns
        }
        
        model.navBarTitle = navBarTitle
        model.screenState = .list
        model.navBarOptions = .all
    }
    
    func signInCompleted(_ signIn: GenericSignIn) {
        let navBarTitle: String
        switch accountMode {
        case .create:
            navBarTitle = configuration.createdNewAccount
        case .signIn:
            navBarTitle = configuration.signedIntoExisting
        }
        
        model.navBarTitle = navBarTitle
    }
    
    func userIsSignedOut(_ signIn: GenericSignIn) {
        // User has tapped button when there is a single one. They want to sign out.
        
        withAnimation(.easeInOut) {
            model.screenState = .main
            model.navBarOptions = .none
        }
    }
}
