//
//  AppDelegate.swift
//  DecodableNSManagedObjects
//
//  Created by Adar Hefer on 16/06/2020.
//  Copyright © 2020 Adar Hefer. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DecodableNSManagedObjects")
        container.loadPersistentStores { _, _ in }
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    static func deleteAllPhotos() -> Completable {
        let context = persistentContainer.newBackgroundContext()
        
        return .create(context) {
            let request = NSFetchRequest<PhotoMO>(entityName: PhotoMO.entity().name!)
            for photo in try context.fetch(request) {
                context.delete(photo)
            }
            try context.save()
        }
    }
    
    struct Photo: Decodable {
        let id: Int
        let albumId: Int
        let title: String
        let url: URL
        let thumbnailUrl: URL
    }

    static func getAllPhotos() -> Completable {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.overwrite
        let decoder = JSONDecoder()
        
        return getAllPhotosData()
            .map { try decoder.decode([Photo].self, from: $0) }
            .do(onSuccess: { photos in
                for photo in photos {
                    let photoMO = PhotoMO(context: context)
                    photoMO.id = Int64(photo.id)
                    photoMO.albumId = Int64(photo.albumId)
                    photoMO.title = photo.title
                    photoMO.url = photo.url
                    photoMO.thumbnailUrl = photo.thumbnailUrl
                }
                
                try context.save()
            })
            .asCompletable()
    }
    
    static func getAllPhotosData() -> Single<Data> {
        let request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/photos")!)
        
        return URLSession.shared.rx.data(request: request).asSingle()
    }
}

