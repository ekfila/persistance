//
//  TableViewController.swift
//  persistance
//
//  Created by Ekaterina Stepanova on 28.09.20.
//

import UIKit

class TableViewController: UIViewController {
    
    let toDo = Persistance().realm.objects(Task.self)
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var newTask: UITextField!
        
    @IBAction func addNewTask(_ sender: Any) {
        if newTask.text == nil {
            newTask.text = ""
        }
        let newToDo = newTask.text!
        if newToDo != "" {
            Persistance().addToRealm(whatToDo: newToDo)
            newTask.text = ""
            self.table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TableViewController : UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as? TableViewCell
        
        cell!.task.text = toDo[indexPath.row].task
        cell!.realmSwitch.setOn(toDo[indexPath.row].isDone, animated: false)
        cell!.realmTask = toDo[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        Persistance().removeFromRealm(index: indexPath.row)
        self.table.deleteRows(at: [indexPath], with: .automatic)
    }

}
