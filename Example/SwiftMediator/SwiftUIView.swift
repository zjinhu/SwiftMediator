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
                Button("Default usage, add navigation bar") {
                    SwiftMediator.shared.present("TestVC",
                                                 paramsDic: ["str":"I am a string",
                                                             "titleName": "present page 1",
                                                             "num": 13,
                                                             "dic":["a":12,
                                                                    "b":"test string"]
                                                            ])
                }
                
                Button("Optional modal style, navigation bar, etc") {
                    let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":"I am a string",
                                                                          "titleName": "present page 2",
                                                                          "num": 13,
                                                                          "dic":["a":12,"b":"hh100"]])
                    SwiftMediator.shared.present(avc, needNav: false, modelStyle: .popover)
                    
                }
                
            } header: {
                Text("Present")
            }
            
            Section {
                Button("Manually initialize push") {
                    let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":"PLA",
                                                                          "titleName": "push page 1",
                                                                          "num": 13,
                                                                          "dic":["a":12,"b":"kk100"]])
                    UIViewController.currentNavigationController()?.pushViewController(avc!, animated: true)
                }
                
                Button("default usage") {
                    SwiftMediator.shared.push("TestVC", paramsDic: ["str":"The annual college entrance examination",
                                                                    "titleName": "push page 2",
                                                                    "num": 13,
                                                                    "dic":["a":12,"b":"lkj"]])
                }
                
                Button("Optional animation, starting page, etc.") {
                    let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":";Frame",
                                                                          "titleName": "push page 3",
                                                                          "num": 13,
                                                                          "dic":["a":12,"b":"jlj"]])
                    // self.navigationController?.pushViewController(avc!, animated: true)
                    SwiftMediator.shared.push(avc, animated: false)
                }
                
                Text("Hello, World!")
                    .onTapGesture {
                        SwiftMediator.shared.push(Text("123"))
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
                
                Button("present,full screen") {
                    SwiftMediator.shared.openUrl("app://fullScreen/Example/TestVC?str=zfzvzcv&titleName=fghdfhdgh")
                    
                }
 
            } header: {
                Text("URL Jump")
            }
            
            Section {
                Button("Open the webpage H5 of other components") {
                    ////Here, note that the string encoded into the URL cannot appear special characters, and must be URL-encoded
                    SwiftMediator.shared.openUrl("nnn://push/SwiftBrick/WebViewController?navTitle=\("Open web page".urlEncoded())&urlString=https://www.qq.com/")
                    
                }
                
                Button("Open other Module's page") {
                    SwiftMediator.shared.push("WebViewController",
                                              moduleName: "SwiftBrick",
                                              paramsDic: ["navTitle":"Other Module pages","urlString":"https://www.qq.com"])
                }
                
            } header: {
                Text("Cross Namespace Call")
            }
            
            Section {
                Button("Pass parameters, return parameters") {
                    let str = SwiftMediator.shared.callClassMethod(className: "TestClass", selName: "callMethodReturn:", param: "parameter:fhfh")?.takeUnretainedValue()
                    print("\(String(describing: str))")
                }
                
                Button("call class method") {
                    SwiftMediator.shared.callClassMethod(className: "TestClass", selName: "callMethod")
                    
                }
                
                Button("call class method, pass parameters") {
                    SwiftMediator.shared.callClassMethod(className: "TestClass", selName: "callMethodNoReturn:", param: "Parameter:fhfh")
                    
                }
                
                Button("call VC class method") {
                    SwiftMediator.shared.callClassMethod(className: "TestVC", selName: "callClassM")
                    
                }
                
                Button("block") {
 
                    let completion: @convention(block) (Int) -> Void = { int in
                        print("Completed \(int)")
                    }
                    
                    SwiftMediator.shared.callClassMethod(className: "TestClass", selName: "callMethodBlock:", param: completion)
                     
                   
                }
                
                Button("blockParam") {
 
                    let completion: @convention(block) (Int) -> Void = { int in
                        print("Completed \(int)")
                    }
 
                    SwiftMediator.shared.callClassMethod(className: "TestClass", selName: "callMethodBlockWithParame:block:", param: "parameter: 123", otherParam: completion)
                   
                }
                
                
            } header: {
                Text("Class method call")
            }
            
            Section {
                Button("VC pass parameters, return parameters") {
                    let avc = SwiftMediator.shared.initVC("TestVC", dic: ["str":"I am a string","titleName":"I am a title","num":13,"dic":["a ":12,"b":"sdfg"]])
                    let str = SwiftMediator.shared.callObjcMethod(objc: avc!, selName: "callMethodReturn:", param: "parameter:sdf")?.takeUnretainedValue()
                    print("\(String(describing: str))")
                    
                }
                
                Button("instance method call pass parameter, return") {
                    let obj = SwiftMediator.shared.initObjc("TestObjc")
                    let str = SwiftMediator.shared.callObjcMethod(objc: obj!, selName: "callMethodReturn:", param: "parameter:sdf")?.takeUnretainedValue()
                    print("\(String(describing: str))")
                }
                
                Button("instance method call parameter") {
                    let obj = SwiftMediator.shared.initObjc("TestObjc")
                    SwiftMediator.shared.callObjcMethod(objc: obj!, selName: "callMethodNoReturn:", param: "Parameter: 123")
                }
                
                Button("instance method call") {
                    let obj = SwiftMediator.shared.initObjc("TestObjc")
                    
                    SwiftMediator.shared.callObjcMethod(objc: obj!, selName: "callMethod", param: "parameter: 123")
                }
                
                Button("block") {
                    let obj = SwiftMediator.shared.initObjc("TestObjc")
                    
                    let completion: @convention(block) (Int) -> Void = { int in
                        print("Completed \(int)")
                    }
                    
                    SwiftMediator.shared.callObjcMethod(objc: obj!, selName: "callMethodBlock:", param: completion)
                   
                }
                
                Button("blockParam") {
                    let obj = SwiftMediator.shared.initObjc("TestObjc")
                    
                    let completion: @convention(block) (Int) -> Void = { int in
                        print("Completed \(int)")
                    }
                    
                    SwiftMediator.shared.callObjcMethod(objc: obj!, selName: "callMethodBlockWithParame:block:", param: "parameter: 123", otherParam: completion)
                   
                }

                
            } header: {
                Text("instance method call")
            }
            
            Spacer()
                .height(60)
                .listRowBackground(Color.clear)
        }
    }
}
@available(iOS 13.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
