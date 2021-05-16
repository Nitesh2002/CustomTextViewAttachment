//
//  ViewController.swift
//  TextViewWithAttachment
//
//  Created by Nitesh MIshra on 2/9/21.
//

import UIKit

class AttachmentViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    
    var shapeListItem: ShapeListItem?
    var attachmentInfo: AttachmentInfo?
    var attachmentRange: NSRange?
    
    // MARK: - View LifeCycle function(s)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = ScreenTitle.View.GetTitle()
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

extension AttachmentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return Int.valueOne
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Int.valueOne
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.attachmentCell, for: indexPath) as? AttachmentCell {
            
            cell.attachmentTapped = { [weak self] in
                self?.showAlert(alertText: Constants.alertTitle, alertMessage: Constants.tappedOnAttachmentMessage)
            }
            cell.textTapped = { [weak self] in
                self?.showAlert(alertText: Constants.alertTitle, alertMessage: Constants.tappedOnTextMessage)
            }
            
            if let item = shapeListItem {
                cell.addShapedTextAttachment(text: attachmentInfo?.text ?? Constants.defaultTextViewText, count: attachmentInfo?.attachmentText ?? Constants.defaultAttachmentText, shape: item.type)
            } else {
                if let range = attachmentRange {
                    cell.addCustomViewTextAttachment(text: attachmentInfo?.text ?? Constants.defaultTextViewText, range: range)
                } else {
                    cell.addCustomViewTextAttachmentAtEnd(text: attachmentInfo?.text ?? Constants.defaultTextViewText)
                }
                
            }
            
            return  cell
        }
        return UITableViewCell()
    }
}
