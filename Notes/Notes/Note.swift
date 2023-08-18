//
//  Note.swift
//  Notes
//
//  Created by Tony Alhwayek on 8/18/23.
//

import UIKit

class Note: NSObject {
    var noteTitle: String
    var body: String
    var titleSet: Bool
    
    init(noteTitle: String, body: String, titleSet: Bool) {
        self.noteTitle = noteTitle
        self.body = body
        self.titleSet = titleSet
    }
}
