//
//  AuthAddMemberViewController.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/4/21.
//  Copyright © 2016年 DoubleTap Mobile. All rights reserved.
//

import UIKit

protocol AuthMemberAddDelegate {
    //新增成員後觸發事件
    func didFinishMemberAdd()
}

class AuthAddMemberViewController: UIViewController, UITextFieldDelegate, AuthExtension {

    var delegate: AuthMemberAddDelegate?

    //@IBOutlet dynamic weak var tab: UISegmentedControl!
    @IBOutlet dynamic weak var tableView: UITableView!
    @IBOutlet dynamic weak var collectionView: UICollectionView!
    
    @IBAction func memberTypeBtnClick(sender: AnyObject) {
        
        if #available(iOS 8.0, *) {
            let memberSheet = UIAlertController(title: nil, message: localization("AuthSearchType"), preferredStyle: .ActionSheet)

            let cancelAction = UIAlertAction(title: localization("common_cancel"), style: .Cancel, handler:{
                (action:UIAlertAction!) -> Void in
                // do nothing...
            });
            let userAction = UIAlertAction(title: localization("AuthMember"), style: .Default, handler:{
                (action:UIAlertAction!) -> Void in
                self.memberType = AuthMemberType.User
                //self.tableView.reloadData()
            });
            let deptAction = UIAlertAction(title: localization("AuthDept"), style: .Default, handler:{
                (action:UIAlertAction!) -> Void in
                self.memberType = AuthMemberType.Dept
                //self.tableView.reloadData()
            });
            let comAction = UIAlertAction(title: localization("AuthCom"), style: .Default, handler:{
                (action:UIAlertAction!) -> Void in
                self.memberType = AuthMemberType.Company
                self.getDataApi()

            });
            let otherCompanyUserAction = UIAlertAction(title: localization("AuthNonComMember") ,style: .Default, handler:{
                (action:UIAlertAction!) -> Void in
                self.memberType = AuthMemberType.OtherCompanyUser
                //self.tableView.reloadData()
            });
            
            //規則：
            //1.Ower只能公司成員加入
            //2.billingType = b001不可使用部門,公司加入 
            //3.control table canAddOthertCom 控制其他公司成員加入
            
            memberSheet.addAction(cancelAction)
            memberSheet.addAction(userAction)
            
            let isOwner = roleViewModel.getThisRoleListRow().isOwner
            
            if isOwner == false {
                
                let billingType = productViewModel.getThisProductBillingType()
                let canQueryOtherCom = productViewModel.getThisProductCanQueryOtherCom()

                switch billingType
                {
                case "b001":
                    break
                default:
                    memberSheet.addAction(deptAction)
                    memberSheet.addAction(comAction)
                    break
                }
                
                if canQueryOtherCom {
                    memberSheet.addAction(otherCompanyUserAction)
                }
            }
            
            self.presentViewController(memberSheet, animated: true, completion: nil);

        }
        
    }
    
    @IBOutlet dynamic weak var memberTypeBtn: UIButton!
    @IBOutlet dynamic weak var searchBar: UITextField!

    var memberType = AuthMemberType.User
    {
        didSet {
            searchBar.enabled = true
            searchBar.becomeFirstResponder()
            
            // 預設為自己公司
            if memberType == AuthMemberType.Company {
                
                searchBar.enabled = false
                searchBar.text?.removeAll()
            }
            
            searchBar.placeholder = memberType.getPlaceholder()
            
            //modify title
            self.title = localization("common_add") + " " + memberType.getTypeName()
            // remove table view
            queryAry.removeAll()
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    private let lineColorValue:CGFloat   = 204/255
    private let lineColorAlpha:CGFloat   = 0.5
    private let lineWidth:CGFloat        = 1
    
    //查詢出來的成員
    var queryAry = Array<AuthQueryUser>()
    //帶新增的成員
    var addAry = Array<AuthQueryUser>()
    {
        didSet
        {
            //有待新增成員才可按完成
            doneBtnSetting()
        }
    }
    
    let roleViewModel = AuthRoleViewModel.instance
    let productViewModel = AuthProductViewModel.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberType = AuthMemberType.User
        
        searchBarSetting()
        
        tableViewSetting()
        
        navigationBarSetting()
        
        collectionViewSetting()
        
        //segmentedControlSetting()

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableViewSetting(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        
        tableView.registerNib(UINib(nibName: "AuthSelectedCell", bundle: nil), forCellReuseIdentifier: "AuthSelectedCell")
        tableView.registerNib(UINib(nibName: "AuthSelectedComCell", bundle: nil), forCellReuseIdentifier: "AuthSelectedComCell")
        
        
//        tableView.emptyDataSetSource = self
//        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }
    
    func collectionViewSetting(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .Horizontal
        }
        collectionView.registerNib(UINib(nibName: "AuthAddCell", bundle: nil), forCellWithReuseIdentifier: "AuthAddCell")
        
        //畫框框
        collectionView.layer.borderWidth = lineWidth
        collectionView.layer.borderColor = UIColor( red: lineColorValue, green: lineColorValue, blue:lineColorValue, alpha: lineColorAlpha).CGColor
    }
    
    func navigationBarSetting(){
        
        guard let _ = self.navigationController else{return}
        
        self.navigationController?.navigationBar.translucent = false

        let goCancelBotton = UIBarButtonItem(title: localization("common_cancel"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AuthAddMemberViewController.goCancel))
        let goDoneBotton = UIBarButtonItem(title: localization("common_confirm"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AuthAddMemberViewController.goDone))
        
        self.navigationItem.leftBarButtonItem = goCancelBotton
        self.navigationItem.leftBarButtonItem!.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = goDoneBotton
        self.navigationItem.rightBarButtonItem!.tintColor = UIColor.whiteColor()
        
        //有待新增成員才可按完成
        doneBtnSetting()
        
    }
    
    func goCancel()
    {
        dismissKeyboard()
        self.dismissViewControllerAnimated(true, completion: nil )
    }
    
    func goDone()
    {
        //print("Done !!!")
        addDataApi()
    }
    
    func doneBtnSetting(){
        let hasValue = addAry.count > 0
        self.navigationItem.rightBarButtonItem!.enabled = hasValue
        //deleteBtn.setTitleColor(hasValue ? UIColor.redColor() : UIColor.lightGrayColor(), forState: .Normal)
    }
    
    func selectedCount() -> Int{
        
        return queryAry.filter{ $0.selected == true }.count
    }
    
    func searchBarSetting(){
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AuthAddMemberViewController.dismissKeyboard))
        //重要：不會擋到其view
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        searchBar.becomeFirstResponder()
        searchBar.returnKeyType = UIReturnKeyType.Search
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.delegate = self
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // keyboard search btn click
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        searchBar.resignFirstResponder()
        
        getDataApi()
        
        return true
    }
    
//    func segmentedControlSetting(){
//        tab.removeSegmentAtIndex(0, animated: true)
//        tab.removeSegmentAtIndex(0, animated: true)
//        tab.insertSegmentWithTitle("公司成員", atIndex: 0, animated: true)
//        tab.insertSegmentWithTitle("部門", atIndex: 1, animated: true)
//        tab.insertSegmentWithTitle("公司", atIndex: 2, animated: true)
//        tab.insertSegmentWithTitle("非公司成員", atIndex: 3, animated: true)
//        
//        tab.selectedSegmentIndex = 0
//        // 跟著文字長度
//        //tab.apportionsSegmentWidthsByContent = true
//        
//
//    }
    
    
    func getDataApi() {
        
        let userInfo  = NSUserDefaults.standardUserDefaults()
        let comId = userInfo.stringForKey("CompanyId")!
        var queryString = ""
        var trimmedString = ""
        let typeIndex = memberType.rawValue
        
        // 消除空格
        if let text = searchBar.text {
            queryString = text
            trimmedString = queryString.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
        }else{
            return
        }
        
        bLockAdd()
        let param = ["QueryString": trimmedString ,"TypeIndex":typeIndex, "ComId":comId]
//        print(queryString)
//        print(trimmedString)
        //let param = ["QueryString": "0t202" ,"TypeIndex":typeIndex, "ComId":comId]
        
        let apiMgr = AuthApiManager(param: param, delegate: self)
        apiMgr.getMember()
    }
    
    func addDataApi() {

        let userInfo  = NSUserDefaults.standardUserDefaults()
        let comId = userInfo.stringForKey("CompanyId")!
        
        let solutionId = productViewModel.SolutionId
        let isOwner = roleViewModel.RoleIsOwner
        let roleId = roleViewModel.RoleId
        var users:Dictionary<String,Int> = [:]
        for item in addAry {
            users.updateValue(item.memberType.rawValue, forKey: item.id)
            print(item.memberType.rawValue)
            print(item.id)
        }
        
        
        //bLock ui
        bLockAll()
        
        let param = ["IsOwner": isOwner ,"SolutionId":solutionId, "RoleId":roleId, "ComId":comId, "Users":users]
        
        let apiMgr = AuthApiManager(param: param, delegate: self)
        apiMgr.addMember()
    }
}

//MARK: table view ------------------
extension AuthAddMemberViewController: UITableViewDataSource
{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return queryAry.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell
    {
//        let user = viewModel.getRoleUserListRow(viewModel.RoleId,userIndex: indexPath.row)
        
        //let checkImg = selectedArray[indexPath.row] ? "a_img_checkbox_checked" :"a_img_checkbox_default"
        
        //let memberImg = user.memberType.getImg()
        
        let user = queryAry[indexPath.row]
        var cell = UITableViewCell()
        
        switch (user.memberType) {
        case .Dept:
            cell = tableView.dequeueReusableCellWithIdentifier("AuthSelectedCell", forIndexPath: indexPath)
            
            let AuthCell = (cell as! AuthSelectedCell)
            AuthCell.configure(user.name,subTitle: user.id,
                memberType: user.memberType, btnSelectd: queryAry[indexPath.row].selected)
            AuthCell.checkBtn.addTarget(self, action: #selector(AuthAddMemberViewController.selectBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            AuthCell.checkBtn.tag = indexPath.row
            AuthCell.next.hidden = false
            break;
        case .Company:
            cell = tableView.dequeueReusableCellWithIdentifier("AuthSelectedComCell", forIndexPath: indexPath)
            
            let AuthCell = (cell as! AuthSelectedComCell)
            AuthCell.configure(user.name,
                memberType: user.memberType, btnSelectd: queryAry[indexPath.row].selected)
            AuthCell.checkBtn.addTarget(self, action: #selector(AuthAddMemberViewController.selectBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            AuthCell.checkBtn.tag = indexPath.row
            AuthCell.next.hidden = true
            break;
            
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("AuthSelectedCell", forIndexPath: indexPath)
            
            let AuthCell = (cell as! AuthSelectedCell)
            AuthCell.configure(user.name,subTitle: user.email,//user.id,
                memberType: user.memberType, btnSelectd: queryAry[indexPath.row].selected)
            AuthCell.checkBtn.addTarget(self, action: #selector(AuthAddMemberViewController.selectBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            AuthCell.checkBtn.tag = indexPath.row
            AuthCell.next.hidden = true
            
            break;
        }
        
        return cell

    }
    
    func selectBtnClick(sender: AnyObject)
    {
        
        //        print("selectBtnClick")
        //        print("\(sender.tag)")
        let index = sender.tag

        let selectedId = queryAry[index].id
        if queryAry[index].selected {
            
            // 如果找的到的話就remove
            for i in addAry.indices {
                //print(addAry[i].id)
                if addAry[i].id == selectedId {
                    addAry.removeAtIndex(i)
                    break
                }
            }
        }
        else {
            
            // 檢查是否已存在
            var isExist = false
            for i in addAry.indices {
                //print(addAry[i].id)
                if addAry[i].id == selectedId {
                    isExist = true
                    break
                }
            }
            
            if isExist == false {
                //加到待加入陣列
                addAry.append(queryAry[index])
                
                //todo: 加入成員後 collection view 移到最後 ??
//                let rightOffset: CGPoint = CGPointMake(collectionView.contentSize.width - collectionView.frame.size.width, 0)
                
//                let csz: CGSize = collectionView.contentSize
//                let bsz: CGSize = collectionView.bounds.size
//                if collectionView.contentOffset.x + bsz.width > csz.width {
//                    collectionView.setContentOffset(CGPointMake(collectionView.contentOffset.x + (csz.width - bsz.width) , collectionView.contentOffset.y ), animated: true)
//                }

                
//                collectionView.setContentOffset(rightOffset, animated: true)
            }
        }
        
        // 勾選或取消
        queryAry[index].selected = !queryAry[index].selected
        
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
}

//MARK: UITableViewDelegate ------------------
extension AuthAddMemberViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.001
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AuthDeptMember") as! AuthDeptMemberViewController
        
        let user = queryAry[indexPath.row]
        switch user.memberType{
        case AuthMemberType.Dept:
            vc.title = user.name
            vc.deptCode = user.id
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            break
        }

    }
}

//MARK: Collection view ------------------
extension AuthAddMemberViewController: UICollectionViewDataSource
{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return addAry.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cellIdentifier = "AuthAddCell"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! AuthAddCell

        let userName = addAry[indexPath.row].name
        let memberType = addAry[indexPath.row].memberType
        cell.configure(userName , memberType: memberType)
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}

//MARK: UICollectionViewDelegate ------------------
extension AuthAddMemberViewController: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.001
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
//        let cell : UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
//        cell.backgroundColor = UIColor.magentaColor()
        
        // 如果找的到的話就修改點選狀態
        let addId = addAry[indexPath.row].id
        //print(addId)
        for i in queryAry.indices {
            //print(queryAry[i].id)
            if queryAry[i].id == addId {
                queryAry[i].selected = false
            }
        }
        
        addAry.removeAtIndex(indexPath.row)
        
        tableView.reloadData()
        collectionView.reloadData()
    }
}

//extension AuthAddMemberViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
//{
//    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
//        let str = localization("AuthNoData")
//        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
//    
//    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
//        let str = localization("AuthEnterQueryString")
//        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
//    
////    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
////        return UIImage(named: "tab_center_selected")
////    }
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

//MARK: API ------------------
extension AuthAddMemberViewController: AuthApiDelegate
{
    func getMemberSuccess(result: AnyObject) {
        
        print("API SUCCESS !!!!!!!!!!!!!!!!!!! getMemberSuccess")
        
        unBLockAdd()
        doneBtnSetting()
        
        var data = JSON(result)
        let code    = data["code"]
        let message = data["message"].string
        
        switch code{
        case 0:
            
            
            break
        default:
            
            if let msg = message {
                alertHandler( msg , message:"" , delay:1.5 )
            }
            
            return
        }
        
        // 更新資料
        queryAry.removeAll()
        
        let datas  = data["data"]
        for (_, subJson): (String, JSON) in datas {
            
            queryAry.append(AuthQueryUser(json: subJson))
        }
        
        tableView.reloadData()
        
        if datas.count == 0 {
            alertHandler( localization("AuthNoData") , message:"" , delay:1 )
            searchBar.becomeFirstResponder()
        }
    }
    
    func getMemberFail(data:String) {
        
        print("API Fail !!!!!!!!!!!!!!!!!!! getMemberFail: " + data )
        
        alertHandler( localization("AuthServerError") , message:"" , delay:1.5 )
        unBLockAll()
        doneBtnSetting()
    }
    
    func addMemberSuccess(result: AnyObject) {
        
        print("API SUCCESS !!!!!!!!!!!!!!!!!!! addMemberSuccess")
        
        unBLockAll()
        doneBtnSetting()
        
        var data = JSON(result)
        let code    = data["code"]
        let message = data["message"].string
        
        switch code{
        case 0:
            
            
            break
        default:
            
            if let msg = message {
                alertHandler( msg , message:"" , delay:1.5 )
            }
            
            return
        }
        
        //刪除後返回前一頁 然後refresh
        tableView.reloadData()
        
        self.dismissViewControllerAnimated(true, completion: nil )
        if delegate != nil{
            delegate!.didFinishMemberAdd()
        }
    }
    
    func addMemberFail(data:String) {
        
        print("API Fail !!!!!!!!!!!!!!!!!!! addMemberFail: " + data )

        alertHandler( localization("AuthServerError") , message:"" , delay:1.5 )
        unBLockAll()
        doneBtnSetting()
        
    }
    
}

//MARK: AuthBlockUI
extension AuthAddMemberViewController: AuthBlockUI
{
    func unBLockAll(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        self.navigationItem.rightBarButtonItem?.enabled = true
        self.navigationItem.leftBarButtonItem?.enabled = true
    }
    func bLockAll(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = localization("Loading...")
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.navigationItem.leftBarButtonItem?.enabled = false
    }
    
    func unBLockAdd(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        self.navigationItem.rightBarButtonItem?.enabled = true
    }
    func bLockAdd(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = localization("Loading...")
        self.navigationItem.rightBarButtonItem?.enabled = false
        
    }
}

