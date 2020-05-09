
public protocol SignInDelegate: AnyObject {
    func mainScreenIsDisplayed()
    func mainScreenSignInButtonTapped()
    func mainScreenCreateAccountButtonTapped()
    func signInDescriptions() -> [SignInDescription]
    func backButtonTapped()
    func infoButtonTapped()
}

public class SignInController {
    public let model:SignInModel
    let allSignIns: [SignInDescription]
    private var currentSignIns = [SignInDescription]()
    
    public init(signIns: [SignInDescription]) {
        allSignIns = signIns.sorted(by: { (s1, s2) -> Bool in
            return s1.sortingName < s2.sortingName
        })
        
        model = SignInModel()
        model.navBarOptions = .none
    }
}

extension SignInController: SignInDelegate {
    public func infoButtonTapped() {
    }
    
    public func mainScreenIsDisplayed() {
    }
    
    public func backButtonTapped() {
        model.screenState = .main
        model.navBarOptions = .none
    }
    
    public func mainScreenSignInButtonTapped() {
        currentSignIns = allSignIns
        model.screenState = .list
        model.navBarOptions = .all
    }
    
    public func mainScreenCreateAccountButtonTapped() {
        currentSignIns = allSignIns.filter{ $0.userType == .owning }
        model.screenState = .list
        model.navBarOptions = .all
    }
    
    public func signInDescriptions() -> [SignInDescription] {
        return currentSignIns
    }
}
