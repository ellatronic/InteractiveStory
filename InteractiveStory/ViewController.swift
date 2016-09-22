//
//  ViewController.swift
//  InteractiveStory
//
//  Created by Ella on 9/20/16.
//  Copyright © 2016 Ellatronic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    enum NameError: Error {
        case NoName
    }

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startAdventure" {
            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw NameError.NoName
                    }
                    if let pageController = segue.destination as? PageController {
                        pageController.page = Adventure.story(name: name)
                    }
                }
            } catch NameError.NoName{
                let alertController = UIAlertController(title: "Name Not Provided", message: "Provide a name to start your story!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                
                present(alertController, animated: true, completion: nil)

            } catch _ {
                fatalError()
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfoDict = notification.userInfo, let keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue
            
            UIView.animate(withDuration: 0.8) {
                self.textFieldBottomConstraint.constant = keyboardFrame.size.height + 10
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.8) {
            self.textFieldBottomConstraint.constant = 40.0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

