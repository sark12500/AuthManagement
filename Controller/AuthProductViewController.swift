//
//  AuthProductViewController
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/16.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//
import UIKit

class AuthProductViewController: UIViewController, UIScrollViewDelegate, AuthExtension  {
    
    enum ProductViewType : Int
    {
        case Auth = 0
        case Info
    
        func getCellId() -> String
        {
            switch self {
            case .Auth: return "AuthCell"
            case .Info: return "InfoCell"
            }
        }
        
        func getCellHeight() -> CGFloat
        {
            switch self {
            case .Auth: return 56
            case .Info: return 56
            }
        }
        
        func interactionEnabled() -> Bool
        {
            switch self {
            case .Auth: return true
            case .Info: return false
            }
        }
    }
    
    @IBAction func segmentedControlAction(sender: AnyObject)
    {
        switch tab.selectedSegmentIndex
        {
        case 0:
            viewType = ProductViewType.Auth
            break
        case 1:
            viewType = ProductViewType.Info
            break
        default:
            break
        }
        
        tableViewReload()
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tab: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let productViewModel = AuthProductViewModel.instance
    let roleViewModel = AuthRoleViewModel.instance
    let infoViewModel = AuthInfoViewModel.instance
    
    private var viewType = ProductViewType.Auth
    private let maxTabCount:Int = 2
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationBarSetting()
        
        tableViewSetting()
        
        pullToRefreshSetting()
        
        gestureRecognizerSetting()

        segmentedControlSetting()
        
        infoSetting()
        
        getDataApi()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = false
        
        //如果其他頁更新後此頁也要更新
        //tableView.reloadData()
    }
    
    //MARK: searchBar setting
    func navigationBarSetting(){
        
        guard let _ = self.navigationController else{return}
                
        self.title = AuthProductViewModel.instance.SolutionName
        
        
        let goBackBotton = UIBarButtonItem(title: localization("Back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AuthProductViewController.goBack))
        goBackBotton.image = UIImage(named: "btn_prev")
        self.navigationItem.leftBarButtonItem = goBackBotton
        self.navigationItem.leftBarButtonItem!.tintColor = UIColor.whiteColor()
    }
    
    func goBack()
    {
        roleViewModel.Clear()
        infoViewModel.Clear()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: tableView setting
    func tableViewSetting(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = viewType.getCellHeight()
    }
    //MARK: tableView reload
    func tableViewReload()
    {
        tableView.rowHeight = viewType.getCellHeight()
        tableView.reloadData()
        tableView.userInteractionEnabled = viewType.interactionEnabled()
    }
    //MARK: gestureRecognizer setting
    func gestureRecognizerSetting(){
        //self.setupSwipeGestureRecognizers(true)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(AuthProductViewController.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(AuthProductViewController.handleSwipes(_:)))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        
        switch sender.direction
        {
        case UISwipeGestureRecognizerDirection.Left:
            //print("Swipe Left")
            viewType = ProductViewType.Auth
            
            tab.selectedSegmentIndex = tab.selectedSegmentIndex == 0 ? 0 : tab.selectedSegmentIndex - 1

            break
        case UISwipeGestureRecognizerDirection.Right:
            //print("Swipe Right")
            viewType = ProductViewType.Info
            
            let maxIndex = maxTabCount - 1
            tab.selectedSegmentIndex = tab.selectedSegmentIndex == maxIndex ? maxIndex : tab.selectedSegmentIndex + 1
            
            break
        default:
            break
        }
        
        tableViewReload()
        
        //print(tab.selectedSegmentIndex)
    }
    //MARK: pullToRefresh setting
    func pullToRefreshSetting(){
        //下拉更新
        self.scrollView.alwaysBounceVertical = true
        //法一: 3rd party PullToRefreshWithActionHandler
        self.scrollView.addPullToRefreshWithActionHandler { () -> Void in

            self.getDataApi()
            
//            self.tableView.reloadData()
//            
//            let delay = 2 * Double(NSEC_PER_SEC)
//            let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//            dispatch_after(time, dispatch_get_main_queue(), {
//                //refresh end
//                self.scrollView.pullToRefreshView.stopAnimating()
//            })
        }
    }
    //MARK: segmentedControl setting
    func segmentedControlSetting(){
        tab.selectedSegmentIndex = 0
        tab.setTitle(localization("AuthRoleList"), forSegmentAtIndex:0)
        tab.setTitle(localization("AuthInfo"), forSegmentAtIndex:1)
    }
    //MARK: 產品資訊 setting
    func infoSetting(){
        let product = productViewModel.getThisProductRow()
        let count = product.totalLicenseCount
        let duringTime = product.duringTime
        
        infoViewModel.InfoList = [
            AuthInfo(title: localization("AuthInfoLicense"), subTitle: localization("AuthInfoLicenseCount") + " : " + count , img: "a_img_plan"),
            AuthInfo(title: localization("AuthDuringTime"), subTitle: duringTime, img: "a_img_date")
        ]
        infoViewModel.setInfo(count, duringTime: duringTime)
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
}

//MARK: table view ------------------
extension AuthProductViewController: UITableViewDataSource
{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count = 0
        
        switch viewType
        {
        case .Auth:
            count = roleViewModel.RoleList.count
            break
        case .Info:
            count = infoViewModel.InfoList.count
            break
        }
        
        return count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId = viewType.getCellId()
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
   
        
        switch viewType
        {
        case .Auth:
            let role = roleViewModel.getRoleListRow(indexPath.row)
            
            let description = (role.description.isEmpty) ? "" : " (" + role.description + ")"
            cell.textLabel?.text = role.name + description
            cell.detailTextLabel?.text = role.mappingFunctions
            break
        case .Info:
            
            let info = infoViewModel.getInfoListRow(indexPath.row)
            
            cell.textLabel?.text = info.title
            cell.detailTextLabel?.text = info.subTitle
            cell.imageView?.image = UIImage(named: info.img)
            break
        }
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        return cell
    }
}

//MARK: UITableViewDelegate ------------------
extension AuthProductViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 1;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch viewType
        {
        case .Auth:
            
            if #available(iOS 8.0, *) {
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AuthRoleDetail") as? AuthRoleDetailViewController
                
                roleViewModel.RoleId = roleViewModel.getRoleListRow(indexPath.row).id
                
                self.navigationController?.pushViewController(vc!, animated: true)
                
            } else {
                // Fallback on earlier versions
            }

            break
        case .Info:
            
            return
        }
    }
}

//MARK: API ------------------
extension AuthProductViewController: AuthApiDelegate
{
    func getRoleSuccess(result: AnyObject) {
        
        print("API SUCCESS !!!!!!!!!!!!!!!!!!! getRoleSuccess")
        
        unBLockAll()
        self.scrollView.pullToRefreshView.stopAnimating()
        
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

        
        
//        roleViewModel.RoleList = [
//            AuthRole(id:"role001",
//                name:"廣達角色1",
//                description:"廣達角色1 : 須菩提！在在處處，若有此經，一切世間、天、人、阿修羅，所應供養；當知此處，則為是塔，皆應恭敬，作禮圍繞，以諸華香而散其處。",
//                mappingFunctions:"廣達角色1 : 如是，如是。須菩提！實無有法如來得阿耨多羅三藐三菩提。須菩提！若有法如來得阿耨多羅三藐三菩提，燃燈佛則不與我授記：『汝於來世，當得作佛，號釋迦牟尼。』以實無有法得阿耨多羅三藐三菩提，是故燃燈佛與我授記，作是言：『汝於來世，當得作佛，號釋迦牟尼。』何以故？如來者，即諸法如義。",
//                isOwner:false,
//                users:[AuthRoleUser(id:"Charles.Huang@quantatw.com",
//                    name:"黃阿強",
//                    roleId:"role001",
//                    solutionName:"AAA",
//                    memberType: AuthMemberType.User,
//                    selected: false),
//                    AuthRoleUser(id:"QCI-QCI_0R602",
//                        name:"SaaS開發二部",
//                        roleId:"role001",
//                        solutionName:"AAA",
//                        memberType :AuthMemberType.Dept,
//                        selected: false),
//                    AuthRoleUser(id:"Peggy.Wu2@quantatw.com",
//                        name:"吳PG2",
//                        roleId:"role001",
//                        solutionName:"AAA",
//                        memberType :AuthMemberType.User,
//                        selected: false),
//                    AuthRoleUser(id:"QCI-QCI_0R603",
//                        name:"SaaS開發三部",
//                        roleId:"role001",
//                        solutionName:"AAA",
//                        memberType :AuthMemberType.Dept,
//                        selected: false),
//                    AuthRoleUser(id:"00001234",
//                        name:"光明分子",
//                        roleId:"role001",
//                        solutionName:"AAA",
//                        memberType :AuthMemberType.Company,
//                        selected: false),
//                    AuthRoleUser(id:"Peggy.Wu1@quantatw.com",
//                        name:"吳PG1",
//                        roleId:"role001",
//                        solutionName:"AAA",
//                        memberType :AuthMemberType.User,
//                        selected: false),
//                    AuthRoleUser(id:"Eric.Chiu@quantatw.com",
//                        name:"艾瑞克周",
//                        roleId:"role001",
//                        solutionName:"AAA",
//                        memberType :AuthMemberType.User,
//                        selected: false),
//                    AuthRoleUser(id:"Ares.Kuo@quantatw.com",
//                        name:"郭阿嘶2",
//                        roleId:"role001",
//                        solutionName:"AAA",
//                        memberType :AuthMemberType.User,
//                        selected: false),
//                    AuthRoleUser(id:"Peggy.Wu3@quantatw.com",
//                        name:"吳PG3",
//                        roleId:"role001",
//                        solutionName:"AAA",
//                        memberType :AuthMemberType.User,
//                        selected: false),
//                    AuthRoleUser(id:"QCI-QCI_0R601",
//                        name:"SaaS開發一部",
//                        roleId:"role001",
//                        solutionName:"AAA",
//                        memberType :AuthMemberType.Dept,
//                        selected: false),
//                    AuthRoleUser(id:"00001318",
//                        name:"廣達電腦",
//                        roleId:"role001",
//                        solutionName:"AAA",
//                        memberType :AuthMemberType.Company,
//                        selected: false),
//                    AuthRoleUser(id:"00001319",
//                        name:"廣明光電",
//                        roleId:"role001",
//                        solutionName:"AAA",
//                        memberType: AuthMemberType.Company,
//                        selected: false)]
//            ),
//            AuthRole(id:"role002",
//                name:"廣達角色2",
//                description:"廣達角色2 : Description",
//                mappingFunctions:"廣達角色2 : function",
//                isOwner:false,
//                users:[AuthRoleUser(id:"Charles.Huang@quantatw.com",
//                    name:"黃靖強",
//                    roleId:"role001",
//                    solutionName:"AAA",
//                    memberType: AuthMemberType.Dept,selected: false),
//                    AuthRoleUser(id:"Peggy.wu@quantatw.com",
//                        name:"吳PG",
//                        roleId:"role001",
//                        solutionName:"AAA",
//                        memberType :AuthMemberType.Company,selected: false)]
//            ),
//            AuthRole(id:"role003",
//                name:"展運角色1",
//                description:"",
//                mappingFunctions:"",
//                isOwner:false,
//                users:[]
//            )]
        
    }
    
    func getRoleFail(data:String) {
        
        print("API Fail !!!!!!!!!!!!!!!!!!! getRoleFail: " + data )
        alertHandler( localization("AuthServerError") , message:"" , delay:1.5 )

        unBLockAll()
        self.scrollView.pullToRefreshView.stopAnimating()

    }
}

//MARK: AuthBlockUI
extension AuthProductViewController: AuthBlockUI
{
    func unBLockAll(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        self.navigationItem.leftBarButtonItem?.enabled = true
        tableView.userInteractionEnabled = true
    }
    func bLockAll(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = localization("Loading...")
        self.navigationItem.leftBarButtonItem?.enabled = false
        tableView.userInteractionEnabled = false
    }
}


