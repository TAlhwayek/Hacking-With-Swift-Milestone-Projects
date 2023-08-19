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
        
        // Set background color to a color similar to a sticky note's color
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 204.0/255.0, alpha: 1.0)
        title = "Notes"
        
        // Create a new note
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        
        loadFromJSON()
    }
    
    // Show needed number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    // Display titles in rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        let note = notesList[indexPath.row]
        // Make the cell the same color as the background
        cell.backgroundColor = UIColor(red: 1, green: 1, blue: 204.0/255.0, alpha: 1.0)
        cell.textLabel?.text = note.noteTitle
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        cell.detailTextLabel?.numberOfLines = 1
        cell.detailTextLabel?.text = note.body
        return cell
    }
    
    // When a row is selected
    // Send data from array to detailVC
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
        saveToJSON()
    }
    
    // Delete note by swiping on it
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notesList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveToJSON()
        }
    }
    
    //MARK: - Functions that save/load stored data
    
    // Save notes
    func saveToJSON() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(notesList) {
            if let notesJSON = String(data: encoded, encoding: .utf8) {
                // Save the notesJSON string to a file
                let jsonURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("notes.json")
                do {
                    try notesJSON.write(to: jsonURL, atomically: true, encoding: .utf8)
                    // Data has been saved to "notes.json"
                } catch {
                    print("Error saving JSON to file: \(error)")
                }
            }
        }
    }
    
    // Load saved notes
    func loadFromJSON() {
        let jsonURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("notes.json")
        if let jsonData = try? Data(contentsOf: jsonURL) {
            let decoder = JSONDecoder()
            if let decodedNotesList = try? decoder.decode([Note].self, from: jsonData) {
                notesList = decodedNotesList
            } else {
                print("Error decoding JSON data")
            }
        } else {
            print("Error loading JSON data from file")
        }
    }
}
