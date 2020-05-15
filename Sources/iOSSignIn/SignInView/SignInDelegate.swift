import ServerShared

// Used by the sign-in views to indicate when user actions have been taken, and indirectly drive navigation and changes to the UI. And by the sign-in views to obtain information.
protocol SignInDelegate: AnyObject {
    func mainScreenIsDisplayed()
    func mainScreenSignInButtonTapped()
    func mainScreenAcceptInvitationButtonTapped()
    func mainScreenCreateAccountButtonTapped()
    func backButtonTapped()
    func infoButtonTapped()
    var helpInfo: (title: String, message: String) { get }
}
