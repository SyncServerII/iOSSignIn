import SwiftUI

// Asked question about the problem with this list here:
// https://stackoverflow.com/questions/64815266

struct SignInList: View {
    @ObservedObject var model:SignInModel
    
    var body: some View {
        ScrollView() {
            ForEach(model.currentSignIns) { signIn in
                SignInRow(description: signIn)
                    .padding(.horizontal, 20)
            }
        }
    }
}
