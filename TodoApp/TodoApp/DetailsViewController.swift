//
//  DetailsViewController.swift
//  TodoApp
//
//  Created by murphy on 7/31/22.
//

import UIKit
protocol DetailsViewControllerDelegate: AnyObject {
    func ToDoItemCreated(model: TodoItem, beingDeleted: Bool)
}
final class DetailsViewController: UIViewController, UITextViewDelegate {
    
    weak var delegate: DetailsViewControllerDelegate?
    var beingDeleted = false
    // MARK: -  Navitgation Bar
    private func configureNavbar() {
        navigationItem.title = "Задание"
        let leftBarButton = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: #selector(cancelCreationToDoItem))
        let rightBarButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveToDoItem))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func saveToDoItem() {
        textViewDidEndEditing(textView)
        delegate?.ToDoItemCreated(model: model, beingDeleted: beingDeleted)
        
        navigationController?.dismiss(animated: true)
        
    }
    
    @objc func cancelCreationToDoItem() {
        navigationController?.dismiss(animated: true)
    }
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = ColorPalette.backPrimary.color
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = ColorPalette.backPrimary.color
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    // MARK: - TextView & textView methods
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 12, right: 16)
        textView.layer.cornerRadius = 16
        textView.backgroundColor = ColorPalette.backSecondary.color
        textView.textColor = ColorPalette.labelPrimary.color
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == ColorPalette.tertiary.color {
            textView.text = nil
            textView.textColor = ColorPalette.labelPrimary.color
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = ColorPalette.tertiary.color
        }
        model = TodoItem(id: model.id,
                         text: textView.text,
                         importance: model.importance,
                         deadline: model.deadline,
                         done: model.done,
                         color: model.color,
                         creationDate: model.creationDate,
                         changeDate: model.changeDate)
    }
    
    @objc private func onKeyboardAppear(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = .init(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc private func onKeyboardDisappear(_ notification: Notification) {
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = ColorPalette.backSecondary.color
        stackView.layer.cornerRadius = 16
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.addArrangedSubview(importanceView)
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator.backgroundColor = ColorPalette.separator.color
        stackView.addArrangedSubview(separator)
        
        let separator2 = UIView()
        separator2.translatesAutoresizingMaskIntoConstraints = false
        separator2.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator2.backgroundColor = ColorPalette.separator.color
        stackView.addArrangedSubview(deadlineView)
        stackView.addArrangedSubview(separator2)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var model: TodoItem
    
    func configure(with model: TodoItem) {
        set(with: model.importance)
        set(with: model.text)
        set(with: model.deadline)
    }
    
    init(with model: TodoItem)   {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configure(with: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
            UIImage(systemName: "arrow.down")!,
            "Нет",
            UIImage(systemName: "exclamationmark.2")!.withTintColor(ColorPalette.red.color, renderingMode: .alwaysOriginal),
        ])
        segmentedControl.selectedSegmentIndex = 1
        
        return segmentedControl
    }()
    
    
    lazy var importanceView: UIView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        let label = UILabel()
        label.text = "Важность"
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(segmentedControl)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        return stackView
    }()
    
    @objc func switchValueDidChange(target: UISwitch) {
        if target.isOn {
            calendar.isHidden = false
            self.calendar.alpha = 1.0
            stackView.addArrangedSubview(calendar)
            
        } else {
            UIView.animate(withDuration: 0.3,
                           animations: {
                self.calendar.alpha = 0
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
        calendar.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        calendar.widthAnchor.constraint(equalToConstant: 343).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 332).isActive = true
        return calendar
    }()
    
    @objc func dateChanged() {
        model = TodoItem(id: model.id,
                         text: model.text,
                         importance: model.importance,
                         deadline: calendar.date,
                         done: model.done,
                         color: model.color,
                         creationDate: model.creationDate,
                         changeDate: model.changeDate)
    }
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorPalette.backSecondary.color
        button.setTitle("Удалить", for: .normal)
        button.layer.cornerRadius = 16
        
        
        button.setTitleColor(ColorPalette.red.color, for: .normal)
        button.addTarget(self, action: #selector(deleteToDoItem), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func deleteToDoItem() {
        delegate?.ToDoItemCreated(model: model, beingDeleted: true)
        navigationController?.dismiss(animated: true)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        super.viewDidLoad()
        configureNavbar()
        view.addSubview(scrollView)
        
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(textView)
        backgroundView.addSubview(stackView)
        
        backgroundView.addSubview(deleteButton)
        configureConstraints()
        textViewDidChange(textView)
        textViewDidEndEditing(textView)
        
        
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
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 140),
            stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            deleteButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            deleteButton.heightAnchor.constraint(equalToConstant: 56),
            deleteButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
        ])
    }
}

private extension DetailsViewController {
    
    
    func set(with importance: TodoItem.Importance) {
        switch importance {
        case .important:
            segmentedControl.selectedSegmentIndex = 2
        case .low:
            segmentedControl.selectedSegmentIndex = 0
        case .basic:
            segmentedControl.selectedSegmentIndex = 1
        }
    }
    
    func set(with text: String) {
        textView.text = text
    }
    func set(with deadline: Date?) {
        guard let deadline = deadline else { return }
        calendar.date = deadline
    }
}
