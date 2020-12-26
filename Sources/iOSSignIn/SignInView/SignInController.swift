import SwiftUI
import ServerShared
import iOSShared

// When there is an invitation, an invitation needs to be supplied when this starts, and then drive the behavior. Otherwise, the sign-in behavior is driven by the user choice between sign in and creating an account.

class SignInController {
    let configuration: UIConfiguration
    let helpTitle = "Help"

    private var accountMode:AccountMode?
    var invitation: Invitation? {
        didSet {
            model.includeAcceptInvitation = invitation != nil
            
            // Design calls for immediately showing the account list-- because at this point the user will have been trying to accept the invitation.
            if let _ = invitation {
                allowUserToAcceptInvitation()
            }
        }
    }

    @ObservedObject var model:SignInModel
    let allSignIns: [SignInDescription]
    
    init(signIns: [SignInDescription], configuration: UIConfiguration, userAlertDelegate: UserAlertDelegate) {
        
        self.configuration = configuration
        
        allSignIns = signIns.sorted(by: { (s1, s2) -> Bool in
            return s1.signInName < s2.signInName
        })
        
        model = SignInModel(userAlertDelegate: userAlertDelegate)
        model.navBarOptions = .none
    }
    
    private func allowUserToAcceptInvitation() {
        if let invitation = invitation {
            accountMode = .acceptInvitationAndCreateUser(invitation: invitation)
            
            model.screenState = .list
            model.navBarOptions = [.backButton, .title, .infoButton]
            model.navBarTitle = configuration.createAccountAndAcceptInvitation
            
            if invitation.allowsSocialSharing {
                model.currentSignIns = allSignIns
            }
            else {
                model.currentSignIns = allSignIns.filter{ $0.userType == .owning }
            }
        }
        else {
            model.userAlertDelegate?.userAlert = .error(message: "Did not have an invitation.")
            logger.error("ERROR: Did not have invitation")
        }
    }
}

extension SignInController: SignInDelegate {    
    var helpInfo: (title: String, message: String) {
        if let _ = invitation {
            return (
                title: helpTitle,
                message: configuration.helpTextWhenAcceptingInvitation
            )
        }
        else {
            return (
                title: helpTitle,
                message: configuration.helpTextWhenCreatingNewAccount
            )
        }
    }
    
    func infoButtonTapped() {
        model.userAlertDelegate?.userAlert = .full(title: helpInfo.title, message: helpInfo.message)
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
        model.navBarOptions = [.backButton, .title]
        model.navBarTitle = configuration.signIntoExisting
    }
    
    func mainScreenAcceptInvitationButtonTapped() {
        allowUserToAcceptInvitation()
    }
    
    func mainScreenCreateAccountButtonTapped() {
        accountMode = .createOwningUser
        model.currentSignIns = allSignIns.filter{ $0.userType == .owning }
        model.screenState = .list
        model.navBarOptions = .all
        model.navBarTitle = configuration.createNewAccount
    }
}

extension SignInController: SignInManagerControlDelegate {
    func showAlert(_ signIn: GenericSignIn, title: String, message: String?) {
        model.userAlertDelegate?.userAlert = .full(title: title, message: message ?? "")
        logger.info("Alert: \(title): \(String(describing: message))")
    }
    
    func silentSignIn(_ signIn: GenericSignIn) {
        // Non-transitional state. User is signed in.
        model.currentSignIns = allSignIns.filter{ $0.signInName == signIn.signInName }
        model.navBarOptions = .title
        model.navBarTitle = configuration.signedIntoExisting
        model.screenState = .list
    }
    
    func signInStarted(_ signIn: GenericSignIn) {
        // Transitional state. User has tapped sign in button -- they want to create an account or to sign into an existing account.
        
        guard let accountMode = accountMode else {
            logger.error("signInStarted: ERROR: Could not get AccountMode")
            return
        }
        
        let navBarTitle: String
        switch accountMode {
        case .createOwningUser:
            navBarTitle = configuration.creatingNewAccount
        case .signIn:
            navBarTitle = configuration.signingIntoExisting
        case .acceptInvitationAndCreateUser:
            navBarTitle = configuration.creatingAccountAndAcceptingInvitation
        }
        
        model.currentSignIns = allSignIns.filter{ $0.signInName == signIn.signInName }
        model.navBarOptions = .title
        model.navBarTitle = navBarTitle
    }
    
    func signInCancelled(_ signIn: GenericSignIn) {
        let navBarTitle: String
        
        guard let accountMode = accountMode else {
            logger.error("signInCancelled: ERROR: Could not get AccountMode")
            return
        }
        
        switch accountMode {
        case .createOwningUser:
            navBarTitle = configuration.createNewAccount
            model.currentSignIns = allSignIns.filter{ $0.userType == .owning }
        case .signIn:
            navBarTitle = configuration.signIntoExisting
            model.currentSignIns = allSignIns
        case .acceptInvitationAndCreateUser(let invitation):
            navBarTitle = configuration.createAccountAndAcceptInvitation
            if invitation.allowsSocialSharing {
                model.currentSignIns = allSignIns
            }
            else {
                model.currentSignIns = allSignIns.filter{ $0.userType == .owning }
            }
        }
        
        model.navBarTitle = navBarTitle
        model.screenState = .list
        model.navBarOptions =  [.backButton, .title]
    }
    
    func signInCompleted(_ signIn: GenericSignIn) {
        let navBarTitle: String
        
        guard let accountMode = accountMode else {
            logger.error("SignInController.signInCompleted: ERROR: Could not get AccountMode")
            return
        }
        
        switch accountMode {
        case .createOwningUser:
            navBarTitle = configuration.createdNewAccount
        case .signIn:
            navBarTitle = configuration.signedIntoExisting
        case .acceptInvitationAndCreateUser:
            navBarTitle = configuration.createdAccountAndAcceptedInvitation
        }
        
        model.navBarTitle = navBarTitle
    }
    
    func userIsSignedOut(_ signIn: GenericSignIn) {
        #warning("Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.")
        model.screenState = .main
        model.navBarOptions = .none
    }
    
    func accountMode(_ signIn: GenericSignIn) -> AccountMode? {
        return accountMode
    }
}
