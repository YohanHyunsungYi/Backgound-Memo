//
//  DetailViewController.swift
//  practice
//
//  Created by Yohan Yi on 2017. 5. 28..
//  Copyright © 2017년 Yohan Yi. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate {
    var meme: Meme!
    @IBOutlet var detailImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailImage.image = meme.memedImage
    }
    
    
    //Edit Meme: It goes back to the Edit view screen to edit the meme.
    func editMeme(){
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "edit", sender: self)
    }

}
