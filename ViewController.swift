//
//  ViewController.swift
//  6MarCoreData
//
//  Created by Appinventiv-PC on 06/03/18.
//  Copyright © 2018 Appinventiv-PC. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController{
    // Mark :- Properties
    var  currentIndex:Int=0
    var people: [NSManagedObject] = []
    // Mark :- Mark Outlets
    @IBOutlet weak var AddName: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    // Mark :- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "Cell")
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "StoreData")
        do {
            people = try managedContext.fetch(fetchRequest)
            }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // Mark :- Delete button
    @IBAction func deleteButton(_ sender: UIButton) {
        let user1 = people[currentIndex]
      people.remove(at: currentIndex)
         managedContext.delete(user1)
        self.tableView.reloadData()
        do
        {
            try managedContext.save()
            
        } catch let error as NSError
        {            print("Could not update. \(error), \(error.userInfo)")        }
    }
   
    // Mark :- ADD button
    @IBAction func Buttontapped(_ sender: UIBarButtonItem)
    {
        
         let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
         let saveAction = UIAlertAction(title: "Save", style: .default)
           {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
            
           }
                  let cancelAction = UIAlertAction(title: "Cancel", style: .default)
                         alert.addTextField()
        
                 alert.addAction(saveAction)
                  alert.addAction(cancelAction)
        
        present(alert, animated: true)
     }

    
    @IBAction func updateButton(_ sender: UIButton) {
     let user1 = people[currentIndex]
    }
    func save(name: String)
    {
                guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else
        { return }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "StoreData" ,in: managedContext)!
        let person = NSManagedObject(entity: entity,insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        do {
            try managedContext.save()
            self.people.append(person)
            }
          catch let error as NSError
        {
             print("Could not save. \(error), \(error.userInfo)")
        }
          }
}

// Mark :- Tableview Extension
extension ViewController : UITableViewDelegate,UITableViewDataSource
{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return people.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell",
                                          for: indexPath)
        cell.textLabel?.text =
            person.value(forKeyPath: "name") as? String
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
    }
}

