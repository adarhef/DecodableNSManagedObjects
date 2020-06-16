//
//  Completable+Extension.swift
//  CourseQuery
//
//  Created by Adar Hefer on 11/06/2020.
//  Copyright © 2020 Adar Hefer. All rights reserved.
//

import RxSwift
import CoreData

extension Completable {
    static func create(_ context: NSManagedObjectContext, handler: @escaping () throws -> Void) -> Completable {
        .create { observer in
            context.perform {
                do {
                    try handler()
                    observer(.completed)
                } catch {
                    observer(.error(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
