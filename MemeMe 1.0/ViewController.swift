//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Meemi on 23/05/2021.
//

import UIKit

// Meme structure
struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}

class ViewController: UIViewController, UINavigationControllerDelegate {
    
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
        NSAttributedString.Key.strokeWidth:  1.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Text field delegates
        topTextField.delegate = self
        bottomTextField.delegate = self
        // Disable share button
        shareBtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Format text fields
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        // Disable camera if no camera in the device
        camButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // To shift screen for keyboard
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    @IBAction func albumPressed() {
        // Launch photo library
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func cameraPressed() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func shareButtonPressed() {
        // Save the meme function
        save()
        // Launch activity view
        let activityView = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        present(activityView, animated: true, completion: nil)
    }
    
    func save() {
        // Create the meme
        meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: self.image.image!, memedImage: meme.memedImage)
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

extension ViewController: UIImagePickerControllerDelegate {
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

extension ViewController: UITextFieldDelegate {
    // Begin editing with an empty field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    // Dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    // Did end editing with an empty field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if topTextField.text == "" {
            topTextField.text = "TOP"
        }
        if bottomTextField.text == "" {
            bottomTextField.text = "BOTTOM"
        }
    }
}

