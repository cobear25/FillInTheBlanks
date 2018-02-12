//
//  CMTextField.swift
//  Fill In The Blanks
//
//  Created by Cody Mace on 2/9/18.
//  Copyright © 2018 Cody Mace. All rights reserved.
//

import UIKit
import Cartography

@IBDesignable class CMTextField: UITextField, UITextFieldDelegate {

    var lineView: UIView!
    @IBInspectable var lineHeight: CGFloat = 1.0
    var selectedLineHeight: CGFloat = 2.0
    @IBInspectable var characterLimit = INT_MAX
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        delegate = self
        borderStyle = .none
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: 1))
        leftView = leftPadding
        leftViewMode = .always
        self.tintColor = UIColor.appDarkGray
        createLineView()
    }
    
    fileprivate func createLineView() {
        
        if lineView == nil {
            let lineView = UIView()
            lineView.isUserInteractionEnabled = false
            lineView.backgroundColor = UIColor.appPurpleLight
            self.lineView = lineView
        }
        
        lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        lineView.frame = CGRect(x: 0, y: bounds.height - 2, width: bounds.width, height: lineHeight)
        addSubview(lineView)
    }
    
    fileprivate func configureDefaultLineHeight() {
        let onePixel: CGFloat = 1.0 / UIScreen.main.scale
        lineHeight = 2.0 * onePixel
        selectedLineHeight = 2.0 * self.lineHeight
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let rect = lineView.frame
        lineView.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: selectedLineHeight)
        lineView.backgroundColor = UIColor.appPurple
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let rect = lineView.frame
        lineView.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: lineHeight)
        lineView.backgroundColor = UIColor.appPurpleLight
    }
    
    open func lineViewRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let height = editing ? selectedLineHeight : lineHeight
        return CGRect(x: 0, y: bounds.size.height - height, width: bounds.size.width, height: height)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount) {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= characterLimit
    }
}
