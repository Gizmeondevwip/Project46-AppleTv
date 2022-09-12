//
//  MySplitViewController.swift
//  ISG
//
//  Created by GIZMEON on 21/12/20.
//  Copyright © 2020 Firoze Moosakutty. All rights reserved.
//

import UIKit

class MySplitViewController: UISplitViewController,categoryListingDelegate {
    func getCategoryVideos(categoryModel: VideoModel) {
        detail.getCategoryVideos(categoryModel: categoryModel)
    }
    
    
    
    var master : CategoryViewController!
    var detail : CategoryListingViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        master = self.viewControllers[0] as?  CategoryViewController
        detail = (self.viewControllers[1] as! UINavigationController).topViewController as?CategoryListingViewController
        detail.delegate = self
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
