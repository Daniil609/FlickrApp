//
//  ViewController.swift
//  FlickrApp
//
//  Created by Tomashchik Daniil on 23/01/2022.
//
import SafariServices
import UIKit

class FeedViewController: UIViewController, FeedsTableViewCellDelegate {
    //MARK: - Private properties
    private var tableView: UITableView!

    private var viewModel = FeedVM()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupVM()
    }
}

private extension FeedViewController {
    //MARK: - Private methods
    func setupVM() {
        viewModel.loadData = { [weak self] state in
            guard let self = self else {
                return
            }
            
            switch state {
            case .dataSetup(let isSetup):
                if isSetup {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        viewModel.launch()
    }
    
    func setupUI() {
        tableView = .init()
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: Constants.cellID)
        
        view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - TableView Delegat, DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? FeedsTableViewCell else {
            return .init()
        }
        
        cell.model = .init(title: viewModel.dataModel[indexPath.row].title,
                           link: viewModel.dataModel[indexPath.row].link,
                           image: viewModel.dataModel[indexPath.row].media)
        cell.delegate = self
        return cell
    }
    
    func pressButton(_ link: String) {
        guard let url = URL(string: link) else {
            return
        }
        
        let config = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.modalPresentationStyle = .formSheet
        present(safariViewController, animated: true, completion: nil)
    }
}

private extension FeedViewController {
    //MARK: - Constants
    struct Constants {
        static let cellID = "cell"
    }
}
