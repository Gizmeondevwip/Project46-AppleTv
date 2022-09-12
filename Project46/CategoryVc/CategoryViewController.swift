//
//  CategoryViewController.swift
//  AdventureSportstvOS
//
//  Created by GIZMEON on 18/12/20.
//  Copyright © 2020 Firoze Moosakutty. All rights reserved.
//

import UIKit
import Reachability

protocol  categoryListingDelegate:class {
    func getCategoryVideos(categoryModel :VideoModel)
}
class CategoryViewController: UIViewController {
    var channelVideos = [VideoModel]()
    weak var delegate: categoryListingDelegate!
    let reachability = try! Reachability()

    @IBOutlet weak var categoryTableView: UITableView!{
        didSet {
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")

            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let nib2 =  UINib(nibName: "CategoryTableView", bundle: nil)
        categoryTableView.register(nib2, forCellReuseIdentifier: "CategoryCell")
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.reloadData()
        self.getCategoryVideos()
      
        
        
        
    }
  
    func getCategoryVideos() {
        commonClass.startActivityIndicator(onViewController: self)
      ApiCommonClass.getCategories { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            commonClass.stopActivityIndicator(onViewController: self)
            commonClass.showAlert(viewController:self, messages: "Oops! something went wrong \n Please try later")

          }
        } else {
          self.channelVideos = responseDictionary["categories"] as! [VideoModel]
          if self.channelVideos.count == 0 {
            DispatchQueue.main.async {
                commonClass.stopActivityIndicator(onViewController: self)

            }
          } else {
            DispatchQueue.main.async {
                commonClass.stopActivityIndicator(onViewController: self)

              self.categoryTableView.reloadData()
                print("catygeory api call")
              //self.getYoutubeVideos()
            }
          }
        }
      }
    }
   

}
extension CategoryViewController : UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelVideos.count
    }
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
            return [categoryTableView]
        }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        
        if indexPath.row == 0{
            cell.categoryNameLabl.isEnabled = true
            cell.isSelected = true
            self.updateFocusIfNeeded()
            self.setNeedsFocusUpdate()


//            cell.backgroundColor = .white
            (self.parent as! MySplitViewController).detail.delegate.getCategoryVideos(categoryModel: channelVideos[indexPath.item])
               print("cell selcted",indexPath)
            if channelVideos[indexPath.row].categoryname != nil{
            cell.categoryNameLabl.text = channelVideos[indexPath.row].categoryname
            }
            else{
                cell.categoryNameLabl.text = " "
            }
        }
        else{
            cell.backgroundColor = .clear
            if channelVideos[indexPath.row].categoryname != nil{
            cell.categoryNameLabl.text = channelVideos[indexPath.row].categoryname
            }
            else{
                cell.categoryNameLabl.text = " "
            }

        }
      
        return cell
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
       
               if let next = context.nextFocusedView as? CategoryTableViewCell {
       
       
                   if let indexPath = self.categoryTableView.indexPath(for: next) {
//                    delegate.getCategoryVideos(categoryModel: channelVideos[0])
                    (self.parent as! MySplitViewController).detail.delegate.getCategoryVideos(categoryModel: channelVideos[indexPath.item])
                       print("cell next",indexPath)
                    next.backgroundColor = .clear

//                    next.isSelected = true
       
                   }
       
               }
               else {
                let next = context.previouslyFocusedView as? CategoryTableViewCell

                   UIView.animate(withDuration: 0.2) {
//                    next!.categoryNameLabl.bac = .red
                    print("cell preious")

//                    next!.isSelected = false
//                       self.titleLabel.isHidden = true
                   }
               }
    }
//    private func tableView(_ tableView: UICollectionView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//
//        if let previousIndexPath = context.previouslyFocusedIndexPath ,
//           let cell = categoryTableView.cellForRow(at: previousIndexPath) {
//            print("previousIndexPath")
//            cell.contentView.layer.borderWidth = 0.0
//            cell.contentView.layer.shadowRadius = 0.0
//            cell.contentView.layer.shadowOpacity = 0
//        }
//
//        if let indexPath = context.nextFocusedIndexPath,
//           let cell = categoryTableView.cellForRow(at: indexPath) {
//            print("nextFocusedIndexPath")
//            cell.contentView.layer.borderWidth = 6.0
//            cell.contentView.layer.borderColor = UIColor.red.cgColor
//
//            cell.contentView.layer.cornerRadius = 8
//
//        }
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print("hello")

    }
    
}
