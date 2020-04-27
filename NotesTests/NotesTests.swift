//
//  NotesTests.swift
//  NotesTests
//
//  Created by Igor Podolskiy on 30/06/2019.
//  Copyright © 2019 Igor Podolskiy. All rights reserved.
//

import XCTest
@testable import Notes

class NotesTests: XCTestCase {

    private var note: Note!
    private var notebook: FileNotebook!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        note = Note(title: "", content: "", importance: Importance.ordinary)
        notebook = FileNotebook()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoteInit() {
        XCTAssertNotNil(note)
    }

    func testParseEmptyDict() {
        XCTAssertNil(Note.parse(json: [:]))
    }

    func testFileNotebookNotebookIsEmpty() {
        XCTAssertTrue(notebook.notes.isEmpty)
    }

    func testFileNotebookAddNote() {
        notebook.add(note)
        XCTAssertEqual(notebook.notes[0].uid, note.uid)

        notebook.add(note)
        XCTAssertEqual(notebook.notes.count, 1)
    }

    func testPerformanceExample() {
    // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
