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


class DetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var textView: UITextView!
    
    var noteTitle: String? {
        didSet {
            title = noteTitle
        }
    }
    
    var body: String?
    
    weak var delegate: DetailViewControllerDelegate?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if noteTitle == nil {
            askForTitle()
        }
        
        // Allow the user to edit the title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTitle))
        
        textView.delegate = self
        // Either load body, or place placeholder
        initializeTextView()
        
    }
    
    // Ask user for a title upon creating a new note
    func askForTitle() {
        let titleAC = UIAlertController(title: "Enter a title", message: nil, preferredStyle: .alert)
        titleAC.addTextField()
        
        // Grab title from text field
        let submitTitle = UIAlertAction(title: "Set title", style: .default) { [weak self, weak titleAC] _ in
            guard let title = titleAC?.textFields?[0].text else { return }
            
            self?.body = ""
            self?.setTitle(title)
            self?.saveChanges()
        }
        
        titleAC.addAction(submitTitle)
        present(titleAC, animated: true)
        
    }
    
    @objc func editTitle() {
        let titleAC = UIAlertController(title: "Enter a title", message: nil, preferredStyle: .alert)
        titleAC.addTextField()
        
        // Grab title from text field
        let submitTitle = UIAlertAction(title: "Set title", style: .default) { [weak self, weak titleAC] _ in
            guard let title = titleAC?.textFields?[0].text else { return }
            self?.setTitle(title)
            self?.saveChanges()
        }
        
        titleAC.addAction(submitTitle)
        titleAC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(titleAC, animated: true)
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
    
    // Check if body is saved and load it in
    // Else, place placeholder
    func initializeTextView() {
        if let noteBody = body, !noteBody.isEmpty {
            textView.text = noteBody
            textView.textColor = .black
        } else {
            textView.text = "Enter your note here..."
            textView.textColor = .lightGray
        }
    }
}
