

import UIKit

class AttachmentCell: UITableViewCell {
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var titleTextView: AttachmentTextView!
    
    var textTapped: (() -> Void)?
    var attachmentTapped: (() -> Void)?
    
    private lazy var attachmentButton: UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: Constants.infoImage), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(attachmentButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = Accessibility.attachmentId
        return button
    }()
    
    private lazy var attachmentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(attachmentButton)
        attachmentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        attachmentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(attachmentButtonTapped)))
        view.isAccessibilityElement = false
        return view
    }()
    
    private lazy var attachmentLabel: UILabel = {
        
        let label = UILabel()
        label.backgroundColor = .white
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = .zero
        label.textColor = containerView.backgroundColor
        label.textAlignment = .center
        label.accessibilityIdentifier = Accessibility.shapeAttachmentId
        return label
    }()
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        titleTextView.backgroundColor = .clear
    }
    
    // MARK: - UI Handlers
    
    @objc private func containerTapped() {
        
        textTapped?()
    }
    
    @objc private func attachmentButtonTapped() {
        
        attachmentTapped?()
    }
    
    // MARK: - TextAttachments Handlers
    
    func addCustomViewTextAttachment(text: String, range: NSRange) {
        
        titleTextView.addCustomViewTextAttachment(text: text, attachmentView: attachmentView, range: range)
        setUpCell(text: text)
        setUpSubViewAppearance()
    }
    
    func addCustomViewTextAttachmentAtEnd(text: String) {
        
        titleTextView.addCustomViewTextAttachmentAtEnd(text: text, attachmentView: attachmentButton)
        setUpCell(text: text)
        setUpSubViewAppearance()
    }
    
    func addShapedTextAttachment(text: String, count:String, shape:Shape) {
        
        if let range = text.range(of: count) {
            let replacingText = count + Constants.doubleWhiteSpace
            attachmentLabel.accessibilityLabel = Constants.empty
            attachmentLabel.text = replacingText
            
            let displaytext = text.replacingCharacters(in: range,
                                                       with: replacingText)
            
            titleTextView.addShapeLabelTextAttachment(text: displaytext, label: attachmentLabel, shapeType: shape)
        } else {
            
            titleTextView.text = text
        }
        
        setUpCell(text: text)
    }
    
    private func setUpCell(text: String) {
        
        containerView.layoutIfNeeded()
        
        titleTextView.textViewDelegate = self
        titleTextView.isAccessibilityElement = true
        titleTextView.font = UIFont.preferredFont(forTextStyle: .headline)
        titleTextView.adjustsFontForContentSizeCategory = true
        
        containerView.isAccessibilityElement = false
        containerView.accessibilityElements = [titleTextView as Any]
        
        titleTextView.accessibilityIdentifier = Accessibility.textViewId
        
        titleTextView.accessibilityValue = Constants.empty
        titleTextView.accessibilityLabel = text
        
        titleTextView.tintColor = .white
        titleTextView.textColor = .white
    }
    
    private func setUpSubViewAppearance() {
        
        titleTextView.backgroundColor = .white
        titleTextView.textColor = UIColor.primary
        
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = CGFloat(Int.valueHalf)
        
        attachmentView.layer.borderColor = UIColor.black.cgColor
        attachmentView.layer.borderWidth = CGFloat(Int.valueHalf)
        attachmentView.layer.cornerRadius = attachmentView.bounds.size.width/CGFloat(Int.valueTwo)
    }
}

extension AttachmentCell: TextViewAttachmentDelegate {
    
    func didTapTextView(isAttachmentTapped: Bool) {
        isAttachmentTapped ? attachmentTapped?() :  textTapped?()
    }
}

extension AttachmentCell {
    
    private enum Accessibility {
        static let textViewId = "textView"
        static let attachmentId = "customAttachment"
        static let shapeAttachmentId = "shapeAttachment"
    }
}
