//
//  ViewController.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/11.
//

import UIKit
import SwiftUI
import SwiftMediator
import SwiftBrick
import Swift_Form
class DemoViewController: TableViewController {
    
    lazy var former = Former(tableView: self.tableView!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            ///SwiftUI示例
            let controller = UIHostingController(rootView:
                                                    SwiftUIView()
            )
            controller.view.frame = view.bounds
            addChild(controller)
            view.addSubview(controller.view)
            controller.didMove(toParent: self)
            
        } else {
            
            self.title = "路由示例"
            
            former.append(sectionFormer: sectionFormer1,
                          sectionFormer2,
                          sectionFormer3,
                          sectionFormer4,
                          sectionFormer5)
        }
        
    }
    
    lazy var sectionFormer1 : SectionFormer = {
        let sectionFormer = SectionFormer(row1,
                                          row2)
        let header = LabelHeaderFooter()
        header.viewHeight = 20
        header.title = "present page, optional navigation bar, modal style"
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
        header.title = "push page, animation can be turned off"
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
        header.title = "URL jump page, optional push, present"
        header.headerFooter.backColor = .baseTeal
        sectionFormer.set(headerViewFormer: header)
        return sectionFormer
    }()
    
    lazy var sectionFormer4 : SectionFormer = {
        let sectionFormer = SectionFormer(row10,
                                          row11,
                                          row12,
                                          row19,
                                          row20)
        let header = LabelHeaderFooter()
        header.viewHeight = 20
        header.title = "Other method function calls"
        header.headerFooter.backColor = .baseTeal
        sectionFormer.set(headerViewFormer: header)
        return sectionFormer
    }()
    
    lazy var sectionFormer5 : SectionFormer = {
        let sectionFormer = SectionFormer(row9,
                                          row13)
        let header = LabelHeaderFooter()
        header.viewHeight = 20
        header.title = "Cross Component Call"
        header.headerFooter.backColor = .baseTeal
        sectionFormer.set(headerViewFormer: header)
        return sectionFormer
    }()
    
    lazy var row1 : LabelRow = {
        let row = LabelRow()
        row.title = "present page"
        row.subTitle = "Default usage, add navigation bar"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.present("TestVC", paramsDic: ["str":"I am a string",
                                                               "titleName": "present page 1",
                                                               "num": 13,
                                                               "dic":["a":12,
                                                                      "b":"test string"]
                                                              ])
            
        }
        return row
    }()
    
    lazy var row2 : LabelRow = {
        let row = LabelRow()
        row.title = "present page"
        row.subTitle = "Optional modal styles, navbar, etc"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":"I am a string",
                                                                  "titleName": "present page 2",
                                                                  "num": 13,
                                                                  "dic":["a":12,"b":"hh100"]])
            SwiftMediator.shared.present(avc, needNav: false)
            
        }
        return row
    }()
    
    lazy var row3 : LabelRow = {
        let row = LabelRow()
        row.title = "push page"
        row.subTitle = "Manually initialize push"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":"PLA",
                                                                  "titleName": "push page 1",
                                                                  "num": 13,
                                                                  "dic":["a":12,"b":"kk100"]])
            UIViewController.currentNavigationController()?.pushViewController(avc!, animated: true)
            
        }
        return row
    }()
    
    lazy var row4 : LabelRow = {
        let row = LabelRow()
        row.title = "push page"
        row.subTitle = "Default Usage"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.push("TestVC", paramsDic: ["str":"The annual college entrance examination",
                                                            "titleName": "push page 2",
                                                            "num": 13,
                                                            "dic":["a":12,"b":"lkj"]])
            
        }
        return row
    }()
    
    lazy var row5 : LabelRow = {
        let row = LabelRow()
        row.title = "push page"
        row.subTitle = "Optional animation, starting page, etc."
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":";Frame",
                                                                  "titleName": "push page 3",
                                                                  "num": 13,
                                                                  "dic":["a":12,"b":"jlj"]])
            // self.navigationController?.pushViewController(avc!, animated: true)
            SwiftMediator.shared.push(avc, animated: false)
            
        }
        return row
    }()
    
    lazy var row6 : LabelRow = {
        let row = LabelRow()
        row.title = "URL jump page"
        row.subTitle = "push"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.openUrl("app://push/Example/TestVC?str=asdf&titleName=zcxvzcv")
            
        }
        return row
    }()
    
    lazy var row7 : LabelRow = {
        let row = LabelRow()
        row.title = "URL jump page"
        row.subTitle = "present"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.openUrl("app://present/Example/TestVC?str=fhfgdh&titleName=shdhdg&num=111")
            
        }
        return row
    }()
    
    lazy var row8 : LabelRow = {
        let row = LabelRow()
        row.title = "URL jump page"
        row.subTitle = "present, full screen"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.openUrl("app://fullScreen/Example/TestVC?str=zfzvzcv&titleName=fghdfhdgh")
            
        }
        return row
    }()
    
    lazy var row13 : LabelRow = {
        let row = LabelRow()
        row.title = "URL jump page"
        row.subTitle = "Open the webpage H5 of other components"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            ////Here, note that the string encoded into the URL cannot appear special characters, and must be URL-encoded
            SwiftMediator.shared.openUrl("nnn://push/SwiftBrick/JHWebViewController?navTitle=\("Open web page".urlEncoded())&urlString=https://www.qq.com/")
            
        }
        return row
    }()
    
    lazy var row9 : LabelRow = {
        let row = LabelRow()
        row.title = "Open other Module's page"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.push("JHWebViewController",
                                        moduleName: "SwiftBrick",
                                        paramsDic: ["navTitle":"Other Module pages","urlString":"https://www.qq.com"])
            
        }
        return row
    }()
    
    lazy var row10 : LabelRow = {
        let row = LabelRow()
        row.title = "Class method call"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            // SwiftMediator.shared.callClassMethod(moduleName: "SwiftMediator", objName: "TestClass", selName: "qqqqq:",param: "hahahaha")
            let str = SwiftMediator.shared.callClassMethod(className: "TestClass", selName: "callMethodReturn:", param: "parameter:fhfh")?.takeUnretainedValue()
            print("\(String(describing: str))")
            
        }
        return row
    }()
    
    lazy var row19 : LabelRow = {
        let row = LabelRow()
        row.title = "Class method call"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.callClassMethod(className: "TestClass", selName: "callMethod")
            
        }
        return row
    }()
    
    lazy var row20 : LabelRow = {
        let row = LabelRow()
        row.title = "Class method call"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            SwiftMediator.shared.callClassMethod(className: "TestClass", selName: "callMethodNoReturn:", param: "Parameter:fhfh")
            
        }
        return row
    }()
    
    lazy var row11 : LabelRow = {
        let row = LabelRow()
        row.title = "Instance method call"
        row.subTitle = "Can take the return parameters of the instance function"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":"I am a string","titleName":"I am a title","num":13,"dic":["a ":12,"b":"sdfg"]])
            let str = SwiftMediator.shared.callObjcMethod(objc: avc!, selName: "callMethodReturn:", param: "parameter:sdf")?.takeUnretainedValue()
            print("\(String(describing: str))")
            
        }
        return row
    }()
    
    lazy var row12 : LabelRow = {
        let row = LabelRow()
        row.title = "Instance method call"
        row.subTitle = "Usage 2"
        row.cell.addDownLine()
        row.cell.backgroundColor = .baseBGColor
        row.cell.accessoryType = .disclosureIndicator
        row.onSelected { (row) in
            
            let obj = SwiftMediator.shared.initObjc("TestObjc")
            let str = SwiftMediator.shared.callObjcMethod(objc: obj!, selName: "callMethodReturn:", param: "Parameter:123")?.takeUnretainedValue()
            print("\(String(describing: str))")
            
        }
        return row
    }()
    
}
