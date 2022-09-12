//
//  HomeTabBarViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 14/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//
import UIKit
class HomeTabBarViewController: UITabBarController, UITabBarControllerDelegate,UINavigationControllerDelegate {
    var window: UIWindow?
      
      func searchContainerDisplay(){
          print("search items")
          let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! HomeSearchViewController
       
          let searchController = UISearchController(searchResultsController: resultsController)
          
          searchController.searchResultsUpdater = resultsController
          
//          searchController.obscuresBackgroundDuringPresentation = true
//          searchController.hidesNavigationBarDuringPresentation = false
          
          let searchPlaceholderText = NSLocalizedString("Search Title", comment: "")
          searchController.searchBar.placeholder = searchPlaceholderText
//          searchController.searchBar.tintColor = UIColor.black
//          searchController.searchBar.barTintColor = UIColor.black
//          searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = resultsController
//        searchController.searchBar.delegate = resultsController
        searchController.searchBar.keyboardAppearance = .dark
          let searchContainerViewController = UISearchContainerViewController(searchController: searchController)
//        resultsController.NoResultView.isHidden = false
//        resultsController.NoResultLabel.text = "fihfih"
          let navController = UINavigationController(rootViewController: searchContainerViewController)
          navController.view.backgroundColor = UIColor.black
          
          if var tbViewController = self.viewControllers{
              
              //tbViewController.append(navController)
              //Inserts Search into the 3rd array position
              tbViewController.insert(navController,at: 3)
              self.viewControllers = tbViewController
          }
          
      }
   var firstLaunch = Bool()
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let nextFocusedItem = context.nextFocusedItem,
            self.tabBar.contains(nextFocusedItem) {
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["Renish":"Dadhaniya"])

            print("focused tabbar")
            //Do some stuff
        }
      
       
    }
    func addSubviewToLastTabItem() {
          
                let imgView = UIImageView()
                imgView.frame = CGRect(x: 80, y: 0, width: 170, height: 100)
                imgView.layer.masksToBounds = true
                imgView.contentMode = .scaleAspectFill
                imgView.clipsToBounds = true
                imgView.image = #imageLiteral(resourceName: "banner_title")
                self.tabBar.subviews.last?.addSubview(imgView)
            
        }
      
      override func viewDidLoad() {
          super.viewDidLoad()
        view.backgroundColor = .black
        self.firstLaunch = true
        self.searchContainerDisplay()
  
  

           if let tbItems = self.tabBar.items{

            let tabBarItem5: UITabBarItem = tbItems[3]

            tabBarItem5.title = "Search"
            tabBarItem5.image = #imageLiteral(resourceName: "TVExcelSearchImage")

     
           }

        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
          
      }
//    override var preferredFocusEnvironments: [UIFocusEnvironment]  {   if
//    (self.firstLaunch) {
//         self.firstLaunch = false;
//         return self.selectedViewController!.preferredFocusEnvironments  }   else {
//         let view  = super.preferredFocusEnvironments
//        return view
//            
//         }
//     }
//    
    @objc func menuButtonAction() {
        print("menu pressed")
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        print("exit  app")
    }
   
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("tabbar disappeared")
    }
      override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
      }
      
}
