protocol SignInDelegate: AnyObject {
    func mainScreenIsDisplayed()
    func mainScreenSignInButtonTapped()
    func mainScreenCreateAccountButtonTapped()
    func backButtonTapped()
    func infoButtonTapped()
    func helpInfo() -> (title: String, message: String)
}
