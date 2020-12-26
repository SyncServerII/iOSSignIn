import SwiftUI
import Foundation

// Displays a collection of sign-ins, and allows the user to either sign in to an existing account, or create a new account
struct SignInContainerView: View {
    @ObservedObject var model: SignInModel
    let padding:CGFloat = 50
    weak var delegate: SignInDelegate!

    init(model: SignInModel, delegate: SignInDelegate?) {
        self.model = model
        self.delegate = delegate
    }
        
    var body: some View {
        VStack {
            if model.navBarOptions == .none {
                self.containedView()
            }
            else {
                NavigationBar(title: model.navBarTitle, borderColor: .clear,
                    backButton:
                        NavBarButton(hidden: !model.navBarOptions.contains(.backButton),
                        action: {
                            withAnimation(.easeInOut) {
                                self.delegate?.backButtonTapped()
                            }
                        }),
                    infoButton:
                        NavBarButton(hidden: !model.navBarOptions.contains(.infoButton),
                        action: {
                            withAnimation(.easeInOut) {
                                self.delegate?.infoButtonTapped()
                            }
                        }))
                        
                Container {
                    self.containedView()
                }
            }
        }
    }
    
    func containedView() -> AnyView {
        withAnimation(.easeInOut) {
            switch model.screenState {
            case .main:
                return AnyView(
                    MainScreen(model: model, delegate: delegate)
                )
                    
            case .list:
                return AnyView(
                    SignInList(model: model)
                )
            }
        }
    }
}

private struct Container<Content: View>: View {
    let content: () -> Content
    var body: some View {
        // Seem to need the GeometryReader so that the container fills the remaining space, independent of its contents.
        GeometryReader { _ in
            self.content()
        }
    }
}

