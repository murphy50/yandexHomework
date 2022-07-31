//
//  DetailsViewController.swift
//  TodoApp
//
//  Created by murphy on 7/31/22.
//

import UIKit

class DetailsViewController: UIViewController, UITextViewDelegate {

    private func configureNavbar() {
        navigationItem.title = "Задание"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: nil)
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        //backgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        backgroundView.backgroundColor = UIColor(named: "backColor")
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .yellow
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 16
        textView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        textView.backgroundColor = .white
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        if estimatedSize.height > textView.frame.size.height || (estimatedSize.height < textView.frame.size.height && estimatedSize.height > 120) {
            textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    
    @objc private func onKeyboardAppear(_ notification: Notification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                scrollView.contentInset = .init(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            }
        }

    lazy var importanceView: UIView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        let label = UILabel()
        label.text = "Важность"
        let segmentedControl = UISegmentedControl(items: ["low", "medium", "high"])
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(segmentedControl)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var deadlineView: UIView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        
        let label = UILabel()
        label.text = "Дедлайн"
        let dateLabel = UILabel()
        
        verticalStack.addArrangedSubview(label)
        verticalStack.addArrangedSubview(dateLabel)
        let mySwitch = UISwitch()
        
        
        stackView.addArrangedSubview(verticalStack)
        stackView.addArrangedSubview(mySwitch)
        return stackView
    }()
    
    lazy var calendar: UIDatePicker = {
        let calendar = UIDatePicker()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.titleLabel?.text = "Удалить"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }

    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        super.viewDidLoad()
        configureNavbar()
        view.addSubview(scrollView)
       // scrollView.backgroundColor = UIColor(named: "backColor")
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(textView)
        backgroundView.addSubview(stackView)
        //scrollView.addSubview(textView)
//        textView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)

//
       // scrollView.addSubview(deleteButton)
//       backgroundView.addSubview(stackView)
        stackView.addArrangedSubview(importanceView)
        stackView.addArrangedSubview(deadlineView)
//        scrollView.addSubview(deleteButton)
//        stackView.addArrangedSubview(calendar)
//        calendar.isHidden = false
//        scrollView.addSubview(deleteButton)
        backgroundView.addSubview(deleteButton)
        configureConstraints()
  
    }
    
    func configureConstraints() {
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .red
        
        backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        //backgroundView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//
        textView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 72).isActive = true
        textView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16).isActive = true
        textView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16).isActive = true
        textView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        //
        stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16).isActive = true
        //stackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 112).isActive = true
//
//
//////        //stackView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor).isActive = true
//////
////
       // deleteButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        deleteButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16).isActive = true
        deleteButton.tintColor = .brown

    }

}
