// Used by the sign-in views to indicate when user actions have been taken, and indirectly drive navigation and changes to the UI.
protocol SignInDelegate: AnyObject {
    func mainScreenIsDisplayed()
    func mainScreenSignInButtonTapped()
    func mainScreenCreateAccountButtonTapped()
    func backButtonTapped()
    func infoButtonTapped()
    func helpInfo() -> (title: String, message: String)
}
