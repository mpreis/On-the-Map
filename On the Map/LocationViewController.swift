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
        
        subscribeToNotification(UIKeyboardWillShowNotification, selector: Constants.Selectors.KeyboardWillShow)
        subscribeToNotification(UIKeyboardWillHideNotification, selector: Constants.Selectors.KeyboardWillHide)
        subscribeToNotification(UIKeyboardDidShowNotification, selector: Constants.Selectors.KeyboardDidShow)
        subscribeToNotification(UIKeyboardDidHideNotification, selector: Constants.Selectors.KeyboardDidHide)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    @IBAction func findOnMapPressed(sender: AnyObject) {
        if ((self.locationTextField.text?.isEmpty) != nil) {
            self.infoTextLabel.text = "Enter location, please."
        } else {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LinkViewContorler")
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let lvc = segue.destinationViewController as! LinkViewController;
        lvc.studentLocation = self.locationTextField.text!
        print(lvc.studentLocation)
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