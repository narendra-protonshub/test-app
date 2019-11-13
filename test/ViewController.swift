//
//  ViewController.swift
//  test
//
//  Created by Narendra Thakur on 13/11/19.
//  Copyright © 2019 Narendra Thakur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    var arrListData = NSMutableArray()
    var refreshControl = UIRefreshControl()
   var currentValue = 0
   var isDataLoading:Bool=false
   var pageNo:Int=1
   var limit:Int=20
   var offset:Int=0 //pageNo*limit
   var didEndReached:Bool=false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        Ws_getAllList()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tblView.addSubview(refreshControl)
        lblCount.text = "Aligina" + "(" + "0" + ")"
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(sender:AnyObject) {
       self.tblView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func Ws_getAllList() {
        
        if HelperClass.isInternetAvailable {
            //let param = [String:Any]()
            // param = [WebServiceConstant.username:userName]
            
            //SwiftLoader.show(animated: true)
            WebService.createRequestAndGetResponse("https://hn.algolia.com/api/v1/search_by_date?tags=story&", methodType: .GET, andHeaderDict: [:], andParameterDict:["page":pageNo], onCompletion: { (dictResponse, error, reply, statusCode) in
                let json = dictResponse! as[String: Any] as NSDictionary
                print("json>>>>\(json)")
                SwiftLoader.hide()
                var msg = ""
                msg = json.GetString(forKey: WebServiceConstant.msg)
                if msg == "" {
                    msg = MessageStringFile.serverError()
                }
                if json.count > 0 {
                    
                    if statusCode == WS_Status.success {
                      
                            let dict: NSMutableDictionary = NSMutableDictionary(dictionary: json)
                            self.arrListData = dict.GetNSMutableArray(forKey: "hits")
                            self.tblView.reloadData()
                        
                    } else {
                        PopUpView.addPopUpAlertView(MessageStringFile.whoopsText(), leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: msg, secondLblTitle: "")
                        PopUpView.sharedInstance.delegate = nil
                    }
                } else {
                    PopUpView.addPopUpAlertView(MessageStringFile.whoopsText(), leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: msg, secondLblTitle: "")
                    PopUpView.sharedInstance.delegate = nil
                }
            })
        } else {
            PopUpView.addPopUpAlertView(MessageStringFile.whoopsText(), leftBtnTitle:MessageStringFile.okText() , rightBtnTitle:"" , firstLblTitle: MessageStringFile.networkReachability(), secondLblTitle: "")
            PopUpView.sharedInstance.delegate = nil
        }
        
    }
    

}



extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 106
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! titleCell
          let dict :NSMutableDictionary = self.arrListData.getNSMutableDictionary(atIndex: indexPath.row)
               print("dictnew",dict)
               cell.lblTitle.text = dict.GetString(forKey: "title")
               cell.lblCreationDate.text = dict.GetString(forKey: "created_at")
        cell.switch.tag = indexPath.row
        // for detect which row switch
        cell.switch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
  
        
            return cell
    }
    @objc func switchChanged(_ sender : UISwitch!){
        
        if sender.isOn {
            currentValue += 1
            lblCount.text = "Aligina" + "(" + "\(currentValue)" + ")"
            
        } else {
            currentValue -= 1
            lblCount.text = "Aligina" + "(" + "\(currentValue)" + ")"

           
             
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
    }
 func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }

//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
//    }
//    //Pagination
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//            print("scrollViewDidEndDragging")
//            if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
//            {
//                if !isDataLoading{
//                    isDataLoading = true
//                    self.pageNo=self.pageNo+1
//                    self.limit=self.limit+10
//                    self.offset=self.limit * self.pageNo
//                   Ws_getAllList()
//
//                }
//            }
//
//
//    }
    
    }

class titleCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblCreationDate: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBAction func switchValue(_ sender: Any) {
    }
}
