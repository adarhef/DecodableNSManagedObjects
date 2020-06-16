//
//  ContentView.swift
//  DecodableNSManagedObjects
//
//  Created by Adar Hefer on 16/06/2020.
//  Copyright © 2020 Adar Hefer. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(entity: UserMO.entity(),
                  sortDescriptors: [.init(keyPath: \UserMO.name,
                                          ascending: true)])
    var users: FetchedResults<UserMO>
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.id) { user in
                    Text(user.name ?? "Unknown")
                }
            }
            .navigationBarTitle(Text("Users"))
            .navigationBarItems(trailing: Button(action: {
                _ = AppDelegate.getAllUsers(context: self.moc).subscribe()
            }, label: { Text("Get All") }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        return ContentView().environment(\.managedObjectContext, context)
    }
}
