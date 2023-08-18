//
//  ViewController.swift
//  Notes
//
//  Created by Tony Alhwayek on 8/18/23.
//

import UIKit

class ViewController: UITableViewController, DetailViewControllerDelegate {
    
    
    // Array to store the created notes
    var notesList = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        
        // Create a new note
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        let note = notesList[indexPath.row]
        cell.textLabel?.text = note.noteTitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailViewController {
            let note = notesList[indexPath.row]
            detailVC.delegate = self
            detailVC.noteTitle = note.noteTitle
            detailVC.body = note.body
            detailVC.indexPath = indexPath
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // Create a new note
    @objc func addNote() {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailViewController {
            let note = Note(noteTitle: "", body: "")
            navigationController?.pushViewController(detailVC, animated: true)
            notesList.append(note)
            detailVC.delegate = self
            detailVC.indexPath = IndexPath(row: notesList.count - 1, section: 0)
            tableView.reloadData()
        }
    }
    
    // When note is updated in detailVC
    func didUpdateNote(at indexPath: IndexPath, noteTitle newNoteTitle: String, body newBody: String) {
        notesList[indexPath.row].noteTitle = newNoteTitle
        notesList[indexPath.row].body = newBody
        tableView.reloadData()
    }
}

// TODO:
// Save notes
// Allow note deletion by swiping on it in the table

