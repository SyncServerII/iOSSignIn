import SwiftUI
import Combine
import iOSShared

class SignInModel: ObservableObject {
    struct NavBarOption: OptionSet {
        let rawValue: UInt
        init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        static let none:NavBarOption = []
        static let backButton = NavBarOption(rawValue: 1 << 0)
        static let infoButton = NavBarOption(rawValue: 1 << 1)
        static let title = NavBarOption(rawValue: 1 << 2)
        static let all:NavBarOption = [.backButton, .infoButton, .title]
    }

    @Published var currentSignIns = [SignInDescription]()
    @Published var screenState: ScreenState = .main
    @Published var includeAcceptInvitation: Bool = false
    @Published var navBarOptions: NavBarOption = .title
    @Published var navBarTitle: String = "Sign into Existing Account"
    weak var userAlertDelegate: UserAlertDelegate?
    
    init(userAlertDelegate: UserAlertDelegate) {
        self.userAlertDelegate = userAlertDelegate
    }
}
