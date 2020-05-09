public protocol SignInDelegate: AnyObject {
    func mainScreenIsDisplayed()
    func mainScreenSignInButtonTapped()
    func mainScreenCreateAccountButtonTapped()
    func backButtonTapped()
    func infoButtonTapped()
    func signInButtonTapped(signInName: String)
    func helpInfo() -> (title: String, message: String)
}
