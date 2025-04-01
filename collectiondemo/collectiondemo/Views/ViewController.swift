//
//  ViewController.swift
//  collectiondemo
//
//  Created by Proton on 1/4/25.
//

import UIKit

class ViewController: UIViewController {
    enum DemoType: Int, CaseIterable {
        case waveTabbar = 0
        
        var title: String {
            switch self {
            case .waveTabbar:
                return "Wave Tabbar"
            }
        }
    }
    
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK:- Private func
    private func configureUI() {
        title = "Collection Custom Demo"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DemoType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tileType = DemoType.allCases[indexPath.row].title
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tileType
        cell.selectionStyle = .none
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let demoType = DemoType(rawValue: indexPath.row) else { return }
        switch demoType {
        case .waveTabbar:
            let homeVC = WaveTabbarController()
            navigationController?.pushViewController(homeVC, animated: true)
        }
        
    }
}

