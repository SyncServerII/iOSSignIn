
public class SignInController {
    public let model:SignInModel
    let allSignIns: [SignInDescription]
    public var singleSignIn: Bool {
        return model.currentSignIns.count == 1
    }
    
    public init(signIns: [SignInDescription]) {
        allSignIns = signIns.sorted(by: { (s1, s2) -> Bool in
            return s1.sortingName < s2.sortingName
        })
        
        model = SignInModel()
        model.navBarOptions = .none
    }
}

extension SignInController: SignInDelegate {
    public func signInButtonTapped(name: String) {
        if singleSignIn {
            model.screenState = .main
            model.navBarOptions = .none
        }
        else {
            model.currentSignIns = allSignIns.filter{ $0.sortingName == name }
            model.navBarOptions = .title
        }
    }
    
    public func infoButtonTapped() {
    }
    
    public func mainScreenIsDisplayed() {
    }
    
    public func backButtonTapped() {
        model.screenState = .main
        model.navBarOptions = .none
    }
    
    public func mainScreenSignInButtonTapped() {
        model.currentSignIns = allSignIns
        model.screenState = .list
        model.navBarOptions = .all
    }
    
    public func mainScreenCreateAccountButtonTapped() {
        model.currentSignIns = allSignIns.filter{ $0.userType == .owning }
        model.screenState = .list
        model.navBarOptions = .all
    }
}
