//
//  Routine.swift
//  Dding
//
//  Created by 이지은 on 11/23/24.
//

import Foundation
import FirebaseFirestore
import UIKit

enum TagColor: String, CaseIterable, Codable {
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
    case pink
    case brown
    case gray
    case black
    
    var color: UIColor {
        switch self {
        case .red: return .systemRed
        case .orange: return .systemOrange
        case .yellow: return .systemYellow
        case .green: return .systemGreen
        case .blue: return UIColor(red: 0.0/255.0, green: 114.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        case .purple: return .systemPurple
        case .pink: return UIColor.systemPink
        case .brown: return UIColor.brown
        case .gray: return UIColor(red: 151.0/255.0, green: 153.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        case .black: return .black
        }
    }
}
struct RoutineItem: Codable {
    let id: String
    var title: String
    var tag: TagColor
    var repeatDays: [Int]
    var routineTime: DateComponents
    var isCompleted: Bool
    var reminderTime: Int
    var completionCheckTime: Int
    var memo: String?
    let createdAt: Date?
    var updatedAt: Date?
    var isFixed: Bool
    
    // MARK: - 초기화 메서드
    init(
        id: String = UUID().uuidString,
        title: String,
        tag: TagColor,
        repeatDays: [Int],
        routineTime: DateComponents,
        isCompleted: Bool,
        reminderTime: Int,
        completionCheckTime: Int,
        memo: String? = nil,
        isFixed: Bool = false,
        createdAt: Date? = Date(),
        updatedAt: Date? = Date()
    ) {
        self.id = id
        self.title = title
        self.tag = tag
        self.repeatDays = repeatDays
        self.routineTime = routineTime
        self.isCompleted = isCompleted
        self.reminderTime = reminderTime
        self.completionCheckTime = completionCheckTime
        self.memo = memo
        self.isFixed = isFixed
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // MARK: - Firebase에서 데이터 가져오기
    init?(from dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let title = dictionary["title"] as? String,
            let tagRawValue = dictionary["tag"] as? String,
            let tag = TagColor(rawValue: tagRawValue),
            let repeatDays = dictionary["repeatDays"] as? [Int],
            let routineTimeData = dictionary["routineTime"] as? [String: Int],
            let isCompleted = dictionary["isCompleted"] as? Bool,
            let reminderTime = dictionary["reminderTime"] as? Int,
            let completionCheckTime = dictionary["completionCheckTime"] as? Int,
            let createdAt = (dictionary["createdAt"] as? Timestamp)?.dateValue(),
            let updatedAt = (dictionary["updatedAt"] as? Timestamp)?.dateValue()
        else {
            return nil
        }
        
        let routineTime = DateComponents(
            hour: routineTimeData["hour"],
            minute: routineTimeData["minute"]
        )
        
        self.id = id
        self.title = title
        self.tag = tag
        self.repeatDays = repeatDays
        self.routineTime = routineTime
        self.isCompleted = isCompleted
        self.reminderTime = reminderTime
        self.completionCheckTime = completionCheckTime
        self.memo = dictionary["memo"] as? String
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isFixed = dictionary["isFixed"] as? Bool ?? false
    }
    
    // MARK: - Firebase로 저장하기 위한 변환
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "id": id,
            "title": title,
            "tag": tag.rawValue,
            "repeatDays": repeatDays,
            "routineTime": [
                "hour": routineTime.hour ?? 0,
                "minute": routineTime.minute ?? 0
            ],
            "isCompleted": isCompleted,
            "reminderTime": reminderTime,
            "completionCheckTime": completionCheckTime,
            "createdAt": Timestamp(date: createdAt ?? Date()),
            "updatedAt": Timestamp(date: updatedAt ?? Date()),
            "isFixed": isFixed
        ]
        
        if let memo = memo {
            dictionary["memo"] = memo
        }
        
        return dictionary
    }
}
