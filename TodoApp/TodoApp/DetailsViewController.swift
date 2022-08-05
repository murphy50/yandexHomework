//
//  DetailsViewController.swift
//  TodoApp
//
//  Created by murphy on 7/31/22.
//

import UIKit

class DetailsViewController: UIViewController, UITextViewDelegate {
    
    var toDoItem = fileCache.todoItems["12"]!
    
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
        backgroundView.backgroundColor = UIColor(named: "backColor")
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    lazy var separator: UIView = {
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        separator.backgroundColor = .black
        return separator
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 16
        stackView.spacing = UIStackView.spacingUseSystem
        
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        stackView.addArrangedSubview(importanceView)
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 5))
        separator.backgroundColor = .black
        stackView.addArrangedSubview(separator)
        
        stackView.addArrangedSubview(deadlineView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = toDoItem.text
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.layer.cornerRadius = 16
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
        
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(with: UIImage(systemName: "arrow.down"), at: 0, animated: true)
        segmentedControl.insertSegment(with: "Нет".image(), at: 1, animated: true)
        segmentedControl.insertSegment(with: UIImage(systemName: "exclamationmark.2"), at: 2, animated: true)
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(segmentedControl)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        return stackView
    }()
    
    @objc func switchValueDidChange(target: UISwitch) {
        if target.isOn {
            calendar.isHidden = false
            stackView.addArrangedSubview(calendar)
            
        } else {
            UIView.animate(withDuration: 1.0,
                           delay: 0.0,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 1,
                           animations: {
                self.calendar.isHidden = true
            })
        }
    }
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
        mySwitch.addTarget(self, action: #selector(switchValueDidChange(target:)), for: .valueChanged)
        
        stackView.addArrangedSubview(verticalStack)
        stackView.addArrangedSubview(mySwitch)
        return stackView
    }()
    
    
    lazy var calendar: UIDatePicker = {
        let calendar = UIDatePicker()
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .inline
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.widthAnchor.constraint(equalToConstant: 343).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 332).isActive = true
        return calendar
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Удалить", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .white
        button.setTitleColor(UIColor(named: "buttonRed"), for: .normal)
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
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(textView)
        backgroundView.addSubview(stackView)
        
        backgroundView.addSubview(deleteButton)
        configureConstraints()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        
    }
    
    func configureConstraints() {
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = UIColor(named: "backColor")
        
        backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        textView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16).isActive = true
        textView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16).isActive = true
        textView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16).isActive = true
        textView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -32).isActive = true
        textViewDidChange(textView)
        
        stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
        
    }
}
