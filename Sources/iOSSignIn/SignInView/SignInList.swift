import SwiftUI

struct SignInList: View {
    @ObservedObject var model:SignInModel
    
    var body: some View {
        List(model.currentSignIns) { signIn in
            SignInRow(description: signIn)
        }
    }
}
