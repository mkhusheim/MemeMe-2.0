//
//  MemeEditorViewController.swift
//  MemeMe 1.0
//
//  Created by Meemi on 23/05/2021.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {
    
    // IBOutlets
    
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var camButton: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    // Initialize meme
    var meme = Meme(topText: "", bottomText: "", originalImage: UIImage(), memedImage: UIImage())
    
    // Meme text fields formatting
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.5
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable share button
        shareBtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Format text fields
        prepareTextField(textField: topTextField, defaultText: "TOP")
        prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")
        // Disable camera if no camera in the device
        camButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // To shift screen for keyboard
        //subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    @IBAction func albumPressed() {
        // Pick image from photo library
        pickImage(sourceType: .photoLibrary)
        
    }
    @IBAction func cameraPressed() {
        // Take a picture with camera
        pickImage(sourceType: .camera)
    }
    
    func pickImage(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func shareButtonPressed() {
        // Launch activity view
        let activityView = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        activityView.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                // Save the meme function
                self.save()
                self.dismiss(animated:true,completion:nil)
            }
        }
        present(activityView, animated: true, completion: nil)
    }
    func prepareTextField(textField: UITextField, defaultText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.textAlignment = .center
        
    }
    func save() {
        // Create the meme
        meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: self.image.image!, memedImage: generateMemedImage())
        // Add it to the memes array in the Application Delegate
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
    }
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.setToolbarHidden(true, animated: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
        
        return memedImage
    }
}

// MARK: - UIImagePickerController Delegate

extension MemeEditorViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dismiss Image Picker Controller
        dismiss(animated: true, completion: nil)
        // Set the ImageView with the picked photo
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image.image = image
        }
        // Enable share button
        shareBtn.isEnabled = true
    }
    
}

// MARK: - UITextField Delegate

extension MemeEditorViewController: UITextFieldDelegate {
    // Begin editing with an empty field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        if textField == bottomTextField {
            subscribeToKeyboardNotifications()
        }
    }
    // Dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    // Did end editing with an empty field
    func textFieldDidEndEditing(_ textField: UITextField) {
        unsubscribeFromKeyboardNotifications()
        if topTextField.text == "" {
            topTextField.text = "TOP"
        }
        if bottomTextField.text == "" {
            bottomTextField.text = "BOTTOM"
        }
    }
}

