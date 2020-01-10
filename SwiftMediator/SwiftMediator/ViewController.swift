//
//  ViewController.swift
//  SwiftMediator
//
//  Created by iOS on 27/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
import SwiftBrick
class ViewController: JHTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "路由示例"
        self.mainDatas = ["present用法1","present用法2","push用法1","push用法2","push用法3","URL用法1","URL用法2","URL用法3","Test Push到其他POD","类方法调用","实例方法调用"]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JHTableViewCell.dequeueReusableCell(tableView: tableView)
        cell.textLabel?.text = self.mainDatas[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // MARK: - present用法-
            SwiftMediator.shared.present(moduleName: "SwiftMediator", toVC: "TestVC",paramsDic: ["str":"123123","titleName":"23452345","num":13,"dic":["a":12,"b":"100"]])
        case 1:
            // MARK: - present用法二
            let avc = SwiftMediator.shared.initVC(moduleName: "SwiftMediator", vcName: "TestVC",dic: ["str":"123123","titleName":"23452345","num":13,"dic":["a":12,"b":"100"]])
            SwiftMediator.shared.currentViewController()?.present(avc!, animated: true, completion: nil)
        case 2:
            // MARK: - push用法一
            let avc = SwiftMediator.shared.initVC(moduleName: "SwiftMediator", vcName: "TestVC",dic: ["str":"123123","titleName":"23452345","num":13,"dic":["a":12,"b":"100"]])
            SwiftMediator.shared.currentNavigationController()?.pushViewController(avc!, animated: true)
        case 3:
            // MARK: - push用法二
            SwiftMediator.shared.push(moduleName: "SwiftMediator", toVC: "TestVC",paramsDic: ["str":"123123","titleName":"23452345","num":13,"dic":["a":12,"b":"100"]])
        case 4:
            // MARK: - push用法三
            let avc = SwiftMediator.shared.initVC(moduleName: "SwiftMediator", vcName: "TestVC",dic: ["str":"123123","titleName":"23452345","num":13,"dic":["a":12,"b":"100"]])
            self.navigationController?.pushViewController(avc!, animated: true)
        case 5:
            // MARK: - URL用法1
            SwiftMediator.shared.openUrl("app://push/SwiftMediator/TestVC?str=123&titleName=456")
        case 6:
            // MARK: - URL用法2
            SwiftMediator.shared.openUrl("app://present/SwiftMediator/TestVC?str=123&titleName=456&num=111")
        case 7:
            // MARK: - URL用法3
            SwiftMediator.shared.openUrl("app://fullScreen/SwiftMediator/TestVC?str=123&titleName=456")
        case 8:
            SwiftMediator.shared.push(moduleName: "SwiftBrick", toVC: "JHWebViewController",paramsDic: ["navTitle":"123123","url":"https://www.qq.com"])
        case 9:
//            SwiftMediator.shared.callClassMethod(moduleName: "SwiftMediator", objName: "TestClass", selName: "qqqqq:",param: "hahahaha")
            let str = SwiftMediator.shared.callClassMethod(moduleName: "SwiftMediator", className: "TestClass", selName: "qqqqq:", param: "123123123")?.takeUnretainedValue()
            print("\(String(describing: str))")
        case 10:
            let avc = SwiftMediator.shared.initVC(moduleName: "SwiftMediator", vcName: "TestVC",dic: ["str":"123123","titleName":"23452345","num":13,"dic":["a":12,"b":"100"]])
            let str = SwiftMediator.shared.callObjcMethod(objc: avc!, selName: "pppppp:", param: "123123123123")?.takeUnretainedValue()
            print("\(String(describing: str))")

        default:
            print("")
        }
    }
}
