
import SwiftUI

// Images from https://stackoverflow.com/questions/56514998/find-all-available-images-for-imagesystemname-in-swiftui

struct NavBarButton {
    public let hidden: Bool
    public let action: ()->()
    
    // Action is not taken if hidden == true, and the button is hidden.
    public init(hidden: Bool, action: @escaping ()->()) {
        self.hidden = hidden
        self.action = action
    }
}

struct NavigationBar: View {
    let buttonWidth: CGFloat = 20
    let title: String
    let backButton: NavBarButton
    let infoButton: NavBarButton
    let borderColor: Color
    
    init(title: String, borderColor: Color = .black,
        backButton: NavBarButton, infoButton:NavBarButton) {
        self.title = title
        self.backButton = backButton
        self.infoButton = infoButton
        self.borderColor = borderColor
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            buttonIfAction(button:
                Button(action: {
                    self.backButton.action()
                }) {
                    Image(systemName: "chevron.left")
                }.frame(width: buttonWidth),
                show: !backButton.hidden)
                .padding([.leading], 10)
                .padding([.top], 20)
                
            Text(title)
                // This frame makes the text view span the full width, ending at the buttons.
                .frame(maxWidth: .infinity)
                // In order to have the text center-aligned along the horizontal.
                .multilineTextAlignment(.center)
                .padding([.top, .bottom], 10)

            buttonIfAction(button:
                Button(action: {
                    self.infoButton.action()
                }) {
                    Image(systemName: "info.circle")
                }.frame(width: buttonWidth),
                show: !infoButton.hidden)
                .padding([.trailing], 10)
                .padding([.top], 20)

        }.border(borderColor)
        .background(Color.gray.opacity(0.2))
    }
    
    private func buttonIfAction<Content: View>(button: Content, show: Bool) -> some View {
        if show {
            return AnyView(button)
        }
        else {
            return AnyView(Spacer().frame(width: buttonWidth))
        }
    }
}
