
import SwiftUI

struct SignInRow: View {
    let visible: Bool
    let name: String
    
    var body: some View {
        VStack {
            if self.visible {
                Text(name)
            }
        }
    }
}

struct SignInRow_Previews: PreviewProvider {
    static var previews: some View {
        SignInRow(visible: false, name: "Foo")
    }
}
