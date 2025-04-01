//
//  HomeViewController.swift
//  collectiondemo
//
//  Created by Proton on 1/4/25.
//

import UIKit

final class HomeViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var contentLabel: UILabel!
    
    let titleString: String
    init(with titleString: String) {
        self.titleString = titleString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        
        contentLabel.text = titleString
    }
}
