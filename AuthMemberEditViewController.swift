//
//  AuthMemberEditViewController.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/4/21.
//  Copyright © 2016年 DoubleTap Mobile. All rights reserved.
//

import UIKit

protocol AuthMemberEditDelegate {
    //角色編輯頁面後觸發事件
    func didFinishMemberEdit()
}

class AuthMemberEditViewController: UIViewController,AuthExtension{
    
    //const paramters
    let lineColorValue:CGFloat = 204/255
    let lineColorAlpha:CGFloat = 0.5
    
    var delegate: AuthMemberEditDelegate?

    @IBAction func deleteBtnClick(sender: AnyObject) {
        
        print("deleteBtnClick !!!")
        
        let roleId = viewModel.RoleId
        var mappingIds = [String]()
        var ii = 0
        for item in selectedArray {
            if item == true {
                let user = viewModel.getRoleUserListRow(roleId, userIndex: ii)
//                let iddd = user.mappingId + ";" + user.id
//                print(iddd)
                mappingIds.append(user.mappingId + ";" + user.id)
            }
            
            ii += 1
        }

        deleteMemberApi(mappingIds)
    }
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = AuthRoleViewModel.instance
    
    //紀錄何者被勾選
    var selectedArray:Array<Bool> = []
    func selectedCount() -> Int{
        return selectedArray.filter{ $0 == true }.count
    }
    
    func isSelectAll() -> Bool
    {
        let count = viewModel.getRoleUserListCount(viewModel.RoleId)
        return selectedCount() == count
    }
    
    func deleteMemberApi(mappingIds:[String]) {
        
        bLockAll()
        
        let userInfo  = NSUserDefaults.standardUserDefaults()
        let deletor    = userInfo.stringForKey("UserId")!
    
        let param = ["MappingIds":mappingIds,"Deletor":deletor]
        
        //print(roleId)
        //print(userIds)
        
        let apiMgr = AuthApiManager(param: param, delegate: self)
        apiMgr.deleteMember()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSelectedArray(false)
        
        tableViewSetting()

        // Setup navigation
        navigationBarSetting()
        
        deleteBtn.layer.borderWidth = 1
        deleteBtn.layer.borderColor = UIColor( red: lineColorValue, green: lineColorValue, blue:lineColorValue, alpha: lineColorAlpha).CGColor
        deleteBtn.setTitle(localization("Delete"), forState: UIControlState.Normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSelectedArray(isSelected:Bool) {
        
        selectedArray.removeAll()
        let count = viewModel.getRoleUserListCount(viewModel.RoleId)
        
        if count > 0 {
            
            for _ in 0...count - 1
            {
                selectedArray.append(isSelected)
            }
        }
        
        deleteBtnSetting()
        
        self.title = "\(selectedCount()) " + localization("AuthSelected")
    }
    
    func refreshSelectedArray(isSelected:Bool){
        
        let count = viewModel.getRoleUserListCount(viewModel.RoleId)
        if count > 0{
            for ii in 0...count - 1
            {
                selectedArray[ii] = isSelected
            }
        }
        
        deleteBtnSetting()
        
        self.title = "\(selectedCount()) " + localization("AuthSelected")
    }
    
    
    func deleteBtnSetting(){
        let hasValue = selectedCount() > 0
        deleteBtn.enabled = hasValue
        deleteBtn.setTitleColor(hasValue ? UIColor.redColor() : UIColor.lightGrayColor(), forState: .Normal)
    }
    
    func tableViewSetting(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        
        tableView.registerNib(UINib(nibName: "AuthSelectedCell", bundle: nil), forCellReuseIdentifier: "AuthSelectedCell")
        tableView.registerNib(UINib(nibName: "AuthSelectedComCell", bundle: nil), forCellReuseIdentifier: "AuthSelectedComCell")
        
    }
    
    func navigationBarSetting(){
        
        guard let _ = self.navigationController else{return}
        
        //self.navigationController?.navigationBar.translucent = false
        
        self.title = "0 " + localization("AuthSelected")
        
        let goCancelBotton = UIBarButtonItem(title: localization("Back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AuthMemberEditViewController.goCancel))
        let goAllBotton = UIBarButtonItem(title: localization("common_select_all"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AuthMemberEditViewController.goAll))
        
        self.navigationItem.leftBarButtonItem = goCancelBotton
        self.navigationItem.leftBarButtonItem!.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = goAllBotton
        self.navigationItem.rightBarButtonItem!.tintColor = UIColor.whiteColor()
    }
    
    func goAll()
    {
        if isSelectAll(){
            refreshSelectedArray(false)
            self.navigationItem.rightBarButtonItem?.title = localization("common_select_all")
        }else{
            refreshSelectedArray(true)
            self.navigationItem.rightBarButtonItem?.title = localization("common_cancel")
        }
   
        tableView.reloadData()
    }
    
    func goCancel()
    {
        self.dismissViewControllerAnimated(true, completion: nil )
    }

}

//MARK: table view ------------------
extension AuthMemberEditViewController: UITableViewDataSource
{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.getRoleUserListCount(viewModel.RoleId)
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell
    {


        let user = viewModel.getRoleUserListRow(viewModel.RoleId,userIndex: indexPath.row)
        
        //let checkImg = selectedArray[indexPath.row] ? "a_img_checkbox_checked" :"a_img_checkbox_default"
        
        //let memberImg = user.memberType.getImg()
        
        var cell = UITableViewCell()

        // 使用客製化的cell
        switch (user.memberType) {
        case .Dept:
            cell = tableView.dequeueReusableCellWithIdentifier("AuthSelectedCell", forIndexPath: indexPath)
            
            let AuthCell = (cell as! AuthSelectedCell)
            AuthCell.configure(user.name,subTitle: user.id,
                memberType: user.memberType, btnSelectd: selectedArray[indexPath.row])
            AuthCell.checkBtn.addTarget(self, action: #selector(AuthMemberEditViewController.selectBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            AuthCell.checkBtn.tag = indexPath.row
            AuthCell.next.hidden = false
            
            break;
        case .Company:
            cell = tableView.dequeueReusableCellWithIdentifier("AuthSelectedComCell", forIndexPath: indexPath)
            
            let AuthCell = (cell as! AuthSelectedComCell)
            AuthCell.configure(user.name,
                memberType: user.memberType, btnSelectd: selectedArray[indexPath.row])
            AuthCell.checkBtn.addTarget(self, action: #selector(AuthMemberEditViewController.selectBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            AuthCell.checkBtn.tag = indexPath.row
            AuthCell.next.hidden = true
            break;
            
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("AuthSelectedCell", forIndexPath: indexPath)
            
            let AuthCell = (cell as! AuthSelectedCell)
            AuthCell.configure(user.name,subTitle: user.email,//user.id,
                memberType: user.memberType, btnSelectd: selectedArray[indexPath.row])
            AuthCell.checkBtn.addTarget(self, action: #selector(AuthMemberEditViewController.selectBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
        selectedArray[index] = !selectedArray[index]

        tableView.reloadData()

        //update title
        self.title = "\(selectedCount()) " + localization("AuthSelected")

        deleteBtnSetting()

        if isSelectAll(){
            self.navigationItem.rightBarButtonItem?.title = localization("common_cancel")
        }else{
            self.navigationItem.rightBarButtonItem?.title = localization("common_select_all")
        }
    }
    
}

//MARK: UITableViewDelegate ------------------
extension AuthMemberEditViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {

        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AuthDeptMember") as! AuthDeptMemberViewController
        
        let user = viewModel.getRoleUserListRow(viewModel.RoleId,userIndex: indexPath.row)
        
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

//MARK: API ------------------
extension AuthMemberEditViewController: AuthApiDelegate
{

    
    func deleteMemberSuccess(data: AnyObject) {
        
        print("API SUCCESS !!!!!!!!!!!!!!!!!!! deleteMemberSuccess")
        
        unBLockAll()
        
        var data = JSON(data)
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
            delegate!.didFinishMemberEdit()
        }
        
    }
    
    func deleteMemberFail(data:String) {
        
        print("API Fail !!!!!!!!!!!!!!!!!!! deleteMemberFail: " + data )
        
        alertHandler( localization("AuthServerError") , message:"" , delay:1.5 )
        unBLockAll()

        
    }
}


extension AuthMemberEditViewController: AuthBlockUI
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
}

