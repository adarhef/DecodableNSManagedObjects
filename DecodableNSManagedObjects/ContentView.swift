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
    @FetchRequest(entity: PhotoMO.entity(),
                  sortDescriptors: [.init(keyPath: \PhotoMO.albumId,
                                          ascending: true)])
    var photos: FetchedResults<PhotoMO>
        
    var body: some View {
        NavigationView {
            List {
                ForEach(photos, id: \.id) { photo in
                    Text(photo.title)
                }
            }
            .navigationBarTitle(Text("Photos"))
            .navigationBarItems(leading: Button(action: {
                _ = AppDelegate.deleteAllPhotos().subscribe()
            }, label: { Text("Delete All") }),
                                trailing: Button(action: {
                let start = CFAbsoluteTimeGetCurrent()
                
                _ = AppDelegate.getAllPhotos()
                    .subscribe(onCompleted: {
                        let elapsed = CFAbsoluteTimeGetCurrent() - start
                        print("Storing Photos took \(elapsed) seconds")
                    })
            }, label: { Text("Get All") }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = AppDelegate.persistentContainer.viewContext
        
        return ContentView().environment(\.managedObjectContext, context)
    }
}
