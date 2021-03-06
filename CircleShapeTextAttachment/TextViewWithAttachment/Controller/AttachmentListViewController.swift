//
//  AttachmentViewController.swift
//  TextViewWithAttachment
//
//  Created by Nitesh on 01/05/21.
//

import UIKit

class AttachmentListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private(set) var rows = AttachmentList().rows
    private(set) var selectedShpaeListItem: ShapeListItem?
    
    // MARK: - View LifeCycle function(s)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = ScreenTitle.List.GetTitle()
        configureTableView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        handleLayoutChange()
    }
    
    // MARK: - UI Handler function(s)
    
    private func handleLayoutChange() {
        
        UIView.performWithoutAnimation {
            self.view.layoutIfNeeded()
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
    }
    
    private func configureTableView() {
        
        tableView.register(UINib(nibName: Constants.attachmentCell, bundle: nil), forCellReuseIdentifier: Constants.attachmentCell)
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.alwaysBounceVertical = false
        tableView.tableFooterView = UIView()
        tableView.layoutIfNeeded()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AttachmentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return Int.valueOne
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.listcell, for: indexPath) as? ListTableViewCell {
            cell.attachmentTypeLabel.text = rows[indexPath.row].name
            cell.configureCell()
            return  cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let shapeList = rows[indexPath.row].shapeList
        if shapeList.count > .zero {
            showActionSheet(title: Constants.actionSheetTitle, message: Constants.actionSheetOption, options: shapeList)
        } else {
            selectedShpaeListItem = nil
            navigateToAttachment()
        }
    }
}

// MARK: - Navigation function(s)

extension AttachmentListViewController {
    
    private func navigateToAttachment(_ item: ShapeListItem? = nil) {
        
        guard let attachmentVC: AttachmentEntryViewController = storyboard?.instantiateVC() else {
            preconditionFailure(Constants.controlleDidNotFound)
        }
        
        if let item = selectedShpaeListItem {
            attachmentVC.shapeListItem = item
        }
        
        self.navigationController?.pushViewController(attachmentVC, animated: true)
    }
}

// MARK: - ActionSheet function(s)

extension AttachmentListViewController {
    
    func showActionSheet(title: String, message: String, options: [ShapeListItem])  {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for option in options {
            let optionAction = UIAlertAction(title:option.name, style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.selectedShpaeListItem = option
                self.navigateToAttachment(option)
            })
            alertController.addAction(optionAction)
        }
        
        let cancelAction = UIAlertAction(title: Constants.actionSheetCancel, style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
