import UIKit

final class MainViewController: UIViewController {
    
    private func updateModel() {
        toDoItems = Array(fileCache.todoItems.values.sorted { $0.creationDate < $1.creationDate})
    }
    private var fileCache = FileCache()
    private var toDoItems: [TodoItem] = []
    
    private let mainTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        
        table.layer.cornerRadius = 30
        table.backgroundColor = ColorPalette.backPrimary.color
        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    private func configureNavbar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let attrs = [
            NSAttributedString.Key.foregroundColor: ColorPalette.labelPrimary.color,
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = attrs
        title = "Мои дела"
    }
    
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
        present( UINavigationController(rootViewController: vc), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTestFile()
        updateModel()
        configureNavbar()
        //let headerView = MainTableHeaderUIView()
        view.backgroundColor = ColorPalette.backPrimary.color
        view.addSubview(mainTable)
        view.addSubview(addItemButton)
        //mainTable.tableHeaderView = headerView
        mainTable.delegate = self
        mainTable.dataSource = self
        
        
        // mainTable.tableHeaderView = headerView
        NSLayoutConstraint.activate([
            addItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addItemButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -41),
            addItemButton.widthAnchor.constraint(equalToConstant: 44),
            addItemButton.heightAnchor.constraint(equalToConstant: 44),
            //            headerView.topAnchor.constraint(equalTo: mainTable.topAnchor),
            //            headerView.leadingAnchor.constraint(equalTo: mainTable.leadingAnchor),
            //            headerView.trailingAnchor.constraint(equalTo: mainTable.trailingAnchor),
            //            mainTable.topAnchor.constraint(equalTo: view.bottomAnchor,constant: 50),
            mainTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    private func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] _,_,_ in
            self?.toDoItems.remove(at: indexPath.row)
            self?.mainTable.deleteRows(at: [indexPath], with: .automatic)
            self?.mainTable.reloadData()
        }
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = ColorPalette.red.color
        return action
    }
    private func info(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { _,_,_ in
        }
        action.image = UIImage(systemName: "info.circle.fill")
        action.backgroundColor = ColorPalette.gray.color
        return action
    }
    private func complete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { _,_,_ in
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
        UIContextMenuConfiguration(identifier: nil) {
            let vc = DetailsViewController(with: self.toDoItems[indexPath.row])
            vc.delegate = self
            return vc
        }
    }
    
    // MARK: - settings for didSelectRow -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTable.deselectRow(at: indexPath, animated: true)
        let vc = DetailsViewController(with: toDoItems[indexPath.row])
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
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
        let view = MainTableHeaderView()
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
}



extension MainViewController: DetailsViewControllerDelegate {
    func ToDoItemCreated(model: TodoItem, beingDeleted: Bool) {
        if beingDeleted {
            fileCache.delete(model.id)
            updateModel()
            mainTable.reloadData()
        } else {
            fileCache.add(model)
            updateModel()
            mainTable.reloadData()
        }
    }
    
}

extension MainViewController {
    func loadTestFile() {
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
    }
}
//
//extension MainViewController: UIViewControllerTransitioningDelegate {
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        nil
//    }
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        PresentAnimator()
//    }
//}

//class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        0.5
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard
//         //   let rectOfCell = MainViewController.mainTable.rectForRowAtIndexPath(0),
//           // let rectOfCellInSuperview = tableView.convertRect(rectOfCell, toView: tableView.superview),
//            let fromViewController = (transitionContext.viewController(forKey: .from) as? UINavigationController)?.topViewController as? MainViewController,
//            //let cellImageView = MainTableViewCell.frame,
//            let toView = transitionContext.view(forKey: .to),
//            let fromView = transitionContext.view(forKey: .from)
//        else { return }
//        let startFrame = CGRect(x: 20, y: 271, width: 388, height: 109)//cellImageView.superview?.convert(MainTableViewCell.frame, to: nil)
//
//
//
//        toView.frame = startFrame
//
//        let containerView = transitionContext.containerView
//        containerView.addSubview(toView)
//
//    }
//
//
//}
