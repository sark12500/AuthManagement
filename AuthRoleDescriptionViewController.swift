//
//  AuthRoleDescriptionViewController.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/16.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//
import UIKit

class AuthRoleDescriptionViewController: UITableViewController, AuthExtension {
    
    enum RoleViewType : Int
    {
        case Description = 0
        case Function
        
        func getHedaer() -> String
        {
            switch self {
            case .Description:
                return NSLocalizedString("AuthDescription",comment:"comment")
            case .Function:
                return NSLocalizedString("AuthFunction",comment:"comment")
            }
        }
    }
    
    let viewModel = AuthRoleViewModel.instance
    var viewType = RoleViewType.Description
    var viewTypeIndex = 0
        {
            didSet {
                
                self.title = RoleViewType(rawValue: viewTypeIndex)!.getHedaer()
            
            }
    }
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewType = RoleViewType(rawValue: viewTypeIndex)!
        
        // Setup navigation
        navigationBarSetting()
        
        // Setup the tableView
        tableViewSetting()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func navigationBarSetting(){
        
        guard let _ = self.navigationController else{return}
        
        self.title = viewType.getHedaer()
        
        let goBackBotton = UIBarButtonItem(title: localization("Back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AuthRoleDescriptionViewController.goBack))
        goBackBotton.image = UIImage(named: "btn_prev")
        self.navigationItem.leftBarButtonItem = goBackBotton
        self.navigationItem.leftBarButtonItem!.tintColor = UIColor.whiteColor()
    }
    
    func goBack()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableViewSetting(){
        tableView.estimatedRowHeight = 56
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //MARK:UITableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }
    
    
    //MARK:UITableView header footer
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        //viewType = RoleViewType(rawValue: section)!
        
        return viewType.getHedaer()
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (view.isKindOfClass(UITableViewHeaderFooterView)) {
            let headerView: UITableViewHeaderFooterView  = view as! UITableViewHeaderFooterView
            headerView.textLabel!.textColor = UIColor( r: 0, g: 119, b: 255)
            headerView.textLabel!.font      = UIFont.boldSystemFontOfSize(12)
            headerView.contentView.backgroundColor = UIColor( r: 247, g: 247, b: 247)
            
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let sectionIndex = indexPath.section
        //viewType = RoleViewType(rawValue: sectionIndex)!
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AuthLabelCell", forIndexPath: indexPath) as! AuthLabelCell
        
        cell.userInteractionEnabled = false
        
        //var title = ""
        switch viewType
        {
        case .Description:
            let description = (viewModel.RoleDescription.isEmpty) ? localization("AuthNone") : viewModel.RoleDescription
            cell.configure(description)
            break
        case .Function:
            let function = (viewModel.RoleFunction.isEmpty) ? localization("AuthNone") : viewModel.RoleFunction
            cell.configure(function)
            break
        }
  
        return cell
    }


}
