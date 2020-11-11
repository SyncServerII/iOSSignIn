import SwiftUI

struct SignInList: View {
    @ObservedObject var model:SignInModel
    
    var body: some View {
        ScrollView {
            ForEach(model.currentSignIns) { signIn in
                SignInRow(description: signIn)
            }
        }
    }
}
