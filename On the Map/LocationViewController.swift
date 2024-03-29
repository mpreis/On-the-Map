//
//  LocationViewController.swift
//  On the Map
//
//  Created by Mario Preishuber on 04/04/16.
//  Copyright © 2016 Preishuber. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    // Properties
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    
    @IBOutlet weak var infoTextLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findOnMapButton: BorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        configureUI()
        
        subscribeToNotification(UIKeyboardWillShowNotification,
                                selector: #selector(LocationViewController.keyboardWillShow(_:)))
        subscribeToNotification(UIKeyboardWillHideNotification,
                                selector: #selector(LocationViewController.keyboardWillHide(_:)))
        subscribeToNotification(UIKeyboardDidShowNotification,
                                selector: #selector(LocationViewController.keyboardDidShow(_:)))
        subscribeToNotification(UIKeyboardDidHideNotification,
                                selector: #selector(LocationViewController.keyboardDidHide(_:)))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    @IBAction func findOnMapPressed(sender: AnyObject) {
        if ((self.locationTextField.text?.isEmpty) != nil) {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LinkViewController") as! LinkViewController
            controller.mapString = self.locationTextField.text!
            self.presentViewController(controller, animated: true, completion: nil)
        } else {
            self.infoTextLabel.text = "Enter location, please."
        }
    }
}

extension LocationViewController: UITextFieldDelegate {
    
    // UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Show/Hide Keyboard
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }


    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(locationTextField)
    }

}

// LocationViewController (Configure UI)
extension LocationViewController {

        private func configureUI() {
            
            // configure background gradient
            let backgroundGradient = CAGradientLayer()
            backgroundGradient.colors = [Constants.UI.LoginColorTop, Constants.UI.LoginColorBottom]
            backgroundGradient.locations = [0.0, 1.0]
            backgroundGradient.frame = view.frame
            view.layer.insertSublayer(backgroundGradient, atIndex: 0)
            
            configureTextField(locationTextField)
    }
        
        private func configureTextField(textField: UITextField) {
            let textFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0)
            let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
            textField.leftView = textFieldPaddingView
            textField.leftViewMode = .Always
            textField.backgroundColor = Constants.UI.GreyColor
            textField.textColor = Constants.UI.WhiteColor
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            textField.tintColor = Constants.UI.WhiteColor
            textField.delegate = self
        }
        
}


// LocationViewController (Notifications)
extension LocationViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}