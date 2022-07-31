//
//  ViewController.swift
//  ToDo2
//
//  Created by murphy on 7/30/22.
//

import UIKit


class ViewController : UIViewController, UITextViewDelegate {
    
    private func configureNavbar() {
        navigationItem.title = "Задание"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: nil)
    }
 
    // 1.
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .yellow
        // stackView.spacing = 50
            
        return stackView
    }()
    
    // 2.
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 16
        textView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        textView.backgroundColor = .white
        textView.isScrollEnabled = false
        textView.delegate = self
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
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        backgroundView.backgroundColor = UIColor(named: "backColor")
        return backgroundView
    }()
    lazy var importanceView: UIView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        let label = UILabel()
        label.text = "Важность"
        let segmentedControl = UISegmentedControl(items: ["low", "medium", "high"])
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(segmentedControl)
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
        return calendar
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.titleLabel?.text = "Удалить"
        return button
    }()
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        textView.resignFirstResponder()
//
//    }
    @objc func updateTextView(_ notification: Notification) {
        let userInfo = notification.userInfo

        let getKeyboardRect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrame = self.view.convert(getKeyboardRect, to: scrollView.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height / 4, right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        textView.scrollRangeToVisible(textView.selectedRange)

    }
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: Keyboard
//
//    @objc func keyboardWillShow(sender: NSNotification) {
//            guard let userInfo = sender.userInfo,
//                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
//                  let currentTextView = UIResponder.currentFirst() as? UITextView else { return }
//
//            print("foo - userInfo: \(userInfo)")
//            print("foo - keyboardFrame: \(keyboardFrame)")
//            print("foo - currentTextField: \(currentTextView)")
//        }
//
//        @objc func keyboardWillHide(notification: NSNotification) {
//            view.frame.origin.y = 0
//        }
    
//    private func setupKeyboardHiding() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    // MARK: Keyboard
//
//        @objc func keyboardWillShow(sender: NSNotification) {
//            scrollView.frame.origin.y = scrollView.frame.origin.y - 200
//        }
//
//        @objc func keyboardWillHide(notification: NSNotification) {
//            scrollView.frame.origin.y = 0
//        }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHiding()
        configureNavbar()
        //        let view = UIView()
        //        view.backgroundColor = .white
        //
        // 3.
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(textView)
        backgroundView.addSubview(stackView)
        stackView.addArrangedSubview(importanceView)
        stackView.addArrangedSubview(deadlineView)
        stackView.addArrangedSubview(calendar)
        calendar.isHidden = false
        backgroundView.addSubview(deleteButton)


        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = true
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        // backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        // backgroundView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        //scrollView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 72).isActive = true
        textView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16).isActive = true
        textView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        //textView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16).isActive = true
        //stackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 112).isActive = true
//        //stackView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor).isActive = true
//
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 16).isActive = true
//
        //setupKeyboardHiding()
            //        stackView.spacing = UIStackView.spacingUseSystem
        //        stackView.layer.cornerRadius = 16
        //        stackView.backgroundColor = .white
        //        stackView.isLayoutMarginsRelativeArrangement = true
        //        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        // 5.
        //        for _ in 0..<20 {
        //            let circle = UIView()
        //            circle.translatesAutoresizingMaskIntoConstraints = true
        //            circle.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //            circle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //            circle.backgroundColor = .gray
        //            circle.layer.cornerRadius = 24
        //
        //            stackView.addArrangedSubview(circle)
        //        }
        
        
        
        //self.view = view
    }
}
//class ViewController: UIViewController {
//    private  var scrollView: UIScrollView = {
//        var scrollView = UIScrollView()
//        scrollView.backgroundColor = .systemGray
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        return scrollView
//    }()
//
////    override func loadView() {
////        self.view = UIView()
////    }
//
//    private  var textView: UITextView = {
//        var textView = UITextView()
//
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.frame = CGRect(x: 10, y: 10, width: 300, height: 400)
//        textView.backgroundColor = .yellow
//        return textView
//    }()
//
//    private var deleteButton: UIButton = {
//        var button = UIButton()
//        button.backgroundColor = .blue
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(scrollView)
//        scrollView.addSubview(textView)
//        scrollView.addSubview(deleteButton)
//        //scrollView.contentSize = .init(width: view.bounds.width, height: view.bounds.height * 2)
//        configureConstraints()
//
//    }
//
//    func configureConstraints() {
//        let scrollViewContraints = [
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ]
//        let textViewConstraints = [
//            textView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
//            textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
//            textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
//            textView.heightAnchor.constraint(equalToConstant: 50)
//        ]
//        let buttonConstraints = [
//            deleteButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 100),
//            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ]
//        NSLayoutConstraint.activate(scrollViewContraints)
//        NSLayoutConstraint.activate(textViewConstraints)
//        NSLayoutConstraint.activate(buttonConstraints)
//        ],
//        let stackViewContraints = [
//        ]
//   }
//    private func setupScrollView() {
//        let colors: [UIColor] = [
//            .systemMint,
//            .systemBlue,
//            .systemRed,
//            .systemCyan,
//            .systemPink,
//            .systemTeal
//        ]
//
//
//        var stackView = UIStackView()
//
//        var textView = UITextView()
//        textView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 300)
//        textView.backgroundColor = .brown
//        textView.text = "Some text"
//
//        var label
//        stackView.addSubview(textView)
//        var y: CGFloat = 0
//        let height: CGFloat = 200
//
//
////        for color in colors {
////            let view = UIView()
////            view.backgroundColor = color
////            view.frame = .init(x: 0, y: y, width: scrollView.bounds.width, height: height)
////            stackView.addSubview(view)
////            y += height
////        }
//        scrollView.addSubview(stackView)
//        scrollView.contentSize = .init(width: scrollView.bounds.width,
//                                       height: y + 1500)
// }



//}
//
//extension UIResponder {
//
//    private struct Static {
//        static weak var responder: UIResponder?
//    }
//
//    /// Finds the current first responder
//    /// - Returns: the current UIResponder if it exists
//    static func currentFirst() -> UIResponder? {
//        Static.responder = nil
//        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
//        return Static.responder
//    }
//
//    @objc private func _trap() {
//        Static.responder = self
//    }
//}
