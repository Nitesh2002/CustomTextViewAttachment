//
//  AttachmentEntryViewController.swift
//  TextViewWithAttachment
//
//  Created by Nitesh on 02/05/21.
//

import UIKit

enum RangeType {
    case min
    case max
}

class AttachmentEntryViewController: UIViewController {
    
    @IBOutlet weak var customAttachmentView: UIView!
    @IBOutlet weak var minRangeButton: UIButton!
    @IBOutlet weak var maxRangeButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var attachmentTextField: UITextField!
    
    var shapeListItem: ShapeListItem?
    
    private(set) var selectedRange: Int = .zero
    
    private lazy var minRange: Int = {
        return .zero
    }()
    
    private var maxRange: Int  {
        return self.textView.text.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Attachment Entry"
        configureSubViews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        handleLayoutChange()
    }
    
    private func handleLayoutChange() {
        UIView.performWithoutAnimation {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func validateButtonClick(_ sender: UIButton) {
        if textView.text.isEmpty {
            showEmptyTextViewAlert()
            return
        }
        if (shapeListItem != nil) {
            if textView.text.contains(attachmentTextField.text!) {
                let attachmentInfo = AttachmentInfo(text: textView.text, attachmentText: attachmentTextField.text!)
                navigateToAttachment(shapeListItem, attachmentInfo: attachmentInfo)
                
            } else {
                showAlert(alertText: "Attachment Info", alertMessage: "Attachment text you entered does not belongs to the full text.")
            }
        } else {
            let attachmentInfo = AttachmentInfo(text: textView.text, attachmentText: attachmentTextField.text!)
            navigateToAttachment(shapeListItem, attachmentInfo: attachmentInfo)
        }
        
    }
    
    
    @IBAction func onMinRangeBtnClick(_ sender: UIButton) {
        if textView.text.isEmpty {
            showEmptyTextViewAlert()
            return
        }
        showRangeActionSheet(title: Constants.actionSheetTitle, message: Constants.minRangeActionSheetTitle, options: options(start: minRange, end: maxRange <= 1 ? 1 : maxRange-1), type: .min)
    }
    
    
    @IBAction func onMaxRangeButtonClick(_ sender: UIButton) {
        if textView.text.isEmpty {
            showEmptyTextViewAlert()
            return
        }
        showRangeActionSheet(title: Constants.actionSheetTitle, message: Constants.maxRangeActionSheetTitle, options: options(start: minRange+1, end: maxRange <= 1 ? 1 : maxRange), type: .max)
    }
}

extension AttachmentEntryViewController {
    private func configureSubViews() {
        configureUI(view: textView)
        configureUI(view: attachmentTextField)
        configureUI(view: validateButton)
        configureUI(view: customAttachmentView)
        textView.text = Constants.defaultTextViewText
        attachmentTextField.text = Constants.defaultAttachmentText
        attachmentTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, .zero, .zero)
        showSubviews()
    }
    
    private func configureUI(view: UIView) {
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
    }
    
    private func showSubviews(){
        attachmentLabel.isHidden = (shapeListItem == nil)
        attachmentTextField.isHidden = (shapeListItem == nil)
        customAttachmentView.isHidden = (shapeListItem != nil)
    }
    
    private func updateRangeButtons() {
        
        if selectedRange <= 1 {
            selectedRange = 0
        }
        
        minRangeButton.setTitle("\(selectedRange)", for: .normal)
        maxRangeButton.setTitle("\(selectedRange+1)", for: .normal)
        
    }
    
    private func updateDefaultRangeButtons() {
        minRangeButton.setTitle(Constants.minRangeActionSheetTitle, for: .normal)
        maxRangeButton.setTitle(Constants.maxRangeActionSheetTitle, for: .normal)
    }
    
    private func showEmptyTextViewAlert() {
        textView.resignFirstResponder()
        showAlert(alertText: "Attachment Info", alertMessage: "Please enter the attachment text.")
        
    }
}

extension AttachmentEntryViewController {
    
    private func navigateToAttachment(_ item: ShapeListItem? = nil, attachmentInfo: AttachmentInfo) {
        
        guard let attachmentVC: AttachmentViewController = storyboard?.instantiateVC() else {
            preconditionFailure(Constants.controlleDidNotFound)
        }
        
        if (item == nil) {
            if selectedRange >= maxRange {
                showAlert(alertText: "Attachment", alertMessage: "Please select valid range")
                return
                
            } else {
                attachmentVC.attachmentRange = NSRange(location: selectedRange, length: selectedRange + 1)
            }
        }
        
        attachmentVC.shapeListItem = item
        attachmentVC.attachmentInfo = attachmentInfo
        
        self.navigationController?.pushViewController(attachmentVC, animated: true)
    }
}

extension AttachmentEntryViewController {
    func showRangeActionSheet(title: String, message: String, options: [Int],type: RangeType)  {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for option in options {
            let optionAction = UIAlertAction(title:"\(option)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                
                self.selectedRange = (type == RangeType.min) ? option : option - 1
                self.updateRangeButtons()
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

extension AttachmentEntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateDefaultRangeButtons()
    }
}

extension AttachmentEntryViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        updateDefaultRangeButtons()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateDefaultRangeButtons()
    }
}

extension AttachmentEntryViewController {
    private func options(start: Int, end: Int) -> [Int] {
        var options:[Int] = []
        for index in start...end {
            options.append(index)
        }
        return options
    }
}
