import SwiftUI
import iOSShared

struct SignInList: View {
    let signIns: [SignInDescription]
    
    init(signIns: [SignInDescription]) {
        self.signIns = signIns
    }
    
    var body: some View {
        List(signIns) { signIn in
            SignInRow(description: signIn)
        }
    }
}
