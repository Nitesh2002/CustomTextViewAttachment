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
    
    // MARK: - View lifeCycle function(s)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = ScreenTitle.Entry.GetTitle()
        configureSubViews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        handleLayoutChange()
    }
    
    // MARK: - UI Handler function(s)
    
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
                showAlert(alertText: Constants.alertTitle, alertMessage: Constants.attachmentMismatchMessage)
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
        showRangeActionSheet(title: Constants.actionSheetTitle, message: Constants.minRangeActionSheetTitle, options: options(start: minRange, end: maxRange <= Int.valueOne ? Int.valueOne : maxRange-Int.valueOne), type: .min)
    }
    
    
    @IBAction func onMaxRangeButtonClick(_ sender: UIButton) {
        
        if textView.text.isEmpty {
            showEmptyTextViewAlert()
            return
        }
        showRangeActionSheet(title: Constants.actionSheetTitle, message: Constants.maxRangeActionSheetTitle, options: options(start: minRange+1, end: maxRange <= Int.valueOne ? Int.valueOne : maxRange), type: .max)
    }
}

extension AttachmentEntryViewController {
    
    private func configureSubViews() {
        
        configureUI(view: textView)
        configureUI(view: attachmentTextField)
        configureUI(view: validateButton)
        configureUI(view: customAttachmentView)
        
        textView.text = Constants.defaultTextViewText
        if shapeListItem == nil {
            textView.text =  Constants.defaultCustomAttachmentTextViewText
        }
        
        attachmentTextField.text = Constants.defaultAttachmentText
        attachmentTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, .zero, .zero)
        showSubviews()
    }
    
    private func configureUI(view: UIView) {
        
        view.layer.cornerRadius = CGFloat(Int.valueFour)
        view.layer.borderWidth = CGFloat(Int.valueHalf)
        view.layer.borderColor = UIColor.black.cgColor
    }
    
    private func showSubviews() {
        
        attachmentLabel.isHidden = (shapeListItem == nil)
        attachmentTextField.isHidden = (shapeListItem == nil)
        customAttachmentView.isHidden = (shapeListItem != nil)
    }
    
    private func updateRangeButtons() {
        
        if selectedRange <= Int.valueOne {
            selectedRange = .zero
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
        showAlert(alertText: Constants.alertTitle, alertMessage: Constants.emptyMessage)
        
    }
}

// MARK: - Navigation function(s)

extension AttachmentEntryViewController {
    
    private func navigateToAttachment(_ item: ShapeListItem? = nil, attachmentInfo: AttachmentInfo) {
        
        guard let attachmentVC: AttachmentViewController = storyboard?.instantiateVC() else {
            preconditionFailure(Constants.controlleDidNotFound)
        }
        
        if (item == nil) {
            if selectedRange >= maxRange {
                showAlert(alertText: Constants.alertTitle, alertMessage: Constants.validRangeMessage)
                return
                
            } else {
                attachmentVC.attachmentRange = NSRange(location: selectedRange, length: selectedRange + Int.valueOne)
            }
        }
        
        attachmentVC.shapeListItem = item
        attachmentVC.attachmentInfo = attachmentInfo
        
        self.navigationController?.pushViewController(attachmentVC, animated: true)
    }
}

// MARK: - ActionSheet function(s)

extension AttachmentEntryViewController {
    
    private func options(start: Int, end: Int) -> [Int] {
        
        var options:[Int] = []
        for index in start...end {
            options.append(index)
        }
        return options
    }
    
    func showRangeActionSheet(title: String, message: String, options: [Int],type: RangeType)  {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for option in options {
            let optionAction = UIAlertAction(title:"\(option)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                
                self.selectedRange = (type == RangeType.min) ? option : option - Int.valueOne
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

// MARK: - TextField function(s)

extension AttachmentEntryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        updateDefaultRangeButtons()
    }
}

// MARK: - TextView function(s)

extension AttachmentEntryViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        updateDefaultRangeButtons()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        updateDefaultRangeButtons()
    }
}
