import SwiftUI
import Foundation

public struct SignInContainerView: View {
    @ObservedObject var model: SignInModel
    let padding:CGFloat = 50
    weak var delegate: SignInDelegate!

    public init(model: SignInModel, delegate: SignInDelegate?) {
        delegate?.backButtonTapped()
        self.model = model
        self.delegate = delegate
    }
        
    public var body: some View {
        VStack {
            if model.navBarOptions == .none {
                self.containedView()
            }
            else {
                NavigationBar(title: "Title with lots of text that might wrap to a second line.", borderColor: .clear,
                    backButton:
                        NavBarButton(hidden: !model.navBarOptions.contains(.backButton),
                        action: {
                            self.delegate?.backButtonTapped()
                        }),
                    infoButton:
                        NavBarButton(hidden: !model.navBarOptions.contains(.infoButton),
                        action: {
                            self.delegate?.infoButtonTapped()
                        }))
                        
                Container {
                    self.containedView()
                }
            }
        }
    }
    
    func containedView() -> AnyView {
        switch model.screenState {
        case .main:
            return AnyView(
                MainScreen(model: model, delegate: delegate)
            )
                
        case .list:            
            return AnyView(
                SignInList(signIns: model.currentSignIns)
            )
        }
    }
}

struct Container<Content: View>: View {
    let content: () -> Content
    var body: some View {
        // Seem to need the GeometryReader so that the container fills the remaining space, independent of its contents.
        GeometryReader { _ in
            self.content()
        }
    }
}

struct SignInContainer_Previews: PreviewProvider {
    static var previews: some View {
        SignInContainerView(model: SignInModel(), delegate: nil)
    }
}
