import SwiftUI

struct SignInList: View {
    var body: some View {
        List {
            SignInRow(visible: true, name: "Dropbox")
            SignInRow(visible: true, name: "Google")
            SignInRow(visible: true, name: "Facebook")
            SignInRow(visible: true, name: "One Drive")
        }
    }
}
