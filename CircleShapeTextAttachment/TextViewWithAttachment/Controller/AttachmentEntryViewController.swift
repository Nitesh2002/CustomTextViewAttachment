//
//  AttachmentEntryViewController.swift
//  TextViewWithAttachment
//
//  Created by Nitesh on 02/05/21.
//

import UIKit

class AttachmentEntryViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var attachmentTextField: UITextField!
    
    var shapeListItem: ShapeListItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubViews()
    }
    
    @IBAction func validateButtonClick(_ sender: UIButton) {
        
        if textView.text.contains(attachmentTextField.text!) {
            let attachmentInfo = AttachmentInfo(text: textView.text, attachmentText: attachmentTextField.text!)
            navigateToAttachment(shapeListItem, attachmentInfo: attachmentInfo)
            
        } else {
            showAlert(alertText: "Attachment Info", alertMessage: "Attachment text you entered does not belongs to the full text.")
        }
        
    }
}

extension AttachmentEntryViewController {
    
    private func navigateToAttachment(_ item: ShapeListItem? = nil, attachmentInfo: AttachmentInfo) {
        
        guard let attachmentVC: AttachmentViewController = storyboard?.instantiateVC() else {
            preconditionFailure(Constants.controlleDidNotFound)
        }
        
        attachmentVC.shapeListItem = item
        attachmentVC.attachmentInfo = attachmentInfo
        
        self.navigationController?.pushViewController(attachmentVC, animated: true)
    }
}

extension AttachmentEntryViewController {
    private func configureSubViews() {
        configureUI(view: textView)
        configureUI(view: attachmentTextField)
        configureUI(view: validateButton)
        textView.text = Constants.defaultTextViewText
        attachmentTextField.text = Constants.defaultAttachmentText
        
    }
    
    private func configureUI(view: UIView) {
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
    }
}
extension AttachmentEntryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
