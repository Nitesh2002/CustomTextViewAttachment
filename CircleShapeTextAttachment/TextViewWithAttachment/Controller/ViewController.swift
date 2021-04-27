//
//  ViewController.swift
//  TextViewWithAttachment
//
//  Created by Nitesh MIshra on 2/9/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: Constants.attachmentCell, bundle: nil), forCellReuseIdentifier: Constants.attachmentCell)
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.alwaysBounceVertical = false
        tableView.layoutIfNeeded()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.attachmentCell, for: indexPath) as? AttachmentCell {
            
            cell.attachmentTapped = { [weak self] in
                self?.showAlert(alertText: Constants.alertTitle, alertMessage: "Tapped on image/attachment")
            }
            cell.textTapped = { [weak self] in
                self?.showAlert(alertText: Constants.alertTitle, alertMessage: "Tapped on text")
            }
            
            cell.addTextAttachment(text: Constants.defaultTextViewText, count: "2")
            
            return  cell
        }
        return UITableViewCell()
    }
}

enum Constants {
    static let empty = ""
    static let whiteSpace = " "
    static let newLine = "\n"
    static let paragraphSeparator = "\u{2029}"
    static let defaultTextViewText = "There are 2 tasks you can take care of while you’re here today."
    static let attachmentCell = "AttachmentCell"
    static let estimatedRowHeight: CGFloat = 60
    static let alertTitle = "TextViewAttachment"
}
