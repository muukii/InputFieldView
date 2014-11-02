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
    @IBOutlet weak var textFrameView: UIView!
    @IBOutlet weak var textFrameViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
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
        self.textFrameView.layer.cornerRadius = 3.0
        self.textFrameView.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
        self.textFrameView.layer.borderWidth = 1.0
        self.textView.contentInset = UIEdgeInsetsMake(-2, 0, 1, 0)

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

        let kMaxHeight: CGFloat = 100.0
        if self.textFrameViewHeight.constant >= kMaxHeight {
            textView.scrollEnabled = true
        } else {
            textView.scrollEnabled = false
            let size = textView.sizeThatFits(CGSizeMake(CGRectGetWidth(textView.bounds), kMaxHeight))
            textView.scrollEnabled = true
            
            UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                if size.height > 36 {
                    self.textFrameViewHeight.constant = min(size.height,kMaxHeight)
                }
                self.layoutIfNeeded()
                }) { (finish) -> Void in
                    
            }
        }
        
        
    }
}
