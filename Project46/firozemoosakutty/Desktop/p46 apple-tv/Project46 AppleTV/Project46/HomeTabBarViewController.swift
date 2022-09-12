//
//  HomeTabBarViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 14/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//
import UIKit
class HomeTabBarViewController: UITabBarController, UITabBarControllerDelegate,UINavigationControllerDelegate,SearchSuggestionDelegate {
   
    
    var window: UIWindow?
    var resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! HomeSearchViewController
 
      func searchContainerDisplay(){
          print("search items")
          
          let searchController = UISearchController(searchResultsController: resultsController)

          searchController.searchResultsUpdater = resultsController
          resultsController.serachSuggetsionDelegate = self
          let searchPlaceholderText = NSLocalizedString("Search Title", comment: "")
          searchController.searchBar.placeholder = searchPlaceholderText
//          if #available(tvOS 14.0, *) {
//              let item1 =   UISearchSuggestionItem(localizedSuggestion: "gdhfgdfgdfdhfd")
//              let item2 =   UISearchSuggestionItem(localizedSuggestion: "gdhfgdfgdfdhfd")
//              searchController.searchSuggestions = [item1,item2]
//              searchController.searchControllerObservedScrollView = resultsController.serchListCollectionView
//
//          } else {
//              
//              // Fallback on earlier versions
//          }
          if #available(tvOS 13.0, *) {
              searchController.overrideUserInterfaceStyle = .dark
          } else {
              // Fallback on earlier versions
          }
        searchController.searchBar.delegate = resultsController
        searchController.searchBar.keyboardAppearance = .dark
          
          let searchContainerViewController = UISearchContainerViewController(searchController: searchController)
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
    
    func updatedSearchSuggestions(searchSuggestionModel: [String?]) {
        
        print("Search suggestion delegate")
        if #available(tvOS 14.0, *) {
            
            var searchModel = [UISearchSuggestionItem]()
//            searchModel.removeAll()
            let searchController = UISearchController(searchResultsController: resultsController)
            for item in searchSuggestionModel{
                searchModel.append(UISearchSuggestionItem(localizedSuggestion: item!))

            }
            let item2 =   UISearchSuggestionItem(localizedSuggestion: "testing data")

            searchController.searchSuggestions = [item2]
            searchController.searchResultsUpdater = resultsController
           
        }
       
        

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
