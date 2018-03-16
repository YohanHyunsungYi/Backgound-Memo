//
//  CollectionViewController.swift
//  practice
//
//  Created by Yohan Yi on 2017. 5. 28..
//  Copyright © 2017년 Yohan Yi. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var memes: [Meme]!
    
    @IBAction func addMeme(_ sender: Any) {
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "addViewController"))!, animated: true, completion: nil)
        updateMemes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMemes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateMemes()
        self.collectionView?.reloadData()
    }
    
    func updateMemes(){
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        cell.memeImageView?.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath){
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme   = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
