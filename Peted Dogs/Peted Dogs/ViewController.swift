//
//  ViewController.swift
//  Peted Dogs
//
//  Created by Marina Lima on 19/08/20.
//  Copyright © 2020 Marina Lima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dogs: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        title = "Carinho nos Doguinhos"
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Novo Carinho", message: "Digite o nome do Doguinho", preferredStyle: .alert)
          
         let saveAction = UIAlertAction(title: "Salvar", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
              let nameToSave = textField.text else {
                return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
          }
          
          let cancelAction = UIAlertAction(title: "Cancelar",
                                           style: .cancel)
          
          alert.addTextField()
          
          alert.addAction(saveAction)
          alert.addAction(cancelAction)
          
          present(alert, animated: true)
        
    }
    
    func save(name: String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "Doguinho", in: managedContext)!
      
      let doguinho = NSManagedObject(entity: entity, insertInto: managedContext)
      
      // 3
      doguinho.setValue(name, forKeyPath: "name")
      
      // 4
      do {
        try managedContext.save()
        dogs.append(doguinho)
      } catch let error as NSError {
        print("Não foi possível salvar :( \(error), \(error.userInfo)")
      }
    }
    
    // MARK: - Fetching from Core Data
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Doguinho")
      
      //3
      do {
        dogs = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    
}

// MARK: - UITableViewDataSource
    extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
      return dogs.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
                   -> UITableViewCell {

      let doguinho = dogs[indexPath.row]
      let cell =
        tableView.dequeueReusableCell(withIdentifier: "Cell",
                                      for: indexPath)
      cell.textLabel?.text =
        doguinho.value(forKeyPath: "name") as? String
      return cell
    }
    }

    import CoreData

