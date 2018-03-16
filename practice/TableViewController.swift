//
//  TableViewController.swift
//  practice
//
//  Created by Yohan Yi on 2017. 5. 27..
//  Copyright © 2017년 Yohan Yi. All rights reserved.
//

import Foundation
import UIKit

class TableViewContoller: UITableViewController{
    var memes: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateMemes()
    }
    
    @IBAction func addMeme(_ sender: Any) {
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "addViewController"))!, animated: true, completion: nil)
        updateMemes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateMemes()
        self.tableView.reloadData()
    }
    
/*    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateMemes()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMemes()
    }
*/
    func updateMemes(){
        let aplicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        memes = aplicationDelegate.memes
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")!
        
        let meme = self.memes[indexPath.row]
        // Set the name and image
        cell.textLabel?.text = meme.topText + "..." + meme.botText
        cell.detailTextLabel?.text = ""
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme   = self.memes[indexPath.row]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}
