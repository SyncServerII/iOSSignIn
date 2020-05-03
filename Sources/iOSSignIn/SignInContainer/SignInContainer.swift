import SwiftUI

struct TodoItem: Identifiable {
    var id = UUID()
    var action: String
}

struct SignInContainer: View {
    let todoItems: [TodoItem] = [
        TodoItem(action: "Writing a blogpost about SwiftUI"),
        TodoItem(action: "Walk with the dog"),
        TodoItem(action: "Drink a beer")]
        
    var body: some View {
        List(todoItems) { todoItem in
            SignInRow(visible: true, name: todoItem.action)
        }
    }
}

struct SignInContainer_Previews: PreviewProvider {
    static var previews: some View {
        SignInContainer()
    }
}
