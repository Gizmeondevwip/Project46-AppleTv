//
//  PartnerViewController.swift
//  HappiAppleTV
//
//  Created by GIZMEON on 09/02/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class PartnerViewController: UIViewController {
    @IBOutlet weak var PartnerImage: UIImageView!
    @IBOutlet weak var PartnerTableView: UITableView!
    @IBOutlet weak var PartnerNameLabel: UILabel!
    @IBOutlet weak var PartnerDescriptionLabel: UILabel!
    
    @IBOutlet weak var PartnerDescriptionHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var ImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ImageViewWidth: NSLayoutConstraint!
    
    var dianamicVideos = [VideoModel]()
    var Categories = [VideoModel]()
     var categoryModel: VideoModel!
     var categoryId = Int()
    var titleImage = String()
    var partnerDescription1 = String()
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3
    var partnerName = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib2 =  UINib(nibName: "CommonTableViewCell", bundle: nil)
        PartnerTableView.register(nib2, forCellReuseIdentifier: "mainTableViewCell")
        PartnerTableView.delegate = self
        PartnerTableView.dataSource = self
        view.backgroundColor = .black
        self.PartnerImage.backgroundColor = .black
        getPartnerVideos()
        let bgView = UIView(frame: PartnerTableView.bounds)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = PartnerTableView.frame
        gradientLayer.colors =
            [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.8).cgColor]

        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)

        bgView.layer.insertSublayer(gradientLayer, at: 0)
        PartnerTableView.backgroundView = bgView

        self.ImageViewWidth.constant = (view.frame.width/6)
        self.ImageViewHeight.constant = (view.frame.height/2.3)
        self.PartnerDescriptionHeight.constant = (view.frame.height/2.3)

        
    }
    
    var VideoNameLabelHeight = CGFloat()

    var ShowData = [PartnerModel]()
        func getPartnerVideos() {
           
          Categories.removeAll()
          var parameterDict: [String: String?] = [ : ]
   
            parameterDict["key"] = String(categoryModel.partner_id!)

          parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
          parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
          parameterDict["device_type"] = "ios-phone"
          parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
            let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - ImageViewWidth.constant, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            var font = UIFont.boldSystemFont(ofSize:24)



            ApiCommonClass.getPartnerByPartnerid(parameterDictionary: parameterDict as? Dictionary<String, String>) { [self] (responseDictionary: Dictionary) in
            
           
            if responseDictionary["error"] != nil {
                  DispatchQueue.main.async {
                    self.PartnerTableView.reloadData()
                
                  }
                } else {
              
                if responseDictionary["partner_image"] != nil{
                    self.titleImage = responseDictionary["partner_image"] as! String
                     self.PartnerImage.sd_setImage(with: URL(string: ((imageUrl + self.titleImage).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder400*333"))
                    print(showUrl + self.titleImage)
                }
                 if responseDictionary["partner_description"] != nil{
                 
                             self.partnerDescription1 = responseDictionary["partner_description"] as! String
                    self.PartnerDescriptionLabel.text = self.partnerDescription1
                    VideoNameLabelHeight =      label.heightForLabel(text: self.self.partnerDescription1, font: font, width: view.frame.width - ImageViewWidth.constant)
                    print(VideoNameLabelHeight)
                    if VideoNameLabelHeight < ImageViewHeight.constant{
                        PartnerDescriptionHeight.constant = VideoNameLabelHeight
                    }
                    else{
                        PartnerDescriptionHeight.constant = ImageViewHeight.constant
                    }
                }
                if responseDictionary["partner_name"] != nil{
                            self.partnerName = responseDictionary["partner_name"] as! String
                    self.PartnerNameLabel.text = self.partnerName
                    
                   
                }
               
               
                
                    self.dianamicVideos.removeAll()
                    if responseDictionary["data"] != nil{
                        self.dianamicVideos = responseDictionary["data"] as! [VideoModel]
                        if self.dianamicVideos.count == 0 {
                            DispatchQueue.main.async {
                                self.PartnerTableView.reloadData()
                                
                                self.PartnerTableView.isHidden = false
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.PartnerTableView.reloadData()
                                
                                self.PartnerTableView.isHidden = false
                                
                                
                            }
                        }
                }
            }
            
            
            }
        }
}
extension PartnerViewController:UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dianamicVideos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath) as! CommonTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.videoType = "Partner"
        cell.videoArray = self.dianamicVideos[indexPath.section].videos
        cell.delegate = self

        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
        return rowHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
            if self.dianamicVideos[section].videos!.isEmpty {
                return 0
            }
        
        return (rowHeight) * 0.2 - 30
    }
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.textColor = ThemeManager.currentTheme().UIImageColor
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)

        titleLabel.frame = CGRect(x: 8, y: 0, width: view.bounds.width, height: (rowHeight) * 0.2 - 20).integral
        
        titleLabel.text =  dianamicVideos[section].show_name

        headerView.addSubview(titleLabel)
        headerView.backgroundColor = .clear
        return headerView
    }
    
}
extension PartnerViewController: CommonVideoTableViewCellDelegate  {
    func didSelectHomeVideos(passModel: VideoModel?) {
        
    }
    
   
    
   
    func didSelectFreeShows(passModel: VideoModel?) {
        print("hello")
    }
    
    func didSelectNewArrivals(passModel: VideoModel?) {
        print("hello")

    }
    
    func didSelectThemes(passModel: VideoModel?) {
        print("hello")

    }
    
    func didSelectDianamicVideos(passModel: VideoModel?) {
        print("hello")

    }
    
    func didSelectPartner(passModel: VideoModel?) {
        let video = passModel
          print("video id = \(video)")
        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
        signupPageView.selectedvideoItem = passModel
        self.present(signupPageView, animated: true, completion: nil)
    }
    
    func didFocusFreeShows(passModel: VideoModel) {
        print("hello")

    }
    
    func didFocusNewArrivals(passModel: VideoModel) {
        print("hello")

    }
    
    func didFocusThemes(passModel: VideoModel) {
        print("hello")

    }
    
    func didFocusDianamicVideos(passModel: VideoModel) {
        print("hello")

    }
    
    func didFocusPartner(passModel: VideoModel) {
        print("hello")
    }
    
}
extension UILabel {

    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
