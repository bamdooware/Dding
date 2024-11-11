//
//  TodoItem.swift
//  Dding
//
//  Created by 이지은 on 9/30/24.
//

import Foundation

struct TodoItem {
    let id: UUID
    var title: String
    var repeatDays: [Int]
    var todoTime: DateComponents
    var isCompleted: Bool
    var reminderTime: Int
    var completionCheckTime: Int
    var tag: String
    var memo: String
}
