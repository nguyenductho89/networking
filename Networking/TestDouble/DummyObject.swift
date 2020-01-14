//
//  DummyObject.swift
//  NetworkingTests
//
//  Created by Nguyễn Đức Thọ on 1/13/20.
//  Copyright © 2020 thond. All rights reserved.
//

import XCTest

protocol SaverProtocol {
    func save(value: Float)
}

class Square {

    private let saver: SaverProtocol

    var side: Float = 0
    var area: Float {
        return pow(self.side, 2)
    }

    init(saver: SaverProtocol) {
        self.saver = saver
    }

    func saveArea() {
        saver.save(value: area)
    }
}

class DummyObject: XCTestCase {

        func test_Area() {
            let sut = Square(saver: DummySaver())

            sut.side = 5

            XCTAssertEqual(sut.area, 25)
        }

        class DummySaver: SaverProtocol {
            func save(value: Float) { }
        }
}
