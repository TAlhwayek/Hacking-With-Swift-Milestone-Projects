//
//  DetailViewController.swift
//  Notes
//
//  Created by Tony Alhwayek on 8/18/23.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func didUpdateNote(at indexPath: IndexPath, noteTitle newNoteTitle: String, body newBody: String)
}


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if title was already set,
        // Else ask for new title
        if noteTitle == nil {
            askForTitle()
        }

        
        textView.delegate = self
        // Either load body, or place placeholder
        initializeTextView()
        
    }
    
    
 
    // Save all changes
    func saveChanges() {
        if let indexPath = indexPath, let newNoteTitle = noteTitle, let newBody = body {
            delegate?.didUpdateNote(at: indexPath, noteTitle: newNoteTitle, body: newBody)
            print("CHANGES SAVED")
        }
    }
    
    // Called when user inputs/changes title
    func setTitle(_ title: String) {
        noteTitle = title
        navigationItem.title = title
    }
    
    //MARK: - Text View Functions
     
     // Change font color back to black and clear placeholder when note is being edited
     func textViewDidBeginEditing(_ textView: UITextView) {
         if textView.text == "Enter your note here..." {
             textView.text = ""
             textView.textColor = UIColor.black
         }
     }

     // Save body text when user is done
     func textViewDidEndEditing(_ textView: UITextView) {
             body = textView.text
             saveChanges()
     }
     
    // Check if body is saved and load it in,
    // Else place placeholder text
    func initializeTextView() {
        if let noteBody = body, !noteBody.isEmpty {
            textView.text = noteBody
            textView.textColor = .black
        } else {
            textView.text = "Enter your note here..."
            textView.textColor = .lightGray
        }
    }
