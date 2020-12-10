//
//  persistance.swift
//  persistance
//
//  Created by Ekaterina Stepanova on 25.09.20.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var task = ""
    @objc dynamic var isDone = false
}

class Persistance {
    static let shared = Persistance()
    
    private let kUserNameKey = "Persistance.kUserNameKey"
    private let kUserSurnameKey = "Persistance.kUserSurnameKey"
    
    var userName: String {
        set { UserDefaults.standard.set(newValue, forKey: kUserNameKey) }
        get { return UserDefaults.standard.string(forKey: kUserNameKey) ?? "" }
    }
    
    var userSurname: String {
        set { UserDefaults.standard.set(newValue, forKey: kUserSurnameKey) }
        get { return UserDefaults.standard.string(forKey: kUserSurnameKey) ?? "" }
    }
    
    let realm = try! Realm()
            
    func addToRealm(whatToDo: String) {
        let newTask = Task()
        newTask.task = whatToDo
        newTask.isDone = false
        try! realm.write {
            self.realm.add(newTask)
        }
    }
    
    
    func removeFromRealm(index: Int) {
        let allTasks = realm.objects(Task.self)
       
        try! realm.write {
            self.realm.delete(allTasks[index])
        }
    }
    
    func changeStateRealm(task: Task) {
        try! realm.write {
            task.isDone = !task.isDone
            print("state changed")
        }
    }
    
    
    
//    func returnCurrentWeather() {
//
//    }
    
}
