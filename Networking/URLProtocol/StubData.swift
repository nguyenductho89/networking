//
//  StubData.swift
//  Networking
//
//  Created by Nguyễn Đức Thọ on 1/13/20.
//  Copyright © 2020 thond. All rights reserved.
//

import Foundation

enum StubData: String {

    /// Convert to Data? type
    func asData() -> Data? {
        return rawValue.data(using: .utf8, allowLossyConversion: true)
    }

    // MARK: - Describe the stub data BELOW
    case empty = "{}"
    case maintenance = """
{
    "code": 100,
    "message": "Under Maintenance."
}
"""
    case notice = """
{
    "notice": [
        {
            "code": 100,
            "title": "Notification 1."
        },
        {
            "code": 102,
            "title": "Notification 2."
        }
    ]
}
"""
}
