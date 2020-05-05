
import SwiftUI

public struct NavBar: View {
    let contents: AnyView
    let model: SignInModel
    let action:()->()
    
    public init(model: SignInModel, contents: AnyView, action: @escaping ()->()) {
        self.contents = contents
        self.model = model
        self.action = action
    }
    
    public var body: some View {
        if model.showNavBar {
            return AnyView(
                NavigationView {
                    contents
                    .navigationBarTitle(Text(model.navBarTitle), displayMode: .inline)
                    .navigationBarItems(leading:
                        Button(action: {
                            self.action()
                        }) {
                           Image(systemName: "chevron.left.circle")
                        }
                    )
                }
            )
        }
        else {
            return contents
        }
    }
}
