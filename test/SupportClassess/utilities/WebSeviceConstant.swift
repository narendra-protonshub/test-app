//

import Foundation
import UIKit

class WebServicesLink: NSObject {
    
    static let  BaseUrl = "http://stakesolution.com/handy/webservices/"
    
    class var baseUrl: String {
        get {
            if let dict = UserDefaults.standard.dictionary(forKey: AppUserDefault.baseUrlData) {
                let dictData = dict as NSDictionary
                let baseUrl = dictData.GetString(forKey: "baseurl")
                if baseUrl.Length > 0 {
                    return baseUrl
                }
            }
            return WebServicesLink.BaseUrl.replacingOccurrences(of: "baseurl", with: "")
        }
    }
    
    func getToken() -> [String: AnyObject]{
        let dict : NSDictionary = AppUserDefault.getUserDetails()//
        let tkn  = HelperClass.checkObjectInDictionary(dictH: dict, strObject: "token")
        if tkn != ""{
           
            let header = ["token": tkn]
            // "content_type":"application/x-www-form-urlencoded"
            return header as [String : AnyObject]
        }
        return  [ : ]
    }
   
    func getProfileImage()-> String{
        var imgStr = String()
        let dict:NSDictionary = AppUserDefault.getBaseUrlData()!
        
        imgStr = dict.GetString(forKey:  "picture")
        return imgStr
    }
    
   
    class var getGeslist: String {
           get {
               return (baseUrl + "gas.php?action=gas")
           }
       }
    class var getWaterlist: String {
              get {
                  return (baseUrl + "water.php?action=water")
              }
          }
    
    class var Registration: String {
        get {
            return (baseUrl + "registration.php?action=")
        }
    }
    class var updateProfile: String {
        get {
            return (baseUrl + "/updateprofile.php?action=updateprofile&")
        }
    }
    
    class var getDistrict: String {
        get {
            return (baseUrl + "district.php?action=district")
        }
    }
    class var forgotPassword: String {
        get {
            return (baseUrl + "forgotpassword.php?action=forgotpassword&")
        }
    }
    
    class var updatePassword: String {
        get {
            return (baseUrl + "generatepassword.php?action=generatepassword&UserPass=")
        }
    }
    
    class var Fulladvertise: String {
        get {
            return (baseUrl + "fulladvt/api_all")
        }
    }
    
    class var show_Rewards: String {
        get {
            return (baseUrl + "reward/api_view?")
        }
    }
  
  class var Add_Rewardpoint: String {
        get {
            return (baseUrl + "reward/api_add?")
        }
    }
    
  
    class var aboutApp: String {
        get {
            return (baseUrl + "about/api_all")
        }
    }
    
    class var UpdateProfile: String {
        get {
            return (baseUrl + "customer/api_update?")
        }
    }
    class var ChangePasword: String {
        get {
            return (baseUrl + "changepassword.php?action=changepassword&UserPass=")
        }
    }
    
    
    class var login: String {
        get {
            return (baseUrl + "login.php?action=")
        }
    }
    class var bannerList: String {
        get {
            return (baseUrl + "home.php?action=home")
        }
    }
    class var myPlan: String {
        get {
            return (baseUrl + "myplan.php?action=myplan&UserId=")
        }
    }
    class var notification: String {
        get {
            return (baseUrl + "notification.php?action=notification&UserId=")
        }
    }
    
    class var addFavAddress: String {
        get {
            return (baseUrl + "address/api_add?")
        }
    }
    
    class var GetFavAddress: String {
        get {
            return (baseUrl + "address/api_view?")
        }
    }
    
    class var DeleteFavAddress: String {
        get {
            return (baseUrl + "address/api_delete?")
        }
    }
    class var log_out: String {
        get {
            return (baseUrl + "customer/customer/api_logout?")
        }
    }
    
    class var category_list: String {
        get {
            return (baseUrl + "reward/api_all_category?")
        }
    }
    class var redeem_list: String {
        get {
            return (baseUrl + "reward/reward/api_redim?")
        }

    }
    class var redeem_history: String {
        get {
            return (baseUrl + "reward/api_redim_history?")
        }
    }
    
    class var upload_ticket: String {
        get {
            return (baseUrl + "reward/api_add_ticket?")
        }
    }
    
    
}
class WebServiceConstant: NSObject {
    static let status = "STATUS"
     static let Error = "FAIL"
    static let success = "SUCCESS"
    static let msg = "message"
    static let result = "DATA"
    static let baseurl = "base_url"
    static let customer = "customer"
    static let email = "email"
    static let mobile_number = "mobile_number"
    static let password = "password"
    static let confirm_Password = "confirmPassword"
   
    static let newpassword = "new"
    static let oldpassword = "current"
    static let repassword = "re"
    static let user_type = "user_type"
    static let picture = "picture"
    static let birthmonth = "birthmonth"
    static let point = "point"
    static let aboutApp = "about"
    static let user_id = "user_id"
    static let id = "id"
    /*social_key,social_type*/
    static let socialType = "social"
    static let profile_image = "picture"
    static let profile_id = "profileID"
    static let first_name = "fname"
    static let last_name = "lname"
   
   
    
    //Jdata_dod
    static let device_type = "device"
    static let app_version = "app_version"
    static let os_version = "os_version"
    static let network_type = "network_type"
    static let network_provider = "network_provider"
    
    static let name = "name"
    static let address = "address"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let addressID    = "addressID"
    static let productID = "productID"
    
}

struct WS_Status {
    static let success:  UInt = 200
    static let error204: UInt = 204
    static let error401: UInt = 401
    static let error422: UInt = 422
}

