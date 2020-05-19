//
//  NotificationCenter+Extensions.swift
//  Notes
//
//  Created by Azat Almeev on 22.04.2020.
//  Copyright © 2020 Azat Almeev. All rights reserved.
//

import Foundation

extension NotificationCenter {

    func addObserver(forName name: Notification.Name, queue: OperationQueue = .main, handler: @escaping ([AnyHashable : Any]) -> Void) {
        self.addObserver(forName: name, object: nil, queue: queue) { notification in
            guard let userInfo = notification.userInfo else { return }
            handler(userInfo)
        }
    }
}
