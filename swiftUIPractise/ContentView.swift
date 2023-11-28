import SwiftUI

struct Person: Identifiable {
    var id = UUID()
    var name: String

    init(name: String) {
        self.name = name
    }
}

class Model: ObservableObject {
    @Published var people: [Person]

    init() {
        self.people = []
    }
}

struct ContentView: View {
    @ObservedObject var model = Model()
    @State var newName = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(model.people.indices, id: \.self) { index in
                    NavigationLink(
                        destination: PersonDetailView(editedName: $model.people[index].name)
                    ) {
                        Text(model.people[index].name)
                    }
                }
            }
            
            NavigationLink(destination: PersonDetailView(editedName: $newName) ) {
                Text("Add Person")
            }
            .navigationBarTitle("People List")
            .onAppear {
                if !newName.isEmpty {
                    self.model.people.append(Person(name: newName))
                    self.newName = ""
                }
            }
        }
    }
}

struct PersonDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var editedName: String
    @State var text = ""
    
    var body: some View {
        NavigationStack {
            TextField("Enter name", text: !editedName.isEmpty ? $editedName :  $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button{
                if !text.isEmpty {
                    editedName = text
                }
                dismiss()
            } label: {
                Text("Save")
                // You can display other details or controls as needed
            }
            .padding()
            .navigationBarTitle("Details for \(editedName)")
        }
    }
}
