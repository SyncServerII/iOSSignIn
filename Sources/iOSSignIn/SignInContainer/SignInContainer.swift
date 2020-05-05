import SwiftUI
import Foundation

public struct SignInContainer: View {
    @ObservedObject var model: SignInModel
    let padding:CGFloat = 50

    public init(model: SignInModel) {
        self.model = model
    }
        
    public var body: some View {
        OptionalNavBar(model: model, contents:
            AnyView(
                VStack {
                    self.containedView()
                }
                .border(Color(UIColor.lightGray))
            ),
        action: {
            print("Back")
        })
    }
    
    func containedView() -> AnyView {
        switch model.screenState {
            case .main: return AnyView(MainScreen())
            case .list: return AnyView(SignInList())
        }
    }
}

struct SignInContainer_Previews: PreviewProvider {
    static var previews: some View {
        SignInContainer(model: SignInModel())
    }
}
