//
//  SearchViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 30/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import Reachability
import CoreData

class HomeSearchViewController: UIViewController,UISearchControllerDelegate {


    @IBOutlet weak var NoResultView: UIView!
    
    @IBOutlet weak var NoResultLabel: UILabel!
    @IBOutlet weak var serchListCollectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView?
    @IBOutlet weak var contentView: UIView!
//    @IBOutlet weak var noresultView: UIView!
    var searchArray = [VideoModel]()
    var type = ""
    var keyboardHeight = CGFloat()
    var serchHistoryArray = [String]()
    var serchHistoryArrayReverse = [String]()
    var channelSearchHistoryArray = [String]()
    var channelSearchHistoryArrayReverse = [String]()
//    var reachability = Reachability()
    let searchTableView: UITableView = UITableView()
    var searchListView = UIView()
    var searchString = ""
    var categoryId = ""
    var liveflag = ""
    private var myLabel : UILabel!
    let reachability = try! Reachability()

//    let searchController = UISearchController(searchResultsController: HomeSearchViewController())

    
    override func viewDidLoad() {
        print("viewDidLoad")

               
//        let searchContainer = UISearchContainerViewController(searchController: searchController)
//      self.searchController.searchResultsUpdater = self
//        let searchContainer = UISearchContainerViewController(searchController: searchController)
//        searchContainer.title = "Search for stuff"
//
//      self.searchController.delegate = self
//      self.searchController.searchBar.delegate = self
//      self.searchController.hidesNavigationBarDuringPresentation = false
//      self.searchController.obscuresBackgroundDuringPresentation = false
//      searchController.searchBar.sizeToFit()
//      searchController.searchBar.becomeFirstResponder()
//      self.navigationItem.titleView = searchController.searchBar
//      self.definesPresentationContext = true
//      self.searchController.searchBar.placeholder = "Search"
     

      
//         self.retrieveData()
//         if serchHistoryArray.count > 0 {
//                serchHistoryArrayReverse = serchHistoryArray.reversed()
//                searchTableView.reloadData()
//              }
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")

            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
     
    }


    func setUpUI() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        serchListCollectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "searchCell")
        serchListCollectionView.collectionViewLayout = layout
        serchListCollectionView.backgroundColor = .black
        serchListCollectionView.delegate = self
        serchListCollectionView.dataSource = self
        self.NoResultView.isHidden = false
        self.NoResultView.backgroundColor = .black
        
        self.NoResultLabel.text = "Search for TV shows , movies and categories"
        DispatchQueue.main.async {
            print("viewwillappear called")
            self.serchListCollectionView.reloadData()

        }
//     let tabbarvc = HomeTabBarViewController()
//
//
//
//             let searchController = UISearchController(searchResultsController: self)
////        searchController.searchResultsUpdater = self
////
//             searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = true
//        searchController.hidesNavigationBarDuringPresentation = false
//
//        let searchPlaceholderText = NSLocalizedString("Search Title", comment: "")
//        searchController.searchBar.placeholder = searchPlaceholderText
//        searchController.searchBar.tintColor = UIColor.black
//        searchController.searchBar.barTintColor = UIColor.black
//        searchController.searchBar.searchBarStyle = .minimal
////        searchController.searchBar.frame = CGRect(x: 200, y: 300, width: 300, height: 200)
////        searchController.searchBar.delegate = self
////        searchController.searchBar.delegate = self; searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
//        let searchContainerViewController = UISearchContainerViewController(searchController: searchController)
//        let navController = UINavigationController(rootViewController: searchContainerViewController)
//        navController.view.backgroundColor = UIColor.black
//        if var tbViewController = tabbarvc.viewControllers{
//
//            //tbViewController.append(navController)
//            //Inserts Search into the 3rd array position
//            tbViewController.insert(navController,at: 4)
//            tabbarvc.viewControllers = tbViewController
//        }
//        guard let rootViewController = view.window?.rootViewController else { fatalError("Unable to get root view controller.") }
//        view.addSubview(searchContainerViewController.searchController.searchBar)
//        self.present(searchContainerViewController, animated: true, completion: nil)

    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
  
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")

    }
   
    
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//   self.searchListView.isHidden = false
    
    self.serchListCollectionView.isHidden = false
    setUpUI()
    
   
//    searchTableView.reloadData()
    }
    
    
    // MARK: Api Calls
    @objc func getSearchResults(searchKeyword: String!) {
        print("getSearchResults")
        commonClass.startActivityIndicator(onViewController: self)
        ApiCommonClass.getHomeSearchResults(searchText: searchKeyword, searchType: type , category: categoryId,liveflag:liveflag) { (responseDictionary: Dictionary) in
            
            self.searchArray.removeAll()

            if  responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    self.searchListView.isHidden = true
                    self.NoResultView.isHidden = false
                    self.NoResultLabel.text = "Oops! Something went wrong,"
                    self.serchListCollectionView.isHidden = true
                }
            } else {
                self.searchArray = responseDictionary["Channels"] as! [VideoModel]
                print(self.searchArray.count)
                

                if self.searchArray.count == 0 {

                    print("response dictionory empty array = \(responseDictionary)")
                    DispatchQueue.main.async {
                        self.searchListView.isHidden = true
                        self.NoResultView.isHidden = false
                        self.serchListCollectionView.isHidden = true
                        self.NoResultLabel.text = "No Results Found"
                        commonClass.stopActivityIndicator(onViewController: self)

                        
                    }
                } else {
                    print("response dictionory = \(responseDictionary)")
                    DispatchQueue.main.async {
                        commonClass.stopActivityIndicator(onViewController: self)

                        self.searchListView.isHidden = true
                        self.NoResultView.isHidden = true
                        self.serchListCollectionView.isHidden = false
                        self.serchListCollectionView.reloadData()
                       
                    }
                }
            }
        }
    }
}

extension HomeSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
       
        if let previousIndexPath = context.previouslyFocusedIndexPath ,
           let cell = serchListCollectionView.cellForItem(at: previousIndexPath) {
            print("previousIndexPath")
            cell.contentView.layer.borderWidth = 0.0
            cell.contentView.layer.shadowRadius = 0.0
            cell.contentView.layer.shadowOpacity = 0
        }

        if let indexPath = context.nextFocusedIndexPath,
           let cell = serchListCollectionView.cellForItem(at: indexPath) {
            print("nextFocusedIndexPath")
            cell.contentView.layer.borderWidth = 6.0
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.contentView.layer.cornerRadius = 8

        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 30, bottom:30, right: 30)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let width = (self.view.frame.size.width) / 3.3
//        flowlayout.itemSize = CGSize(width: view.bounds.width/3.3, height: UIScreen.main.bounds.height * 0.3)

        return CGSize(width: view.bounds.width/5, height:  UIScreen.main.bounds.height * 0.2 + 30);
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionCell
        cell.backgroundColor = .clear
        cell.imageView.layer.masksToBounds = true
        cell.imageView.contentMode = .scaleToFill
        cell.imageView.layer.cornerRadius = 8
        if searchArray[indexPath.item].video_id == nil{
            // it is a show
            if searchArray[indexPath.row].logo_thumb != nil {
                cell.imageView.sd_setImage(with: URL(string: ((showUrl + searchArray[indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder400*600"))
            }
            else {
                cell.imageView.image = UIImage(named: "placeHolder400*600")
            }
            
            if searchArray[indexPath.row].show_name != nil{
                cell.videoNameLabel.text = searchArray[indexPath.row].show_name
            }
            else{
                cell.videoNameLabel.text = " "

            }
           
        }
        else{
            // it is a video
            if searchArray[indexPath.row].logo_thumb != nil {
                cell.imageView.sd_setImage(with: URL(string: ((showUrl + searchArray[indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder400*600"))
                

            }
            else {
                cell.imageView.image = UIImage(named: "placeHolder400*600")
            }
            if searchArray[indexPath.row].show_name != nil{
                cell.videoNameLabel.text = searchArray[indexPath.row].show_name
            }
            else{
                cell.videoNameLabel.text = " "

            }
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didselect search")
        if  searchArray[indexPath.item].video_id != nil {
            print("didselect episode")

            let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
            signupPageView.selectedvideoItem = searchArray[indexPath.item]
            signupPageView.showId = searchArray[indexPath.item].show_id!
            self.present(signupPageView, animated: true, completion: nil)
           
          
        }
        else{
            print("didselect show")
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
            videoDetailView.videoItem = searchArray[indexPath.item]
                videoDetailView.fromCategories = false
            self.present(videoDetailView, animated: true, completion: nil)

    }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("hjdasvhjdv")
    }
   
    //// MARK: CoreData
    
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    func retrieveData() {
        if type == "channel" {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChannelSearch")
            do {
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    let value  = data.value(forKey: "searchChannelText") as! String
                    if !channelSearchHistoryArray.contains(value){
                        channelSearchHistoryArray.append(value)
                    }
                }
            } catch {
                print("Failed")
            }
        } else {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            do {
                let result = try managedContext.fetch(fetchRequest)
                if result.isEmpty{
                    serchHistoryArray.removeAll()
                }
                else{
                for data in result as! [NSManagedObject] {
                    let value  = data.value(forKey: "searchText") as! String
                    if !serchHistoryArray.contains(value){
                        serchHistoryArray.append(value)
                    }
                }
                }
                
            } catch {
                print("Failed")
            }
        }
    }

}
extension HomeSearchViewController:UISearchResultsUpdating  {

  
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == ""{
            
        }
        else{
//            getSearchResults(searchKeyword: searchController.searchBar.text ?? "")
            
        }
       }

}
extension HomeSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("heloo")
        if let searchString = searchBar.text, !searchString.isEmpty {
            self.view.endEditing(true)
            searchBar.resignFirstResponder()
             if searchString.trimmingCharacters(in: .whitespaces) != "" {
                getSearchResults(searchKeyword:searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
              
            }
        }
  }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
        if let searchString = searchBar.text, !searchString.isEmpty {
            
                getSearchResults(searchKeyword:searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
               
            }
        

    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")

    }
 
   
}

