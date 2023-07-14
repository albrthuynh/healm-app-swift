//
//  AddContactView.swift
//  GPIP Outline
//
//  Created by Albert Huynh on 7/7/23.
//

import SwiftUI
import CoreData

class CoreDataViewModel: ObservableObject{
    
    let container: NSPersistentContainer
    @Published var savedEntities: [ContactEntity] = []
    
    init () {
        container = NSPersistentContainer(name: "ContactDataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error{
                print("ERROR LOADING CORE DATA. \(error)")
            } else {
                print("Successfully loaded core data!")
            }
            self.fetchContacts()
        }
    }
    
    func fetchContacts(){
        let request = NSFetchRequest<ContactEntity>(entityName: "ContactEntity")
        
        do{
            savedEntities = try container.viewContext.fetch(request)
        } catch let error{
            print("error fetching. \(error)")
        }
        
    }
    
    func addContact(text: String, number: String){
        let newContact = ContactEntity(context: container.viewContext)
        newContact.name = text
        newContact.id = UUID()
        newContact.e_contact = number
        saveData()
    }
    
    func updateContact(entity: ContactEntity) {
        let currentName = entity.name ?? ""
        let newName = currentName + "!"
        entity.name = newName
        saveData()
    }
    
    func deleteContact(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func saveData(){
        do{
            try container.viewContext.save()
            fetchContacts()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
}

struct AddContactView: View {
    @StateObject var vm = CoreDataViewModel()
    
    @State private var name = ""
    @State var contact: String = ""
    @State var textFieldText: String = ""
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20){
                Group{
                    TextField("Add name here...", text: $textFieldText)
                        .font(.headline)
                        .padding(.leading)
                        .frame(height: 55)
                        .background(Color(.lightGray))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    TextField("Add number here... EX 6301721121", text: $contact)
                        .font(.headline)
                        .padding(.leading)
                        .frame(height: 55)
                        .background(Color(.lightGray))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Button(action:{
                    guard !textFieldText.isEmpty else {return}
                    guard !contact.isEmpty else {return}
                
                    vm.addContact(text: textFieldText, number: contact)
                    textFieldText = ""
                    contact = ""
                }, label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color(.blue))
                        .cornerRadius(10)
                        .padding(.horizontal)
                })
                List {
                    ForEach(vm.savedEntities) { entity in
                        
                        Text(entity.name ?? "NO NAME").onTapGesture {
                            vm.updateContact(entity: entity)
                        }
                        
                        HStack{
                            Text(entity.e_contact ?? "NO NUM").onTapGesture{
                                vm.updateContact(entity: entity)
                            }
                            Spacer()
                            Image(systemName: "phone.fill")
                            if let contactNumber = entity.e_contact, let url = URL(string: "tel:" + contactNumber) {
                                Link("CALL", destination: url)
                            }
                        }
                        
                    }
                    .onDelete(perform: vm.deleteContact)
                }
                .listStyle(PlainListStyle())
                Spacer()
                
                Text("Emergency Lines")
                List{
                    Link("Police Department", destination: URL(string: "tel:911")!)
                    Link("Poison Control", destination: URL(string: "tel:1-800-222-1222")!)
                    Link("Animal Poison Control", destination: URL(string: "tel:(888)426-4435")!)
                }
                
            }
            .navigationTitle("Emergency Contacts")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}

struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactView()
    }
}
