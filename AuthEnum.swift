//
//  AuthEnum.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/4/21.
//  Copyright © 2016年 DoubleTap Mobile. All rights reserved.
//

public enum AuthMemberType : Int
{
    case User = 0
    case Dept
    case Company
    case OtherCompanyUser
    
    func getImg() -> String
    {
        switch self {
        case .User: return "a_img_user"
        case .Dept: return "a_img_department"
        case .Company: return "a_img_company"
        case .OtherCompanyUser: return "a_img_user"
        }
    }
    
    func getCheckCell() -> String
    {
        switch self {
        case .User: return "AuthCheckCell"
        case .Dept: return "AuthCheckCell"
        case .Company: return "AuthCheckComCell"
        case .OtherCompanyUser: return "AuthCheckCell"
        }
    }
    
    func getAddCellFontSize() -> CGFloat
    {
        switch self {
        case .User: return 14
        case .Dept: return 12
        case .Company: return 14
        case .OtherCompanyUser: return 14
        }
    }
    
    func getTypeName() -> String
    {
        switch self {
        case .User: return NSLocalizedString("AuthMember",comment:"")
        case .Dept: return NSLocalizedString("AuthDept",comment:"")
        case .Company: return NSLocalizedString("AuthCom",comment:"")
        case .OtherCompanyUser: return NSLocalizedString("AuthNonComMember",comment:"")
        }
    }
    
    func getPlaceholder() -> String
    {
        switch self {
        case .User: return NSLocalizedString("AuthPleaseInputNameOrEmail",comment:"")
        case .Dept: return NSLocalizedString("AuthPleaseInputDeptNameOrId",comment:"")
        case .Company: return NSLocalizedString("AuthDefaultMyCom",comment:"")
        case .OtherCompanyUser: return NSLocalizedString("AuthPleaseInputEmail",comment:"")
        }
    }
    
//    func getTestQueryAry() -> [AuthRoleUser]
//    {
//        switch self {
//        case .User: return [AuthRoleUser(id:"Charles.Huang@quantatw.com",
//            name:"黃阿強",
//            roleId:"role001",
//            solutionName:"AAA",
//            memberType: AuthMemberType.User,
//            selected: false),
//            AuthRoleUser(id:"Peggy.Wu2@quantatw.com",
//                name:"吳PG2",
//                roleId:"role001",
//                solutionName:"AAA",
//                memberType :AuthMemberType.User,
//                selected: false),
//            AuthRoleUser(id:"Peggy.Wu1@quantatw.com",
//                name:"吳PG1",
//                roleId:"role001",
//                solutionName:"AAA",
//                memberType :AuthMemberType.User,
//                selected: false),
//            AuthRoleUser(id:"Eric.Chiu@quantatw.com",
//                name:"艾瑞克周",
//                roleId:"role001",
//                solutionName:"AAA",
//                memberType :AuthMemberType.User,
//                selected: false),
//            AuthRoleUser(id:"Ares.Kuo@quantatw.com",
//                name:"郭阿嘶2",
//                roleId:"role001",
//                solutionName:"AAA",
//                memberType :AuthMemberType.User,
//                selected: false),
//            AuthRoleUser(id:"Peggy.Wu3@quantatw.com",
//                name:"吳PG3",
//                roleId:"role001",
//                solutionName:"AAA",
//                memberType :AuthMemberType.User,
//                selected: false)]
//
//        case .Dept: return [    AuthRoleUser(id:"QCI_QCI-0R602",
//            name:"雲運算應用服務研發中心SaaS開發二部",
//            roleId:"role001",
//            solutionName:"AAA",
//            memberType :AuthMemberType.Dept,
//            selected: false),
//            AuthRoleUser(id:"QCI_QCI-0R603",
//                name:"雲運算應用服務研發中心SaaS開發三部",
//                roleId:"role001",
//                solutionName:"AAA",
//                memberType :AuthMemberType.Dept,
//                selected: false),
//                AuthRoleUser(id:"QCI_QCI-0R601",
//                    name:"雲運算應用服務研發中心SaaS開發不可告人秘密組織",
//                    roleId:"role001",
//                    solutionName:"AAA",
//                    memberType :AuthMemberType.Dept,
//                    selected: false)]
//        case .Company: return [
//            AuthRoleUser(id:"00001318",
//            name:"廣達電腦",
//            roleId:"role001",
//            solutionName:"AAA",
//            memberType :AuthMemberType.Company,
//            selected: false)]
//        case .OtherCompanyUser: return []
//        }
//    }
    
}
