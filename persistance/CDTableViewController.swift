//
//  CDTableViewController.swift
//  persistance
//
//  Created by Ekaterina Stepanova on 02.12.20.
//

import UIKit
import CoreData

class CDTableViewController: UIViewController {

    @IBOutlet weak var newTaskTextField: UITextField!
    @IBOutlet weak var cdTable: UITableView!
    
    var cdTasks: [NSManagedObject] = []
    
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
        guard container != nil else {
               fatalError("This view needs a persistent container.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "CDTask")
      
      do {
        cdTasks = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }

    
    @IBAction func addNewTask(_ sender: Any) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          let entity =
            NSEntityDescription.entity(forEntityName: "CDTask",
                                       in: managedContext)!
          
          let task = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        if newTaskTextField.text == nil {
            newTaskTextField.text = ""
        }
        let newToDo = newTaskTextField.text!
        if newToDo != "" {
            task.setValue(newToDo, forKeyPath: "cdTask")
            task.setValue(false, forKey: "isDone")
            do {
                try managedContext.save()
                cdTasks.append(task)
                //print(cdTasks)
              } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
              }
            newTaskTextField.text = ""
            self.cdTable.reloadData()
        }
    }

}

extension CDTableViewController : UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cdTasks.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell

        cell.task.text = cdTasks[indexPath.row].value(forKeyPath: "cdTask") as? String
        cell.cdTask = cdTasks[indexPath.row]
        cell.isDoneSwitch.setOn(cdTasks[indexPath.row].value(forKeyPath: "isDone") as! Bool, animated: false)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
          
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(cdTasks[indexPath.row] as NSManagedObject)
        cdTasks.remove(at: indexPath.row)
        self.cdTable.deleteRows(at: [indexPath], with: .automatic)
    }
    
}
