//
//  ViewController.swift
//  TodoApp
//
//  Created by murphy on 7/31/22.
//

import UIKit
var fileCache = FileCache()

class ViewController: UIViewController {
    
    private lazy var todoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.layer.cornerRadius = 16
        button.setTitle("Create Todo", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(openDetailsViewContorller), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func openDetailsViewContorller() {
        let vc = UINavigationController(rootViewController: DetailsViewController())
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var contents = ""
        if let filepath = Bundle.main.path(forResource: "testTodoInput", ofType: "json") {
            do {
                contents = try String(contentsOfFile: filepath)
            } catch {
                print("contents could not be loaded")
            }
        } else {
            print("test file not found")
        }
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("testTodoInput.json")
            do {
                try contents.write(to: fileURL, atomically: false, encoding: .utf8)
                fileCache.load(from: "testTodoInput.json")
            } catch {
                
            }
        }
        
        view.backgroundColor = .white
        view.addSubview(todoButton)
        todoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        todoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        todoButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        todoButton.heightAnchor.constraint(equalToConstant: 150).isActive = true

    }
}
