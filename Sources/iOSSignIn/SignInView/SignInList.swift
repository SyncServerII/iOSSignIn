import SwiftUI

struct SignInList: View {
    @ObservedObject var model:SignInModel
    
    var body: some View {
        List {
            // Embedding `ForEach` to attempt to deal with updating problem.
            // The list wasn't updating when the `model.currentSignIns` changed
            // or when the list items went off screen.
            ForEach(model.currentSignIns) { signIn in
                SignInRow(description: signIn)
            }
        }
    }
}
