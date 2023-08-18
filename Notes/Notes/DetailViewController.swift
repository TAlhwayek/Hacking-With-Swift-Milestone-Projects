//
//  DetailViewController.swift
//  Notes
//
//  Created by Tony Alhwayek on 8/18/23.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func didUpdateNote(at indexPath: IndexPath, noteTitle newNoteTitle: String, body newBody: String, titleSet newTitleSet: Bool)
}


class DetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var textView: UITextView!
    
    var noteTitle: String? {
        didSet {
            title = noteTitle
        }
    }
    
    var body: String?
    var titleSet: Bool?
    
    weak var delegate: DetailViewControllerDelegate?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !(titleSet ?? false) {
            askForTitle()
        }
        
        
        
        
    }
    
    // Ask user for a title upon creating a new note
    func askForTitle() {
        let titleAC = UIAlertController(title: "Enter a title", message: nil, preferredStyle: .alert)
        titleAC.addTextField()
        
        // Grab title from text field
        let submitTitle = UIAlertAction(title: "Set title", style: .default) { [weak self, weak titleAC] _ in
            guard let title = titleAC?.textFields?[0].text else { return }
            
            self?.titleSet = true
            self?.body = ""
            self?.setTitle(title)
            self?.saveChanges()
        }
        
        titleAC.addAction(submitTitle)
        present(titleAC, animated: true)
        
    }
    
 
    
    func saveChanges() {
        if let indexPath = indexPath, let newNoteTitle = noteTitle, let newBody = body, let newTitleSet = titleSet {
            delegate?.didUpdateNote(at: indexPath, noteTitle: newNoteTitle, body: newBody, titleSet: newTitleSet)
            print("CHANGES SAVED")
        }
    }
    
    func setTitle(_ title: String) {
        noteTitle = title
        navigationItem.title = title
        print("TITLE SET")
    }
}
