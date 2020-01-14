//
//  Fake.swift
//  NetworkingTests
//
//  Created by Nguyễn Đức Thọ on 1/13/20.
//  Copyright © 2020 thond. All rights reserved.
//

import XCTest

struct User {
    let identifier: String
    let username: String
}

protocol UsersServiceProtocol {
    func fetchUsers() -> [User]
}

class UsersService: UsersServiceProtocol {
    func fetchUsers() -> [User] {
        let users = [User(identifier: "tho", username: "thond")]// execute a query in a Database
        return users
    }
}

class UsersRepo {

    private let users: [User]

    init(usersService: UsersServiceProtocol) {
        self.users = usersService.fetchUsers()
    }

    func usersCountMessage() -> String {
        return "Number of users in the system: \(users.count)"
    }
}
class Fake: XCTestCase {

    func test_UsersCountMessage() {
        let sut = UsersRepo(usersService: FakeUsersService())

        XCTAssertEqual(sut.usersCountMessage(), "Number of users in the system: 2")
    }

    class FakeUsersService: UsersServiceProtocol {
        func fetchUsers() -> [User] {
            return [User(identifier: "1", username: "user01"), User(identifier: "2", username: "user02")]
        }
    }

}

class Stub: XCTestCase {
    
    func test_usersCountMessage_returnsRightValue() {
        let stubUsersService = StubUsersService()
        stubUsersService.forcedUsersResult = [User(identifier: "1230-4444", username: "Test")]
        let sut = UsersRepo(usersService: stubUsersService)

        XCTAssertEqual(sut.usersCountMessage(), "Number of users in the system: 1")
    }

    class StubUsersService: UsersServiceProtocol {

        var forcedUsersResult: [User]!

        func fetchUsers() -> [User] {
            return forcedUsersResult
        }
    }
}

class Spy: XCTestCase {
    
    func test_SaveArea() {
        let saver = SpySaver()
        let sut = Square(saver: saver)
        sut.side = 5

        sut.saveArea()

        XCTAssertEqual(saver.saveCallsCount, 1)
        XCTAssertEqual(saver.saveValue, 25)
    }

    class SpySaver: SaverProtocol {
        var saveCallsCount = 0
        var saveValue: Float?

        func save(value: Float) {
            saveCallsCount += 1
            saveValue = value
        }
    }
}

class MockTest: XCTestCase {
    
    func test_SaveArea() {
        let saver = MockSaver()
        let sut = Square(saver: saver)
        sut.side = 5

        sut.saveArea()

        saver.verify(saveCallsCount: 1, saveValue: 25)
    }

    class MockSaver: SaverProtocol {
        private var saveCallsCount = 0
        private var saveValue: Float?

        func save(value: Float) {
            saveCallsCount += 1
            saveValue = value
        }

        func verify(saveCallsCount: Int, saveValue: Float) {
            XCTAssertEqual(self.saveCallsCount, saveCallsCount)
            XCTAssertEqual(self.saveValue, saveValue)
        }
    }
}
