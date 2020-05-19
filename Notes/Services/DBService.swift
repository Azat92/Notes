//
//  DBService.swift
//  Notes
//
//  Created by Azat Almeev on 29.02.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import YapDatabase

protocol DBModelProtocol: Codable {

    var key: String { get }

    static var collection: DBService.Collection { get }
}

protocol DBServiceProtocol {

    func getAllObjects<T: DBModelProtocol>() -> [T]
    func findObject<T: DBModelProtocol>(key: String) -> T?
    func setObjects<T: DBModelProtocol>(_ objects: [T], edge: DBService.ObjectEdge?)
    func removeObject<T: DBModelProtocol>(_ object: T)
}

protocol DBServiceObservableProtocol {

    func addObserver(_ observer: Any, selector: Selector)
}

extension DBServiceProtocol {

    func setObjects<T: DBModelProtocol>(_ objects: [T]) {
        self.setObjects(objects, edge: nil)
    }

    func setObject<T: DBModelProtocol>(_ object: T, edge: DBService.ObjectEdge? = nil) {
        self.setObjects([object], edge: edge)
    }
}

private extension DBService.Collection {

    var code: String {
        switch self {
        case .categories:
            return "categories"
        case .notes:
            return "notes"
        case .attachments:
            return "attachments"
        }
    }

    var edgeCode: String {
        self.code + "_edge"
    }
}

private extension DBService.ObjectEdge {

    func dbEdge<T: DBModelProtocol>(object: T) -> YapDatabaseRelationshipEdge {
        YapDatabaseRelationshipEdge(
            name: self.collection.edgeCode,
            sourceKey: self.key,
            collection: self.collection.code,
            destinationKey: object.key,
            collection: T.collection.code,
            nodeDeleteRules: .deleteDestinationIfSourceDeleted)
    }
}

final class DBService {

    enum Collection {
        case categories, notes, attachments
    }

    struct ObjectEdge {

        let collection: Collection
        let key: String
    }

    private enum Extension: String {
        case relationships
    }

    private let db: YapDatabase = {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbUrl = url.appendingPathComponent("notes.sqlite")
        let db = YapDatabase(url: dbUrl)!
        db.registerCodableSerialization(NoteCategoryDBModel.self, forCollection: Collection.categories.code)
        db.registerCodableSerialization(NoteItemDBModel.self, forCollection: Collection.notes.code)
        db.registerCodableSerialization(NoteAttachmentDBModel.self, forCollection: Collection.attachments.code)
        return db
    }()

    init() {
        self.registerRelationships()
    }
}

extension DBService: DBServiceProtocol {

    func getAllObjects<T: DBModelProtocol>() -> [T] {
        var result: [T] = []
        self.db.newConnection().read { transaction in
            transaction.iterateRows(inCollection: T.collection.code) { (_, object: T, _: Any?, _) in
                result.append(object)
            }
        }
        return result
    }

    func findObject<T: DBModelProtocol>(key: String) -> T? {
        var result: T?
        self.db.newConnection().read { transaction in
            result = transaction.object(forKey: key, inCollection: T.collection.code) as? T
        }
        return result
    }

    func setObjects<T: DBModelProtocol>(_ objects: [T], edge: DBService.ObjectEdge?) {
        self.db.newConnection().readWrite { transaction in
            objects.forEach { object in
                transaction.setObject(object, forKey: object.key, inCollection: T.collection.code)
                (edge?.dbEdge(object: object)).flatMap { edge in
                    (transaction.ext(Extension.relationships.rawValue) as? YapDatabaseRelationshipTransaction)?.add(edge)
                }
            }
        }
    }

    func removeObject<T: DBModelProtocol>(_ object: T) {
        self.db.newConnection().readWrite { transaction in
            transaction.removeObject(forKey: object.key, inCollection: T.collection.code)
        }
    }
}

extension DBService: DBServiceObservableProtocol {

    func addObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .YapDatabaseModified, object: self.db)
    }
}

extension DBService {

    private func registerRelationships() {
        self.db.register(YapDatabaseRelationship(), withName: Extension.relationships.rawValue)
    }
}
