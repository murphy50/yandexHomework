//
//  ViewController.swift
//  TodoApp
//
//  Created by murphy on 7/31/22.
//

import UIKit

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
        view.backgroundColor = .white
        view.addSubview(todoButton)
        todoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        todoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }


}

