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
        
        // Set background color to a color similar to a sticky note's color
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 204.0/255.0, alpha: 1.0)
        // Also set the text view's background color
        textView.backgroundColor = UIColor(red: 1, green: 1, blue: 204.0/255.0, alpha: 1.0)
        
        if noteTitle == nil {
            askForTitle()
        }
        
        // Observers to fix keyboard alignment with text
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)

        
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
    
    // When the edit button is pressed, allowing the user to edit the note's title
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
    
    // Let the keybaord keep up with scrolling text editor
    @objc func adjustForKeyboard(notification: Notification) {
        // Get size of keyboard
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        // Scroll to where user is typing
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}
