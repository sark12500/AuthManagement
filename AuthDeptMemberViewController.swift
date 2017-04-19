//
//  AuthDeptMemberViewController.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/16.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//
import UIKit


class AuthDeptMemberViewController: UITableViewController,AuthExtension {
    
    var users = [AuthQueryUser]()
    var deptCode = ""
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Setup navigation
        navigationBarSetting()
        
        // Setup table view
        tableViewSetting()
        
        // Setup pull to refresh
        //refreshControlSetting()
    
        getDataApi()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func navigationBarSetting(){
    
        guard let _ = self.navigationController else{return}
        
        let goBackBotton = UIBarButtonItem(title: localization("Back") , style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AuthDeptMemberViewController.goBack))
        goBackBotton.image = UIImage(named: "btn_prev")
        self.navigationItem.leftBarButtonItem = goBackBotton
        self.navigationItem.leftBarButtonItem!.tintColor = UIColor.whiteColor()
    }
    
    func goBack()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableViewSetting() {
        tableView.rowHeight = 56
//        tableView.emptyDataSetSource = self
//        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }
    
    func refreshControlSetting(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AuthDeptMemberViewController.pullToRefresh), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    func pullToRefresh() {        
        getDataApi()
    }
    
    func getDataApi() {
        
        //bLock ui
        bLockAll()
        
        let userInfo  = NSUserDefaults.standardUserDefaults()
        let companyId = userInfo.stringForKey("CompanyId")!
        //let deptCode  = self.deptCode.componentsSeparatedByString("-")[1]

        let param = ["QueryString":self.deptCode,"ComId":companyId]
        
        let apiMgr = AuthApiManager(param: param, delegate: self)
        apiMgr.getDepartmentNextLevel()
    }

    
    //MARK:UITableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    
    //MARK:UITableView header footer
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.userInteractionEnabled = false
        
        let user = users[indexPath.row]
        
        let imageName = user.memberType.getImg()
        
        let image = UIImage(named:imageName)
        if let imageView = cell.imageView {
            imageView.image = image
        }
        
        cell.textLabel?.text = user.name
        var detailText = ""
        switch user.memberType
        {
        case .Dept:
            detailText = user.id //部門顯示id
            break
        default:
            detailText = user.email//user顯示email
            break
        }
        
        cell.detailTextLabel?.text = detailText
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        
        return cell
    }
}

//MARK: API ------------------
extension AuthDeptMemberViewController: AuthApiDelegate
{
    func getDepartmentNextLevelSuccess(data: AnyObject) {
        
        print("API SUCCESS !!!!!!!!!!!!!!!!!!! getDeptGroupSuccess")
        
        unBLockAll()
        refreshControl?.endRefreshing()
        
//        "data": [
//        {
//        "DeptPlant": "QCI",
//        "DeptCode": "QCI_0T204",
//        "DeptChineseName": "管理資訊中心資訊應用處應用二部",
//        "DeptLayerCode": "QCI_0T200",
//        "DeptEnterpriseCode": "QCI_0T000"
//        },
        
        var data    = JSON(data)
        let code    = data["code"]
        let message = data["message"].string
        
        
        switch code {
        case 0:
            
            
            break
        default:
            
            if let msg = message {
                alertHandler( msg , message:"" , delay:1.5 )
            }
            
            return
            
        }
        
        self.users.removeAll()
        let datas = data["data"].arrayValue
        for subJson:JSON in datas {
            self.users.append(AuthQueryUser(json: subJson))
        }
        
        tableView.reloadData()
        
        if self.users.count == 0 {
             alertHandler( localization("AuthNoData") , message:"" , delay:1 )
        }
        
//        users =
//            [AuthRoleUser(id:"Charles.Huang@quantatw.com",
//            name:"黃阿強",
//            roleId:"",
//            solutionName:"",
//            memberType: AuthMemberType.User,
//            selected: false ),
//            AuthRoleUser(id:"0R602",
//                name:"SaaS開發一部",
//                roleId:"",
//                solutionName:"",
//                memberType: AuthMemberType.Dept,
//                selected: false),
//            AuthRoleUser(id:"Peggy.Wu@quantatw.com",
//                name:"吳PG",
//                roleId:"",
//                solutionName:"",
//                memberType: AuthMemberType.User,
//                selected: false),
//            AuthRoleUser(id:"0T202",
//                name:"OA應用課",
//                roleId:"",
//                solutionName:"",
//                memberType: AuthMemberType.Dept,
//                selected: false)]
        
    }
    
    func getDepartmentNextLevelFail(data:String) {
        
        print("API Fail !!!!!!!!!!!!!!!!!!! getDeptGroupFail: " + data )
        alertHandler( localization("AuthServerError") , message:"" , delay:1.5 )
        unBLockAll()
        refreshControl?.endRefreshing()
        
        
    }
}

//extension AuthDeptMemberViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
//{
//    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
//        let str = localization("AuthNoData")
//        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
//    
////    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
////        let str = localization("AuthEnterQueryString")
////        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
////        return NSAttributedString(string: str, attributes: attrs)
////    }
//    
//    //    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
//    //        return UIImage(named: "tab_center_selected")
//    //    }
//    
//    //    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
//    //        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .Alert)
//    //        ac.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
//    //        presentViewController(ac, animated: true, completion: nil)
//    //    }
//    //    // ios 8.0 up
//    //    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
//    //        let str = "Add Member"
//    //        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
//    //        return NSAttributedString(string: str, attributes: attrs)
//    //    }
//}

//MARK: AuthBlockUI
extension AuthDeptMemberViewController: AuthBlockUI
{
    func unBLockAll(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        //self.navigationItem.rightBarButtonItem?.enabled = true
    }
    func bLockAll(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = localization("Loading...")
        //self.navigationItem.rightBarButtonItem?.enabled = false
    }
}
