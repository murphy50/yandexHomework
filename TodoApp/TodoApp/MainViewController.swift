import UIKit

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    func updateModel() {
        toDoItems = Array(fileCache.todoItems.values.sorted { $0.creationDate < $1.creationDate})
    }
    var fileCache = FileCache()
    var toDoItems: [TodoItem] = []
    
    private let mainTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .yellow
        table.layer.cornerRadius = 16

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
        let vc = UINavigationController(rootViewController: DetailsViewController(with: TodoItem(text: "")))
        vc.delegate = self
        present(vc, animated: true)
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
        cell.backgroundColor = .green
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            let view = MainTableHeaderUIView()
          return view
       }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
}

extension MainViewController: MainTableViewCellDelegate {
    func MainTableViewCellDidTapCell(_ cell: MainTableViewCell, model: TodoItem) {
      //  DispatchQueue.main.async { [weak self] in
            let vc = UINavigationController(rootViewController: DetailsViewController(with: model))
           // viewController.configure(with: model)
            present(vc, animated: true, completion: nil)
            //self?.pushViewController(viewController, animated: true)
       // }
    }
}

extension MainViewController: DetailsViewControllerDelegate {
    func ToDoItemCreated(model: TodoItem) {
        fileCache.add(model)
        updateModel()
        mainTable.reloadData()
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
