//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by JP on 1/30/16.
//  Copyright © 2016 tpham44. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    
    
    @IBOutlet weak var DetailsPosterView: UIImageView!
    
    var detailsInstagram: NSDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("Access photo........... ***" )
        //print(detailsInstagram)
        
        if let posterViewURL = detailsInstagram.valueForKeyPath("images.low_resolution.url") as? String {
            
            
            let imageUrl = NSURL(string: posterViewURL)
            DetailsPosterView.setImageWithURL(imageUrl!)
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
