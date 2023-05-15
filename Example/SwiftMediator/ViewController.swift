//
//  ViewController.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/11.
//

import UIKit
import SwiftMediator
import SwiftBrick
import Swift_Form
class ViewController: JHTableViewController {
    
    lazy var former = Former(tableView: self.tableView!)
    
    lazy var sectionFormer1 : SectionFormer = {
        let sectionFormer = SectionFormer(row1,
                                          row2)
        let header = LabelHeaderFooter()
        header.viewHeight = 20
        header.title = "present页面,可选导航栏,模态样式"
        header.headerFooter.backColor = .baseTeal
        sectionFormer.set(headerViewFormer: header)
        return sectionFormer
    }()
    
    lazy var sectionFormer2 : SectionFormer = {
        let sectionFormer = SectionFormer(row3,
                                          row4,
                                          row5)
        let header = LabelHeaderFooter()
        header.viewHeight = 20
        header.title = "push页面,可关闭动画"
        header.headerFooter.backColor = .baseTeal
        sectionFormer.set(headerViewFormer: header)
        return sectionFormer
    }()
    
    lazy var sectionFormer3 : SectionFormer = {
        let sectionFormer = SectionFormer(row6,
                                          row7,
                                          row8)
        let header = LabelHeaderFooter()
        header.viewHeight = 20
        header.title = "URL跳转页面,可选push,present"
        header.headerFooter.backColor = .baseTeal
        sectionFormer.set(headerViewFormer: header)
        return sectionFormer
    }()
    
    lazy var sectionFormer4 : SectionFormer = {
        let sectionFormer = SectionFormer(row10,
                                          row11,
                                          row12)
        let header = LabelHeaderFooter()
        header.viewHeight = 20
        header.title = "其他方法函数调用"
        header.headerFooter.backColor = .baseTeal
        sectionFormer.set(headerViewFormer: header)
        return sectionFormer
    }()
    
    lazy var sectionFormer5 : SectionFormer = {
        let sectionFormer = SectionFormer(row9,
                                          row13)
        let header = LabelHeaderFooter()
        header.viewHeight = 20
        header.title = "跨组件调用"
        header.headerFooter.backColor = .baseTeal
        sectionFormer.set(headerViewFormer: header)
        return sectionFormer
    }()
    
    lazy var row1 : LabelRow = {
        let row = LabelRow()
        row.title = "present页面"
        row.subTitle = "默认用法,添加导航栏"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.present("TestVC", paramsDic: ["str":"我是字符串",
                                                               "titleName":"present页面1",
                                                               "num":13,
                                                               "dic":["a":12,
                                                                      "b":"测试字符串"]
                                                              ])
            
        }
        return row
    }()
    
    lazy var row2 : LabelRow = {
        let row = LabelRow()
        row.title = "present页面"
        row.subTitle = "可选模态样式,导航栏等"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":"我是字符串",
                                                                  "titleName":"present页面2",
                                                                  "num":13,
                                                                  "dic":["a":12,"b":"hh100"]])
            SwiftMediator.shared.present(avc, needNav: false, modelStyle: 1)
            
        }
        return row
    }()
    
    lazy var row3 : LabelRow = {
        let row = LabelRow()
        row.title = "push页面"
        row.subTitle = "手动初始化push"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":"解放军",
                                                                  "titleName":"push页面1",
                                                                  "num":13,
                                                                  "dic":["a":12,"b":"kk100"]])
            SwiftMediator.shared.currentNavigationController()?.pushViewController(avc!, animated: true)
            
        }
        return row
    }()
    
    lazy var row4 : LabelRow = {
        let row = LabelRow()
        row.title = "push页面"
        row.subTitle = "默认用法"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.push("TestVC", paramsDic: ["str":"每年高考",
                                                            "titleName":"push页面2",
                                                            "num":13,
                                                            "dic":["a":12,"b":"lkj"]])
            
        }
        return row
    }()
    
    lazy var row5 : LabelRow = {
        let row = LabelRow()
        row.title = "push页面"
        row.subTitle = "可选动画,出发页面等"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":";框架",
                                                                  "titleName":"push页面3",
                                                                  "num":13,
                                                                  "dic":["a":12,"b":"jlj"]])
            //            self.navigationController?.pushViewController(avc!, animated: true)
            SwiftMediator.shared.push(avc, animated: false)
            
        }
        return row
    }()
    
    lazy var row6 : LabelRow = {
        let row = LabelRow()
        row.title = "URL跳转页面"
        row.subTitle = "push"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.openUrl("app://push/SwiftMediator/TestVC?str=asdf&titleName=zcxvzcv")
            
        }
        return row
    }()
    
    lazy var row7 : LabelRow = {
        let row = LabelRow()
        row.title = "URL跳转页面"
        row.subTitle = "present"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.openUrl("app://present/SwiftMediator/TestVC?str=fhfgdh&titleName=shdhdg&num=111")
            
        }
        return row
    }()
    
    lazy var row8 : LabelRow = {
        let row = LabelRow()
        row.title = "URL跳转页面"
        row.subTitle = "present,全屏"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.openUrl("app://fullScreen/SwiftMediator/TestVC?str=zfzvzcv&titleName=fghdfhdgh")
            
        }
        return row
    }()
    
    lazy var row13 : LabelRow = {
        let row = LabelRow()
        row.title = "URL跳转页面"
        row.subTitle = "打开其他组件的网页H5"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            ////此处注意编进URL的字符串不能出现特殊字符,要进行URL编码
            SwiftMediator.shared.openUrl("nnn://push/SwiftBrick/JHWebViewController?navTitle=\("打开网页".urlEncoded())&urlString=https://www.qq.com/")
            
        }
        return row
    }()
    
    lazy var row9 : LabelRow = {
        let row = LabelRow()
        row.title = "打开其他Module的页面"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.push("JHWebViewController",
                                      moduleName: "SwiftBrick",
                                      paramsDic: ["navTitle":"其他Module的页面","urlString":"https://www.qq.com"])
            
        }
        return row
    }()
    
    lazy var row10 : LabelRow = {
        let row = LabelRow()
        row.title = "类方法调用"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            //            SwiftMediator.shared.callClassMethod(moduleName: "SwiftMediator", objName: "TestClass", selName: "qqqqq:",param: "hahahaha")
            let str = SwiftMediator.shared.callClassMethod(className: "TestClass", selName: "callClassM:", param: "参数:fhfh")?.takeUnretainedValue()
            print("\(String(describing: str))")
            
        }
        return row
    }()
    
    lazy var row11 : LabelRow = {
        let row = LabelRow()
        row.title = "实例方法调用"
        row.subTitle = "可拿实例函数的回传参数"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":"我是字符串","titleName":"我是标题","num":13,"dic":["a":12,"b":"sdfg"]])
            let str = SwiftMediator.shared.callObjcMethod(objc: avc!, selName: "callObjcM:", param: "参数:sdf")?.takeUnretainedValue()
            print("\(String(describing: str))")
            
        }
        return row
    }()
    
    lazy var row12 : LabelRow = {
        let row = LabelRow()
        row.title = "实例方法调用"
        row.subTitle = "用法2"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            let obj = SwiftMediator.shared.initObjc("TestObjc")
            let str = SwiftMediator.shared.callObjcMethod(objc: obj!, selName: "callObjcM:", param: "参数:123")?.takeUnretainedValue()
            print("\(String(describing: str))")
            
        }
        return row
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "路由示例"
        
        former.append(sectionFormer: sectionFormer1,
                      sectionFormer2,
                      sectionFormer3,
                      sectionFormer4,
                      sectionFormer5)
    }
    
}
