//
//  JHSwiftUIVC.swift
//  SwiftBrick
//
//  Created by 狄烨 on 2023/5/13.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import UIKit
import SwiftUI
@available(iOS 13.0, *)
open class SwiftUIVC<T: View>: ViewController {

    private var hostVC: UIHostingController<T>

    public init(_ view: T) {
        self.hostVC = UIHostingController(rootView: view)
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        hostVC.view.frame = view.bounds
        addChild(hostVC)
        view.addSubview(hostVC.view)
        hostVC.didMove(toParent: self)
    }

}
