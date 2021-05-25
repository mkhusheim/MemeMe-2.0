//
//  MemeDetailViewController.swift
//  MemeMe 1.0
//
//  Created by Meemi on 25/05/2021.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // Properties
    var meme: Meme!
    
    // IBOutlets
    @IBOutlet var memeImage: UIImageView!
    @IBOutlet var topText: UILabel!
    @IBOutlet var bottomText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = meme.memedImage
        topText.text = meme.topText
        bottomText.text = meme.bottomText
    }

}
