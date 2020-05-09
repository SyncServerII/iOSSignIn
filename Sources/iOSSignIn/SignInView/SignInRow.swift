
import SwiftUI

struct SignInRow: View {
    let description: SignInDescription
    
    var body: some View {
        VStack {
            Text(description.sortingName)
        }
    }
}

// Will be using this to hold a UIView based sign-in button
// https://developer.apple.com/tutorials/swiftui/creating-and-combining-views
struct LabelView: UIViewRepresentable {
    let text: String
    
    func makeUIView(context: Context) -> UIView {
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        label.backgroundColor = .green
        return label
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct SignInRow_Previews: PreviewProvider {
    static var previews: some View {
        SignInRow(description: SignInDescription(sortingName: "Google", userType: .owning, button: UIView()))
    }
}
