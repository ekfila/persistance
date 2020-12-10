//
//  TableViewCell.swift
//  persistance
//
//  Created by Ekaterina Stepanova on 28.09.20.
//

import UIKit
import CoreData

class TableViewCell: UITableViewCell {
    
    var cdTask: NSManagedObject!
    var realmTask: Task!
    
    @IBOutlet weak var task: UILabel!

    @IBOutlet weak var realmSwitch: UISwitch!
    @IBAction func realmSwitchChanged(_ sender: Any) {
        Persistance.shared.changeStateRealm(task: realmTask)
    }
    
    @IBOutlet weak var isDoneSwitch: UISwitch!
    @IBAction func isDoneChanged(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }

          let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let isDoneValue = cdTask.value(forKey: "isDone") as! Bool
        
        cdTask.setValue(!isDoneValue, forKey: "isDone")
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save after changing switch value. \(error), \(error.userInfo)")
          }

    }
}
