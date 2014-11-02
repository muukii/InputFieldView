//
//  InputFieldView.swift
//  InputFieldView
//
//  Created by Muukii on 11/2/14.
//  Copyright (c) 2014 Muukii. All rights reserved.
//

import UIKit

class InputFieldView: UIView, UITextViewDelegate{
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var menuRightButton: UIButton!
    @IBOutlet weak var menuLeftButton: UIButton!
    
    var bottom: NSLayoutConstraint?
    var actionButtonHandler: (() -> Void)?
    var menuRightButtonHandler: (() -> Void)?
    var menuLeftButtonHandler: (() -> Void)?
    
    class func instantiateFromNib() -> InputFieldView {
        let nib = UINib(nibName: "InputFieldView", bundle: NSBundle.mainBundle())
        let nibs = nib.instantiateWithOwner(self, options: nil)
        let view = nibs.first as InputFieldView
        return view
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
    }
    
    private func configureView() {
        self.textView.delegate = self
        self.textView.layer.cornerRadius = 3.0
        self.textView.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
        self.textView.layer.borderWidth = 1.0
        self.textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
//        UIKIT_EXTERN NSString *const UIKeyboardFrameBeginUserInfoKey        NS_AVAILABLE_IOS(3_2); // NSValue of CGRect
//        UIKIT_EXTERN NSString *const UIKeyboardFrameEndUserInfoKey          NS_AVAILABLE_IOS(3_2); // NSValue of CGRect
//        UIKIT_EXTERN NSString *const UIKeyboardAnimationDurationUserInfoKey NS_AVAILABLE_IOS(3_0); // NSNumber of double
//        UIKIT_EXTERN NSString *const UIKeyboardAnimationCurveUserInfoKey    NS_AVAILABLE_IOS(3_0); // NSNumber of NSUInteger (UIViewAnimationCurve)
//        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShowNotification:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHideNotification:", name: UIKeyboardDidHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrameNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidChangeFrameNotification:", name: UIKeyboardDidChangeFrameNotification, object: nil)
        
    }
    
    private func adjustToKeyboard(noti: NSNotification) {
        var duration = (noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        let curve = noti.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as NSNumber
        let frame = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        if duration == 0 {
            duration = 0.15
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions(curve.unsignedLongValue), animations: { () -> Void in
        self.bottom?.constant = CGRectGetHeight(self.superview?.bounds ?? CGRectZero) - CGRectGetMaxY(frame) + CGRectGetHeight(frame)
            self.layoutIfNeeded()
        }) { (finish) -> Void in
            
        }
    }
    
    func keyboardWillShowNotification(noti: NSNotification) {
        self.adjustToKeyboard(noti)
    }
    
    func keyboardDidShowNotification(noti: NSNotification) {

    }
    
    func keyboardWillHideNotification(noti: NSNotification) {
        self.adjustToKeyboard(noti)
    }
    
    func keyboardDidHideNotification(noti: NSNotification) {
        println("@")
    }
    
    func keyboardWillChangeFrameNotification(noti :NSNotification) {
        self.adjustToKeyboard(noti)
    }
    
    func keyboardDidChangeFrameNotification(noti: NSNotification) {
        println("@")
        
    }
    
    func attachView(view: UIView) {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(self)
        let right = NSLayoutConstraint(item: view, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0)
        
        let left = NSLayoutConstraint(item: view, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0)
        
        let bottom = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0)
        self.bottom = bottom
        view.addConstraints([right,left,bottom])
    }
    
    // MARK: - Button
    
    @IBAction func handleActionButton(sender: AnyObject) {
        self.actionButtonHandler?()
    }
    
    @IBAction func handleMenuRightButton(sender: AnyObject) {
        self.menuRightButtonHandler?()
    }
    @IBAction func handleMenuLeftButton(sender: AnyObject) {
        self.menuLeftButtonHandler?()
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        let size = textView.contentSize
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.textViewHeight.constant = min(size.height,100)
                self.layoutIfNeeded()
        }) { (finish) -> Void in
            
        }
    }
}
