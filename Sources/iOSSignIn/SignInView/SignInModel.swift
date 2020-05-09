import SwiftUI
import Combine


public class SignInModel: ObservableObject {
    public struct NavBarOption: OptionSet {
        public let rawValue: UInt
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        public static let none:NavBarOption = []
        public static let backButton = NavBarOption(rawValue: 1 << 0)
        public static let infoButton = NavBarOption(rawValue: 1 << 1)
        public static let title = NavBarOption(rawValue: 1 << 2)
        public static let all:NavBarOption = [.backButton, .infoButton, .title]
    }
    
    public init() {
    }
    
    @Published public var screenState: ScreenState = .main
    @Published public var navBarOptions: NavBarOption = .title
    @Published public var navBarTitle: String = "Sign into Existing Account"
}
