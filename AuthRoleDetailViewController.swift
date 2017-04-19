//
//  AuthRoleDetailViewController.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/16.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//
import UIKit

@available(iOS 8.0, *)
class AuthRoleDetailViewController: UITableViewController,AuthExtension//,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UISearchDisplayDelegate
{
    enum RoleViewType : Int
    {
        case Members = 0
        case Description
        
        func getCellId() -> String
        {
            switch self {
            case .Description: return "DescriptionCell"
            case .Members: return "MembersCell"
            }
        }
        
        func getHeaderHeight() -> CGFloat
        {
            switch self {
            case .Description: return 10
            case .Members: return 30
            }
        }
        
//        func interactionEnabled() -> Bool
//        {
//            switch self {
//            case .Description: return true
//            case .Members: return false
//            }
//        }
        
        func canEdit() -> Bool
        {
            switch self {
            case .Description: return false
            case .Members: return true
            }
        }
        
        func getNextPageId() -> String
        {
            switch self {
            case .Description: return "AuthRoleDescription"
            case .Members: return "AuthDeptMember"
        }
    }
        
        
//        self.storyboard?.instantiateViewControllerWithIdentifier("AuthRoleDescription") as? AuthRoleDescriptionViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
//        
//        break
//        case .Members:
//        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AuthDeptMember") as? AuthDeptMemberViewController
        
    }
    
    //let searchController = UISearchController(searchResultsController: nil)
    let productViewModel = AuthProductViewModel.instance
    let roleViewModel = AuthRoleViewModel.instance
    var viewType = RoleViewType.Members
    

    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation
        navigationBarSetting()
        
        // Setup the tableView
        tableViewSetting()
        
        // 新增成員按鈕設定
        addBtnSetting()
        
        // Setup the Search Controller
        //searchBarSetting()
        
        pullToRefreshSetting()
        
    }
    
    func pullToRefreshSetting(){
        //下拉更新
        self.tableView.alwaysBounceVertical = true
        //法一: 3rd party PullToRefreshWithActionHandler
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
            
            self.getDataApi()
        }
        
        self.tableView.addInfiniteScrollingWithActionHandler{ () -> Void in
            
            self.getMoreApi()
        }
        
        InfiniteScrollingSetting()
        
//        // Setup pull to refresh
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(AuthRoleDetailViewController.pullToRefresh), forControlEvents: UIControlEvents.ValueChanged)
//        self.refreshControl = refreshControl
    }
    
//    func pullToRefresh() {
//
//        getDataApi()
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func navigationBarSetting(){
        
        guard let _ = self.navigationController else{return}
        
        self.title = roleViewModel.RoleName
        
        let goBackBotton = UIBarButtonItem(title: localization("Back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AuthRoleDetailViewController.goBack))
        goBackBotton.image = UIImage(named: "btn_prev")
        self.navigationItem.leftBarButtonItem = goBackBotton
        self.navigationItem.leftBarButtonItem!.tintColor = UIColor.whiteColor()
        
        let goEditBotton = UIBarButtonItem(title: localization("Edit"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AuthRoleDetailViewController.goEdit))
        //goBackBotton.image = UIImage(named: "btn_prev")
        self.navigationItem.rightBarButtonItem = goEditBotton
        self.navigationItem.rightBarButtonItem!.tintColor = UIColor.whiteColor()
        
        navigationBarRefresh()
    }
    //MARK: 沒有成員無法編輯
    func navigationBarRefresh(){

        let count = roleViewModel.getRoleUserListCount(roleViewModel.RoleId)
        self.navigationItem.rightBarButtonItem?.enabled = (count > 0)
    }
    //MARK: 設定是否可以繼續下拉
    func InfiniteScrollingSetting(){

        let hasMore = self.roleViewModel.getThisRoleListRow().hasMore
        self.tableView.showsInfiniteScrolling = hasMore
    }
    
    func goBack()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goEdit()
    {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AuthMemberEdit") as! AuthMemberEditViewController
        let navController = UINavigationController(rootViewController: vc)
        vc.delegate  = self
        
        self.presentViewController(navController, animated: true, completion: nil)

    }
    
    func tableViewSetting(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
    
    }
    let addBtn = UIButton()
    func addBtnSetting(){

        addBtn.setImage(UIImage(named: "a_img_newuser"), forState: .Normal)
        //addBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        addBtn.frame = CGRect(origin: CGPointZero, size: CGSize(width: 80.0, height: 80.0))
        addBtn.center = CGPointMake(self.view.bounds.width - 40.0, self.view.bounds.height - 100)
        addBtn.addTarget(self, action: #selector(AuthRoleDetailViewController.addBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        // 設定陰影
        addBtn.layer.shadowColor = UIColor.blackColor().CGColor
        addBtn.layer.shadowOpacity = 0.5;
        addBtn.layer.shadowRadius = 5;
        addBtn.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        
        self.view.addSubview(addBtn)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //todo:寫死 - change button's position when scrolling
        var frame = addBtn.frame;
        frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - 76;
        addBtn.frame = frame;
        
        self.view.bringSubviewToFront(addBtn)
    }
    
    
    func addBtnClick(sender: UIButton!) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AuthAddMember") as! AuthAddMemberViewController
        let navController = UINavigationController(rootViewController: vc)
        vc.delegate = self
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func getDataApi() {
        
        //bLock ui
        bLockAll()
        
        let userInfo  = NSUserDefaults.standardUserDefaults()
        let comId = userInfo.stringForKey("CompanyId")!
        let solutionId = productViewModel.SolutionId
        
        let param = ["SolutionId":solutionId, "ComId": comId]
        
        let apiMgr = AuthApiManager(param: param, delegate: self)
        apiMgr.getRole()
    }
    
    func getMoreApi() {
        
        //bLock ui
        bLockBtn()
        
        let userInfo  = NSUserDefaults.standardUserDefaults()
        let comId = userInfo.stringForKey("CompanyId")!
        let solutionId = productViewModel.SolutionId
        let roleId = roleViewModel.getThisRoleListRow().id
        let nowCount = roleViewModel.getThisRoleListRow().nowCount
        
        //let param = ["SolutionId":solutionId, "ComId": comId]
        let param = ["SolutionId":solutionId, "ComId": comId, "SearchValue":"" , "Count":nowCount, "FilterRoleId":roleId]

//        print("\(nowCount)")
//        print(roleId)
        
        let apiMgr = AuthApiManager(param: param, delegate: self)
        apiMgr.getOneRoleOthersById()
    }
    
    //MARK:UITableView header
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        viewType = RoleViewType(rawValue: section)!
        var title = ""
        //let memberCount = roleViewModel.getRoleUserListCount(roleViewModel.RoleId)
        let role = roleViewModel.getThisRoleListRow()
        switch viewType{
        case .Members:
            title = localization("AuthRoleMember") + "(" + "\(role.nowCount)" + "/" + "\(role.totalCount)" + ")"
            
            break
        default: break
        }
        
        return title
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (view.isKindOfClass(UITableViewHeaderFooterView)) {
            let headerView: UITableViewHeaderFooterView  = view as! UITableViewHeaderFooterView
            headerView.textLabel!.textColor = UIColor( r: 0, g: 119, b: 255)
            headerView.textLabel!.font      = UIFont.boldSystemFontOfSize(12)
            headerView.contentView.backgroundColor = UIColor( r: 247, g: 247, b: 247)
            
//            headerView.layer.borderWidth = lineWidth
//            headerView.layer.borderColor = UIColor( red: lineColorValue, green: lineColorValue, blue:lineColorValue, alpha: lineColorAlpha).CGColor
        }
        
    }
    
    //MARK:UITableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        viewType = RoleViewType(rawValue: section)!

        return viewType.getHeaderHeight();
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewType = RoleViewType(rawValue: section)!
        var count = 0
        switch viewType{
        case .Description:
            count = 2
            
            break
        case .Members:
            
            count = roleViewModel.getRoleUserListCount(roleViewModel.RoleId)
        }
        
        return count
        
        //return (searchController.active) ? viewModel.FilteredUserList.count :viewModel.getRoleUserListCount(viewModel.RoleId)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let sectionIndex = indexPath.section
        
        viewType = RoleViewType(rawValue: sectionIndex)!
        let cellId = viewType.getCellId()
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
  
//        let user = (searchController.active) ? viewModel.getFilteredRoleUserListRow(indexPath.row) :
//            viewModel.getRoleUserListRow(viewModel.RoleId,userIndex: indexPath.row)
        
        switch viewType
        {
        case .Description:
            switch indexPath.row
            {
            case 0:
                cell.textLabel?.text = localization("AuthDescription")
                cell.detailTextLabel?.text = roleViewModel.RoleDescription
                break
            case 1:
                cell.textLabel?.text = localization("AuthFunction")
                cell.detailTextLabel?.text = roleViewModel.RoleFunction
                break
            default:
               
                break
            }
            
            break
        case .Members:
            
            let user = roleViewModel.getRoleUserListRow(roleViewModel.RoleId,userIndex: indexPath.row)
            
            let imageName = user.memberType.getImg()
        
             // 依照不同型
            switch user.memberType
            {
            case .Dept:
                cell.accessoryType = .DisclosureIndicator
                //cell.userInteractionEnabled = true
                break
            default:
                cell.accessoryType = .None
                //cell.userInteractionEnabled = false
                break
            }
            
            cell.textLabel?.text = user.name

            var detailText = ""
            switch user.memberType
            {
            case .Dept:
                detailText = user.id //部門顯示id
                break
            case .Company:
                detailText = "" // 公司不顯示
                break
                
            default:
                //user顯示email
                detailText = user.email
                break
            }
            
            cell.detailTextLabel?.text = detailText
            
            let image = UIImage(named:imageName)
            if let imageView = cell.imageView {
                imageView.image = image
            }

            break
        }
        
        cell.detailTextLabel?.textColor = UIColor.grayColor()
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let sectionIndex = indexPath.section
        viewType = RoleViewType(rawValue: sectionIndex)!
        
        switch viewType
        {
        case .Description:
            let vcDes = self.storyboard?.instantiateViewControllerWithIdentifier("AuthRoleDescription") as? AuthRoleDescriptionViewController

            vcDes!.viewTypeIndex = indexPath.row
            
            self.navigationController?.pushViewController(vcDes!, animated: true)
            
            break
        case .Members:
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AuthDeptMember") as! AuthDeptMemberViewController
            
            let user = roleViewModel.getRoleUserListRow(roleViewModel.RoleId,userIndex: indexPath.row)
            
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let sectionIndex = indexPath.section
        viewType = RoleViewType(rawValue: sectionIndex)!
        
        
        return viewType.canEdit()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            print("delete : " + "\(indexPath.row)")
            
            let roleId = roleViewModel.RoleId
            let user = roleViewModel.getRoleUserListRow(roleId,userIndex: indexPath.row)
            let mappingId = user.mappingId + ";" + user.id
            let mappingIds = [mappingId]
            print(mappingId)
            deleteMemberApi(mappingIds)
        }
    }
    
    func deleteMemberApi(mappingIds:[String]) {
        
        bLockAll()

        let userInfo  = NSUserDefaults.standardUserDefaults()
        let deletor   = userInfo.stringForKey("UserId")!
        
        //只能塞內建型態 string
        let param = ["MappingIds": mappingIds ,"Deletor":deletor]
        
        //print(roleId)
        //print(userIds)
        
        let apiMgr = AuthApiManager(param: param, delegate: self)
        apiMgr.deleteMember()
    }
    
    //    func searchBarSetting(){
    //        searchController.searchResultsUpdater = self
    //        searchController.searchBar.delegate = self
    //        searchController.searchBar.placeholder = "請輸入使用者名稱或電子郵件"
    //        definesPresentationContext = true
    //        //點擊搜尋欄位tableview不要反灰
    //        searchController.dimsBackgroundDuringPresentation = false
    //        searchController.searchBar.showsCancelButton = false
    //        tableView.tableHeaderView = searchController.searchBar
    //    }
    
    //    func filterContentForSearchText(searchText: String, scope: String = "All") {
    //        let roleId = viewModel.RoleId
    //        viewModel.FilteredUserList = viewModel.getRoleListRow(roleId).users.filter({( role : AuthRoleUser) -> Bool in
    //            print(role.name)
    //            print(role.id)
    //            if searchText != ""{
    //                let nameCompare = role.name.lowercaseString.containsString(searchText.lowercaseString)
    //                let mailCompare = role.id.lowercaseString.containsString(searchText.lowercaseString)
    //                return nameCompare || mailCompare
    //            }
    //
    //            return true
    //
    //            //            let categoryMatch = (scope == "All") || (Product.category == scope)
    //            //            if searchText != ""{
    //            //                return categoryMatch && Product.name.lowercaseString.containsString(searchText.lowercaseString)
    //            //            }
    //            //            else{
    //            //
    //            //                return categoryMatch
    //            //            }
    //        })
    //        tableView.reloadData()
    //    }
    //
    //    //MARK:UISearchBarDelegate
    //    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    //        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    //    }
    //
    //    // MARK: - UISearchResultsUpdating Delegate
    //    func updateSearchResultsForSearchController(searchController: UISearchController) {
    //        let searchBar = searchController.searchBar
    //        //        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    //        filterContentForSearchText(searchBar.text!, scope: "")
    //    }
}

//MARK: API ------------------
@available(iOS 8.0, *)
extension AuthRoleDetailViewController: AuthApiDelegate
{
    func getRoleSuccess(result: AnyObject) {
        
        print("API SUCCESS !!!!!!!!!!!!!!!!!!! getRoleSuccess")
        
        unBLockAll()
        //refreshControl?.endRefreshing()
        self.tableView.pullToRefreshView.stopAnimating()
        
        var data = JSON(result)
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
        
        // 更新資料
        roleViewModel.RoleList.removeAll()
        
        let datas = data["data"]
        
        for (_, subJson): (String, JSON) in datas {
            
            roleViewModel.RoleList.append(AuthRole(json: subJson))
        }
        
        tableView.reloadData()
        navigationBarRefresh()
        InfiniteScrollingSetting()
    }
    
    func getRoleFail(data:String) {
        
        print("API Fail !!!!!!!!!!!!!!!!!!! getRoleFail: " + data )
        
        alertHandler( localization("AuthServerError") , message:"" , delay:1.5 )
        unBLockAll()
        //refreshControl?.endRefreshing()
        self.tableView.pullToRefreshView.stopAnimating()
        navigationBarRefresh()
    }
    
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
     
        getDataApi()
    }
    
    func deleteMemberFail(data:String) {
        
        print("API Fail !!!!!!!!!!!!!!!!!!! deleteMemberFail: " + data )
        
        alertHandler( localization("AuthServerError") , message:"" , delay:1.5 )
        unBLockAll()
        
    }
    
    func getOneRoleOthersByIdSuccess(result: AnyObject) {
        
        print("API SUCCESS !!!!!!!!!!!!!!!!!!! getOneRoleOthersByIdSuccess")
        
        unBLockBtn()
        self.tableView.infiniteScrollingView.stopAnimating()
        
        var data = JSON(result)
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
        
//        // 更新資料
//        roleViewModel.RoleList.removeAll()
//        
        let datas = data["data"]
        for (_, subJson): (String, JSON) in datas {
            
            //roleViewModel.RoleList.append(AuthRole(json: subJson))
            roleViewModel.getThisRoleListRow().set(subJson)
        }
//
        tableView.reloadData()
        navigationBarRefresh()
        InfiniteScrollingSetting()
    }
    
    func getOneRoleOthersByIdFail(data:String) {
        
        print("API Fail !!!!!!!!!!!!!!!!!!! getOneRoleOthersByIdFail: " + data )
        
        alertHandler( localization("AuthServerError") , message:"" , delay:1.5 )
        unBLockBtn()
        //refreshControl?.endRefreshing()
        self.tableView.infiniteScrollingView.stopAnimating()
        navigationBarRefresh()
    }
}


//MARK: AuthMemberEditDelegate ------------------ 
@available(iOS 8.0, *)
extension AuthRoleDetailViewController: AuthMemberEditDelegate{
    
    func didFinishMemberEdit(){
        getDataApi()
    }
}

@available(iOS 8.0, *)
extension AuthRoleDetailViewController: AuthMemberAddDelegate{
    
    func didFinishMemberAdd(){
        getDataApi()
    }
}

//MARK: AuthBlockUI
@available(iOS 8.0, *)
extension AuthRoleDetailViewController: AuthBlockUI
{
    func unBLockAll(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        //self.navigationItem.rightBarButtonItem?.enabled = true
        self.navigationItem.leftBarButtonItem?.enabled = true
        //navigationBarRefresh()
        addBtn.enabled = true
        tableView.userInteractionEnabled = true
    }
    func bLockAll(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = localization("Loading...")
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.navigationItem.leftBarButtonItem?.enabled = false
        addBtn.enabled = false
        tableView.userInteractionEnabled = false
    }
    func unBLockBtn(){
        self.navigationItem.rightBarButtonItem?.enabled = true
        addBtn.enabled = true
    }
    func bLockBtn(){
        self.navigationItem.rightBarButtonItem?.enabled = false
        addBtn.enabled = false
        
    }
}

