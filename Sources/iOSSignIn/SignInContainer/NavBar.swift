
import SwiftUI

public struct OptionalNavBar: View {
    let contents: AnyView
    let model: SignInModel
    let action:()->()
    
    public init(model: SignInModel, contents: AnyView, action: @escaping ()->()) {
        self.contents = contents
        self.model = model
        self.action = action
    }
    
    public var body: some View {
        if model.navBarOptions != .none {
            return AnyView(
                NavigationView {
                    contents
                    .optionalNavigationBarTitle(model: model)
                    .optionalNavigationBarButton(model: model, action: action)
                }
            )
        }
        else {
            return contents
        }
    }
}

// Adapted extensions from https://www.hackingwithswift.com/books/ios-swiftui/custom-modifiers
extension View {
    func optionalNavigationBarTitle(model: SignInModel) -> some View {
        if model.navBarOptions.contains(.title) {
            return AnyView(
                self.navigationBarTitle(Text(model.navBarTitle), displayMode: .inline)
            )
        }
        else {
            return AnyView(self)
        }
    }
    
    func optionalNavigationBarButton(model: SignInModel, action: @escaping ()->()) -> some View {
        if model.navBarOptions.contains(.button) {
            return AnyView(
                self.navigationBarItems(leading:
                    Button(action: {
                        action()
                    }) {
                        Image(systemName: "chevron.left.circle")
                    }
                )
            )
        }
        else {
            // Just returning `self` here doesn't cause the nav bar button to be removed.
            return AnyView(
                self.navigationBarItems(leading: EmptyView())
            )
        }
    }
}
