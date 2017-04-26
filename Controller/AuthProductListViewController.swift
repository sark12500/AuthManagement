//
//  AuthProductListViewController
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/16.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//
import UIKit

@available(iOS 8.0, *)
class AuthProductListViewController: UITableViewController,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UISearchDisplayDelegate,AuthExtension {

    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = AuthProductViewModel.instance
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        // Setup navigation
        navigationBarSetting()
        
        // Setup the tableView
        tableViewSetting()
        
        // Setup the Search Controller
        searchBarSetting()
        
        // Setup pull to refresh
        pullToRefreshSetting()
        
        // init datas
        getDataApi()
    }
    
    func getDataApi() {
        
//        viewModel.ProductList = [AuthProduct(id:"001",name:"製造雲貨物追蹤管理",
//            startDate:"2013/04/01",endDate:"2099/12/31",
//            totalLicenseCount:"9999",billingType:"0001"),
//                                 AuthProduct(id:"002",name:"排班休系統",
//                                    startDate:"2014/11/11",endDate:"2099/12/31",
//                                    totalLicenseCount:"9999",billingType:"0001"),
//                                 AuthProduct(id:"003",name:"健康管理系統",
//                                    startDate:"2015/05/01",endDate:"2020/12/31",
//                                    totalLicenseCount:"9999",billingType:"0001"),
//                                 AuthProduct(id:"004",name:"史上最強最好最優聊天室",
//                                    startDate:"2016/02/04",endDate:"2025/12/31",
//                                    totalLicenseCount:"9999",billingType:"0001")]
//        
//        tableView.reloadData()
//        refreshControl?.endRefreshing()
//        return
        
        //bLock ui
        bLockAll()

        let userInfo  = NSUserDefaults.standardUserDefaults()
        let userId    = userInfo.stringForKey("UserId")!
        let param = ["userId": userId]
         
        let apiMgr = AuthApiManager(param: param, delegate: self)
        apiMgr.getProduct()
    }

    
    //View 要被呈現前，發生於 viewDidLoad 之後：
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
         //self.navigationController?.navigationBar.translucent = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //    deinit {
    //        if #available(iOS 9.0, *) {
    //            self.loadViewIfNeeded()
    //        } else {
    //            // Fallback on earlier versions
    //        }
    //    }
 
    // MARK: tableView setting
    func tableViewSetting(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
    }
    
    // MARK: searchBar setting
    func searchBarSetting(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = localization("AuthPleaseInputProductName")
    
        self.automaticallyAdjustsScrollViewInsets = false
        
        //點擊搜尋欄位tableview不要反灰
        searchController.dimsBackgroundDuringPresentation = false
        
        //下面這行沒用?? why?
        //searchController.searchBar.showsCancelButton = false
        searchController.searchBar.barTintColor = UIColor.lightGrayColor()
        
        //搜尋欄位不要擋住navigation bar
        self.searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        
//        self.edgesForExtendedLayout = UIRectEdgeAll;
        //self.extendedLayoutIncludesOpaqueBars = true
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: navigationBar setting
    func navigationBarSetting(){
        
        guard let _ = self.navigationController else{return}
        
        self.title = localization("AuthProductList")
        
        //localization("Back")
        let goBackBotton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AuthProductListViewController.goBack))
        goBackBotton.image = UIImage(named: "btn_prev")
        self.navigationItem.leftBarButtonItem = goBackBotton
        self.navigationItem.leftBarButtonItem!.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.translucent = false
    }
    
    func goBack()
    {
        viewModel.Clear()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //func refreshControlSetting(){
        
    func pullToRefreshSetting(){
        //下拉更新
        self.tableView.alwaysBounceVertical = true
        //法一: 3rd party PullToRefreshWithActionHandler
        self.tableView.addPullToRefreshWithActionHandler { () -> Void in
            
            self.getDataApi()
            
    //                            self.tableView.reloadData()
    //                
    //                            let delay = 2 * Double(NSEC_PER_SEC)
    //                            let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    //                            dispatch_after(time, dispatch_get_main_queue(), {
    //                                //refresh end
    //                                self.tableView.pullToRefreshView.stopAnimating()
    //                            })
        }
        //}
        
//                // Setup pull to refresh
//                let refreshControl = UIRefreshControl()
//                refreshControl.addTarget(self, action: #selector(AuthProductListViewController.pullToRefresh), forControlEvents: UIControlEvents.ValueChanged)
//                self.refreshControl = refreshControl
//    
        
    }
    
//func pullToRefresh() {
//    
//    getDataApi()
//    
//
//}


    func filterContentForSearchText(searchText: String, scope: String = "All") {
        viewModel.FilteredCandies = viewModel.ProductList.filter({( Product : AuthProduct) -> Bool in
            if searchText != ""{
                return Product.solutionName.lowercaseString.containsString(searchText.lowercaseString)
            }
            
            return true
            
            //            let categoryMatch = (scope == "All") || (Product.category == scope)
            //            if searchText != ""{
            //                return categoryMatch && Product.name.lowercaseString.containsString(searchText.lowercaseString)
            //            }
            //            else{
            //
            //                return categoryMatch
            //            }
        })
        tableView.reloadData()
    }
    
    
    //MARK:UITableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (searchController.active) ? viewModel.FilteredCandies.count :
                                           viewModel.getProductListCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let product = (searchController.active) ? viewModel.getFilteredCandiesRow(indexPath.row) :
                                                  viewModel.getProductRow(indexPath.row)
        
//        let backgroundColor = UIColor(r: 245,g: 245,b: 245)
//        cell.layer.cornerRadius = 10
//        cell.layer.backgroundColor = backgroundColor.CGColor
//        cell.layer.borderWidth = 2
//        cell.layer.borderColor = UIColor.whiteColor().CGColor
        
        let image = UIImage(named:"a_img_saas")
        if let imageView = cell.imageView {
            imageView.image = image
            //imageView.frame = CGRect(x: 0,y: 0,width: 50,height: 50)
        }
        
        cell.textLabel?.text = product.solutionName
        //cell.textLabel?.backgroundColor = backgroundColor
        cell.detailTextLabel?.text = product.duringTime
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        //cell.detailTextLabel?.backgroundColor = backgroundColor
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AuthProduct") as? AuthProductViewController
        
        
        let product = (searchController.active) ? viewModel.getFilteredCandiesRow(indexPath.row) :
                                                  viewModel.getProductRow(indexPath.row)
        
        viewModel.SolutionId = product.solutionId
        
        self.navigationController?.pushViewController(vc!, animated: true)
        searchController.active = false
    }
    
    //MARK:UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        //        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchBar.text!, scope: "")
    }

}

//MARK: API ------------------
@available(iOS 8.0, *)
extension AuthProductListViewController: AuthApiDelegate
{
    func getProductSuccess(result: AnyObject) {
        
        print("API SUCCESS !!!!!!!!!!!!!!!!!!! getProductSuccess")
        
        unBLockAll()
        //refreshControl?.endRefreshing()

        self.tableView.pullToRefreshView.stopAnimating()
//        
//        viewModel.ProductList = [AuthProduct(id:"001",name:"製造雲貨物追蹤管理",
//            startDate:"2013/04/01",endDate:"2099/12/31",
//            totalLicenseCount:"9999",billingType:"0001"),
//            AuthProduct(id:"002",name:"排班休系統",
//                startDate:"2014/11/11",endDate:"2099/12/31",
//                totalLicenseCount:"9999",billingType:"0001"),
//            AuthProduct(id:"003",name:"健康管理系統",
//                startDate:"2015/05/01",endDate:"2020/12/31",
//                totalLicenseCount:"9999",billingType:"0001"),
//            AuthProduct(id:"004",name:"史上最強最好最優聊天室",
//                startDate:"2016/02/04",endDate:"2025/12/31",
//                totalLicenseCount:"9999",billingType:"0001")]
        
        
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
        viewModel.ProductList.removeAll()
        
        let datas  = data["data"]
        for (_, subJson): (String, JSON) in datas {
            
            viewModel.ProductList.append(AuthProduct(json: subJson))
        }

        tableView.reloadData()

    }
    
    func getProductFail(data:String) {
        
        print("API Fail !!!!!!!!!!!!!!!!!!! getProductFail: " + data )
        
        alertHandler( localization("AuthServerError") , message:"" , delay:1.5 )
        unBLockAll()
        //refreshControl?.endRefreshing()

        self.tableView.pullToRefreshView.stopAnimating()
        
    }
}

//MARK: AuthBlockUI
@available(iOS 8.0, *)
extension AuthProductListViewController: AuthBlockUI
{
    func unBLockAll(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        //self.navigationItem.rightBarButtonItem?.enabled = true
        
        tableView.userInteractionEnabled = true
    }
    func bLockAll(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = localization("Loading...")
        //self.navigationItem.rightBarButtonItem?.enabled = false
        
        tableView.userInteractionEnabled = false
    }
}


// no use - EGORefreshTableHeaderDelegate
//class AuthProductListViewController: UITableViewController,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UISearchDisplayDelegate,EGORefreshTableHeaderDelegate {
//    
//    var _refreshHeaderView = EGORefreshTableHeaderView()
//    var _reloading = false

//func reloadTableViewDataSource()
//{
//    //  should be calling your tableviews data source model to reload
//    //  put here just for demo
//    _reloading = true
//}
//
//func doneLoadingTableViewData()
//{
//    
//    //  model should call this when its done loading
//    _reloading = false
//    //_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
//    _refreshHeaderView.egoRefreshScrollViewDataSourceDidFinishedLoading ( self.tableView )
//}
//
//
//override func scrollViewDidScroll(scrollView:UIScrollView)
//{
//    _refreshHeaderView.egoRefreshScrollViewDidScroll(scrollView)
//}
//
//func scrollViewDidEndDragging(scrollView:UIScrollView, decelerate:Bool)
//{
//    _refreshHeaderView.egoRefreshScrollViewDidEndDragging(scrollView)
//}
//
//func egoRefreshTableHeaderDidTriggerRefresh(view:EGORefreshTableHeaderView)
//{
//    self.reloadTableViewDataSource()
//    let delay = 1.0 * Double(NSEC_PER_SEC)
//    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//    dispatch_after(time, dispatch_get_main_queue(), {
//        NSThread.detachNewThreadSelector(Selector("doneLoadingTableViewData:"), toTarget:self, withObject: "nil")
//    })
//    //self.performSelector(doneLoadingTableViewData ,withObject:nil ,afterDelay:1.0)
//}
//
//func egoRefreshTableHeaderDataSourceIsLoading(view:EGORefreshTableHeaderView)->Bool
//{
//    return _reloading // should return if data source model is reloading
//}
//
//func egoRefreshTableHeaderDataSourceLastUpdated(view:EGORefreshTableHeaderView)->NSDate
//{
//    return NSDate()
//}

