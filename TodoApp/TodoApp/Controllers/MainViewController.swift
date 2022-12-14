// Created for YandexMobileSchool in 2022
// by Murphy
// Using Swift 5.0
// Running on macOS 12.5

import UIKit
import CellAnimator
import MyColors

final class MainViewController: UIViewController, TodoItemServiceDelegate {
    
    // MARK: - Private properties
    
    private var todoItemService = TodoItemService(FileCacheService(), NetworkService())
    private var toDoItems: [TodoItem] = []
    private var tapIndex: IndexPath?
    private var isShowAll: Bool = false
    private  var headerView: MainTableHeaderView?
    
    func updateTodoItems() {
        updateModel()
        mainTable.reloadData()
        updateHeader()
    }
    
    private func updateHeader() {
        if let headerView = headerView {
            headerView.configure(isShowAll: isShowAll, completedTasksNumber: todoItemService.completedTasks)
        } else {
            headerView = MainTableHeaderView(isShowAll: isShowAll, completedTasksNumber: todoItemService.completedTasks)
        }
    }
    private lazy var mainTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.layer.cornerRadius = 30
        table.backgroundColor = ColorPalette.backPrimary.color
        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var addItemButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 22
        button.backgroundColor = ColorPalette.blue.color
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold)
        button.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
        button.layer.shadowColor = ColorPalette.labelPrimary.color.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowOpacity = 0.5
        button.tintColor = ColorPalette.white.color
        button.addTarget(self, action: #selector(createNewItem), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func createNewItem() {
        let vc = DetailsViewController(with: TodoItem(text: ""))
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoItemService.delegate = self
        todoItemService.load()
        configureNavbar()
        headerView = MainTableHeaderView(isShowAll: isShowAll, completedTasksNumber: todoItemService.completedTasks)
        
        view.backgroundColor = ColorPalette.backPrimary.color
        view.addSubview(mainTable)
        view.addSubview(addItemButton)
        mainTable.delegate = self
        mainTable.dataSource = self
        
        NSLayoutConstraint.activate([
            addItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addItemButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -41),
            addItemButton.widthAnchor.constraint(equalToConstant: 44),
            addItemButton.heightAnchor.constraint(equalToConstant: 44),
            
            mainTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - TableVDelegate DataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    private func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            guard let id = self?.toDoItems[indexPath.row].id else { return }
            self?.todoItemService.delete(id: id)
        }
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = ColorPalette.red.color
        return action
    }
    private func info(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { _, _, _ in
        }
        action.image = UIImage(systemName: "info.circle.fill")
        action.backgroundColor = ColorPalette.gray.color
        return action
    }
    private func complete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { [ weak self] _, _, _ in
            guard let item = self?.toDoItems[indexPath.row] else { return }
            self?.todoItemService.add(TodoItem(id: item.id,
                                               text: item.text,
                                               importance: item.importance,
                                               deadline: item.deadline,
                                               done: true,
                                               color: item.color,
                                               creationDate: item.creationDate,
                                               changeDate: .now))
        }
        action.image = UIImage(systemName: "checkmark.circle.fill")
        action.backgroundColor = ColorPalette.green.color
        return action
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = complete(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [complete])
        return swipe
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let info = info(rowIndexPathAt: indexPath)
        let delete = delete(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [delete, info])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: indexPath as NSCopying) {
            let vc = DetailsViewController(with: self.toDoItems[indexPath.row])
            vc.delegate = self
            return UINavigationController(rootViewController: vc)
        }
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let destinationViewController = animator.previewViewController else { return }
        animator.preferredCommitStyle = .dismiss
        animator.addAnimations {
            self.present(destinationViewController, animated: true)
        }
    }
    
    // MARK: - didSelectRow
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTable.deselectRow(at: indexPath, animated: true)
        let vc = DetailsViewController(with: toDoItems[indexPath.row])
        vc.delegate = self
        tapIndex = indexPath
        let navBarVC = UINavigationController(rootViewController: vc)
        navBarVC.transitioningDelegate = self
        present(navBarVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoItems.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: toDoItems[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = headerView else { return nil }
        header.action = { [weak self] isShowAll in
            self?.isShowAll = isShowAll
            self?.updateTodoItems()
        }
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        CellAnimator(table: mainTable, indexPath: tapIndex!)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        nil
    }
}

// MARK: - DetailsVCDelegate

extension MainViewController: DetailsViewControllerDelegate {
    
    func returnTodoItem(model: TodoItem) {
        todoItemService.add(model)
    }

    func todoItemDeleted(id: String) {
        todoItemService.delete(id: id)
    }
}

// MARK: - Private methods

private extension MainViewController {
    
    func updateModel() {
        if isShowAll {
            toDoItems = Array(todoItemService.todoItems.values.sorted { $0.creationDate < $1.creationDate})
        } else {
            let cleanDictionary = todoItemService.todoItems.values.filter({ todoItem in
                !todoItem.done
            })
            toDoItems = cleanDictionary.sorted { $0.creationDate < $1.creationDate }
        }
    }
    
    func configureNavbar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let attrs = [
            NSAttributedString.Key.foregroundColor: ColorPalette.labelPrimary.color,
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = attrs
        title = "?????? ????????"
    }
}
