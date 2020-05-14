
import SwiftUI

struct SignInRow: View {
    let description: SignInDescription
    
    var body: some View {
        VStack {
            ButtonView(view: description.button)
        }
    }
}

// Map a UIView to a View. Will be using this to hold a UIView based sign-in button
// https://developer.apple.com/tutorials/swiftui/creating-and-combining-views
struct ButtonView: UIViewRepresentable {
    let view: UIView
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct SignInRow_Previews: PreviewProvider {
    static var previews: some View {
        SignInRow(description: SignInDescription(signInName: "Google", userType: .owning, button: UIView()))
    }
}
