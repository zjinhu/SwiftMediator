//
//  SwiftUIView.swift
//  Example
//
//  Created by iOS on 2023/5/19.
//

import SwiftUI
import SwiftMediator
@available(iOS 13.0, *)
struct SwiftUIView: View {
    var body: some View {
        List {
            Section {
                Button("默认用法,添加导航栏") {
                    SwiftMediator.shared.present("TestVC",
                                                 paramsDic: ["str":"我是字符串",
                                                             "titleName":"present页面1",
                                                             "num":13,
                                                             "dic":["a":12,
                                                                    "b":"测试字符串"]
                                                            ])
                }
                
                Button("可选模态样式,导航栏等") {
                    let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":"我是字符串",
                                                                          "titleName":"present页面2",
                                                                          "num":13,
                                                                          "dic":["a":12,"b":"hh100"]])
                    SwiftMediator.shared.present(avc, needNav: false, modelStyle: 1)
                  
                }
                
            } header: {
                Text("Present")
            }
            
            Section {
                Button("手动初始化push") {
                    let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":"解放军",
                                                                          "titleName":"push页面1",
                                                                          "num":13,
                                                                          "dic":["a":12,"b":"kk100"]])
                    SwiftMediator.shared.currentNavigationController()?.pushViewController(avc!, animated: true)
                }
                
                Button("默认用法") {
                    SwiftMediator.shared.push("TestVC", paramsDic: ["str":"每年高考",
                                                                    "titleName":"push页面2",
                                                                    "num":13,
                                                                    "dic":["a":12,"b":"lkj"]])
                }
                
                Button("可选动画,出发页面等") {
                    let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":";框架",
                                                                          "titleName":"push页面3",
                                                                          "num":13,
                                                                          "dic":["a":12,"b":"jlj"]])
                    //            self.navigationController?.pushViewController(avc!, animated: true)
                    SwiftMediator.shared.push(avc, animated: false)
                }
                
            } header: {
                Text("Push")
            }
            
            Section {
                Button("push") {
                    SwiftMediator.shared.openUrl("app://push/Example/TestVC?str=asdf&titleName=zcxvzcv")
                }
                
                Button("present") {
                    SwiftMediator.shared.openUrl("app://present/Example/TestVC?str=fhfgdh&titleName=shdhdg&num=111")
                  
                }
                
                Button("present,全屏") {
                    SwiftMediator.shared.openUrl("app://fullScreen/Example/TestVC?str=zfzvzcv&titleName=fghdfhdgh")
                  
                }
 
            } header: {
                Text("URL跳转")
            }
            
            Section {
                Button("打开其他组件的网页H5") {
                    ////此处注意编进URL的字符串不能出现特殊字符,要进行URL编码
                    SwiftMediator.shared.openUrl("nnn://push/SwiftBrick/WebViewController?navTitle=\("打开网页".urlEncoded())&urlString=https://www.qq.com/")
                  
                }
                
                Button("打开其他Module的页面") {
                    SwiftMediator.shared.push("WebViewController",
                                              moduleName: "SwiftBrick",
                                              paramsDic: ["navTitle":"其他Module的页面","urlString":"https://www.qq.com"])
                }
                
            } header: {
                Text("跨命名空间调用")
            }
            
            Section {
                Button("传递参数,返回参数") {
                    let str = SwiftMediator.shared.callClassMethod(className: "TestClass", selName: "callMethodReturn:", param: "参数:fhfh")?.takeUnretainedValue()
                    print("\(String(describing: str))")
                }
                
                Button("调用类方法") {
                    SwiftMediator.shared.callClassMethod(className: "TestClass", selName: "callMethod")
                  
                }
                
                Button("调用类方法,传递参数") {
                    SwiftMediator.shared.callClassMethod(className: "TestClass", selName: "callMethodNoReturn:", param: "参数:fhfh")
                  
                }
                
                Button("调用VC类方法") {
                    SwiftMediator.shared.callClassMethod(className: "TestVC", selName: "callClassM")
                  
                }
                
            } header: {
                Text("类方法调用")
            }
            
            Section {
                Button("VC传递参数,返回参数") {
                    let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":"我是字符串","titleName":"我是标题","num":13,"dic":["a":12,"b":"sdfg"]])
                    let str = SwiftMediator.shared.callObjcMethod(objc: avc!, selName: "callMethodReturn:", param: "参数:sdf")?.takeUnretainedValue()
                    print("\(String(describing: str))")
                  
                }
                
                Button("实例方法调用传参,返回") {
                    let obj = SwiftMediator.shared.initObjc("TestObjc")
                    let str = SwiftMediator.shared.callObjcMethod(objc: obj!, selName: "callMethodReturn:", param: "参数:sdf")?.takeUnretainedValue()
                    print("\(String(describing: str))")
                }
                
                Button("实例方法调用传参") {
                    let obj = SwiftMediator.shared.initObjc("TestObjc")
                    SwiftMediator.shared.callObjcMethod(objc: obj!, selName: "callMethodNoReturn:", param: "参数:123")
                }
                
                Button("实例方法调用") {
                    let obj = SwiftMediator.shared.initObjc("TestObjc")
        
                    SwiftMediator.shared.callObjcMethod(objc: obj!, selName: "callMethod", param: "参数:123")
                }
                
            } header: {
                Text("实例方法调用")
            }
        }
    }
}
@available(iOS 13.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
