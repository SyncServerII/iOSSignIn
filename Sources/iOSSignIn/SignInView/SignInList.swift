import SwiftUI

struct SignInList: View {
    let signIns: [SignInDescription]
    
    init(signIns: [SignInDescription]) {
        self.signIns = signIns
    }
    
    var body: some View {
        VStack {
            Text("Some text1")
            Text("Some text2")
        }
//        List(signIns) { signIn in
//            Text("Some text")
//            //SignInRow(description: signIn)
//        }
    }
}
