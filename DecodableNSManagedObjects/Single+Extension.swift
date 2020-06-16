//
//  Single+Extension.swift
//  CourseQuery
//
//  Created by Adar Hefer on 11/06/2020.
//  Copyright © 2020 Adar Hefer. All rights reserved.
//

import RxSwift
import CoreData

extension Single {
    static func create<T>(_ context: NSManagedObjectContext, handler: @escaping () throws -> T) -> Single<T> {
        .create { observer in
            context.perform {
                do {
                    let value = try handler()
                    observer(.success(value))
                } catch {
                    observer(.error(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
