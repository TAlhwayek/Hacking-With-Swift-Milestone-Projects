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
    
    init(noteTitle: String, body: String) {
        self.noteTitle = noteTitle
        self.body = body
    }
}
