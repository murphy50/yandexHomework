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
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = ColorPalette.backPrimary.value
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = ColorPalette.backPrimary.value
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = toDoItem.text
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 12, right: 16)
        textView.layer.cornerRadius = 16
        textView.backgroundColor = ColorPalette.backSecondary.value
        textView.textColor = ColorPalette.labelPrimary.value
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = ColorPalette.backSecondary.value
        stackView.layer.cornerRadius = 16
        stackView.spacing = UIStackView.spacingUseSystem
        
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        stackView.addArrangedSubview(importanceView)
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
    separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator.backgroundColor = ColorPalette.separator.value
        stackView.addArrangedSubview(separator)
    
        //separator.backgroundColor = .black
        
        let separator2 = UIView()
        separator2.translatesAutoresizingMaskIntoConstraints = false
    separator2.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator2.backgroundColor = ColorPalette.separator.value
        stackView.addArrangedSubview(deadlineView)
        stackView.addArrangedSubview(separator2)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
//    func textViewDidChange(_ textView: UITextView) {
//        let size = CGSize(width: view.frame.width, height: .infinity)
//        let estimatedSize = textView.sizeThatFits(size)
//        if estimatedSize.height > textView.frame.size.height || (estimatedSize.height < textView.frame.size.height && estimatedSize.height > 120) {
//            textView.constraints.forEach { constraint in
//                if constraint.firstAttribute == .height {
//                    constraint.constant = estimatedSize.height
//                }
//            }
//        }
//    }

    @objc private func onKeyboardAppear(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = .init(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc private func onKeyboardDisappear(_ notification: Notification) {
    
            scrollView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
    }
        
    lazy var importanceView: UIView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        let label = UILabel()
        label.text = "Важность"
        
        let segmentedControl = UISegmentedControl(items: [
            UIImage(systemName: "arrow.down")!,
            "Нет",
            UIImage(systemName: "exclamationmark.2")!.withTintColor(ColorPalette.red.value, renderingMode: .alwaysOriginal),
        ])

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
        button.backgroundColor = ColorPalette.backSecondary.value
        button.setTitle("Удалить", for: .normal)
        button.layer.cornerRadius = 16
        

        button.setTitleColor(ColorPalette.red.value, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)

       // NotificationCenter.default.addo
        super.viewDidLoad()
        configureNavbar()
        view.addSubview(scrollView)
        
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(textView)
        backgroundView.addSubview(stackView)
        
        backgroundView.addSubview(deleteButton)
        configureConstraints()
        
        
//            let separator = UIView()
//            separator.translatesAutoresizingMaskIntoConstraints = false
//        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
//            separator.backgroundColor = UIColor.red
//            stackView.addArrangedSubview(separator)
//        stackView.addArrangedSubview(separator)

        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            textView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            textView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -32),
            
            stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            //separator.heightAnchor.constraint(equalToConstant: 1),
            deleteButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            deleteButton.heightAnchor.constraint(equalToConstant: 56),
            deleteButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
        ])
//
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//
//
//        scrollView.alwaysBounceVertical = true
//        scrollView.backgroundColor = UIColor(named: "backColor")
//
//
//        backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//        backgroundView.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor),
//        backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//        backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//        backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//        backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//
//        textView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
//        textView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
//        textView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
//        textView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -32),
//        textViewDidChange(textView)
//
//
//        stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
//        stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
//        stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
//
//        deleteButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16)
//        deleteButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16)
//        deleteButton.heightAnchor.constraint(equalToConstant: 56)
//        deleteButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
//
    }
}
