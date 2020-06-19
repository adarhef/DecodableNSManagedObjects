//
//  UserMO.swift
//  DecodableNSManagedObjects
//
//  Created by Adar Hefer on 19/06/2020.
//  Copyright © 2020 Adar Hefer. All rights reserved.
//

import CoreData

@objc(UserMO)
class UserMO: NSManagedObject, Decodable {
    
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var email: String

    enum CodingKeys: CodingKey {
        case id
        case name
        case email
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext
            else { fatalError() }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

