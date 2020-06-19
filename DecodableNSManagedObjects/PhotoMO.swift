//
//  PhotoMO.swift
//  DecodableNSManagedObjects
//
//  Created by Adar Hefer on 19/06/2020.
//  Copyright © 2020 Adar Hefer. All rights reserved.
//

import CoreData

@objc(PhotoMO)
class PhotoMO: NSManagedObject, Decodable {
    
    @NSManaged var id: Int
    @NSManaged var albumId: Int
    @NSManaged var title: String
    @NSManaged var url: URL
    @NSManaged var thumbnailUrl: URL

    enum CodingKeys: CodingKey {
        case id
        case albumId
        case title
        case url
        case thumbnailUrl
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext
            else { fatalError() }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        albumId = try container.decode(Int.self, forKey: .albumId)
        title = try container.decode(String.self, forKey: .title)
        url = try container.decode(URL.self, forKey: .url)
        thumbnailUrl = try container.decode(URL.self, forKey: .thumbnailUrl)
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

