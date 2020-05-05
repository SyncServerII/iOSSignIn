import SwiftUI
import Combine

public class SignInModel: ObservableObject {
    public init() {
    }
    
    @Published public var screenState: ScreenState = .main
    @Published public var showNavBar: Bool = false
    @Published public var navBarTitle: String = "Sign into Existing Account"
}
