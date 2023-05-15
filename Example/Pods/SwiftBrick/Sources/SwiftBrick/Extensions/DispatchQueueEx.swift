//
//  DispatchQueueEx.swift
//  SwiftBrick
//
//  Created by iOS on 2020/11/20.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
import Dispatch

public enum Queue {
    case main
    case background///最低优先级，等同于 DISPATCH_QUEUE_PRIORITY_BACKGROUND. 用户不可见，比如：在后台存储大量数据
    case userInteractive///用户交互相关，为了好的用户体验，任务需要立马执行。使用该优先级用于 UI 更新，事件处理和小工作量任务，在主线程执行
    case userInitiated///优先级等同于 DISPATCH_QUEUE_PRIORITY_HIGH,需要立刻的结果
    case utility///优先级等同于 DISPATCH_QUEUE_PRIORITY_LOW，可以执行很长时间，再通知用户结果。比如：下载一个大文件，网络，计算
    case `default`///默认优先级,优先级等同于 DISPATCH_QUEUE_PRIORITY_DEFAULT，建议大多数情况下使用默认优先级
    case custom(queue: DispatchQueue)
    
    public var queue : DispatchQueue {
        switch self {
        case .main:
            return DispatchQueue.main
        case .background:
            return DispatchQueue.global(qos: .background)
        case .userInteractive:
            return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:
            return DispatchQueue.global(qos: .userInitiated)
        case .utility:
            return DispatchQueue.global(qos: .utility)
        case .default:
            return DispatchQueue.global(qos: .default)
        case .custom(let queue):
            return queue
        }
    }
}

public class Dispatch{
    
    public let queue: Queue
    
    public init(queue: Queue) {
        self.queue = queue
    }
    ///立即执行
    public final func run(_ closure: @escaping () -> Void){
        queue.queue.async{ _ = closure()}
    }
    ///延迟执行
    public final func after(_ seconds: Double, closure: @escaping () -> Void){
        queue.queue.async{
            Dispatch.waitBlock(seconds)()
            _ = closure()
        }
    }

}
extension Dispatch{
    ///主进程执行
    @discardableResult
    public static func main() -> Dispatch{
        return Dispatch(queue: Queue.main)
    }
    
    ///最低优先级，等同于 DISPATCH_QUEUE_PRIORITY_BACKGROUND. 用户不可见，比如：在后台存储大量数据
    @discardableResult
    public static func background() -> Dispatch{
        return Dispatch(queue: Queue.background)
    }
    
    ///用户交互相关，为了好的用户体验，任务需要立马执行。使用该优先级用于 UI 更新，事件处理和小工作量任务，在主线程执行
    @discardableResult
    public static func userInteractive() -> Dispatch{
        return Dispatch(queue: Queue.userInteractive)
    }
    
    //优先级等同于 DISPATCH_QUEUE_PRIORITY_HIGH,需要立刻的结果
    @discardableResult
    public static func userInitiated() -> Dispatch{
        return Dispatch(queue: Queue.userInitiated)
    }
    
    ///优先级等同于 DISPATCH_QUEUE_PRIORITY_LOW，可以执行很长时间，再通知用户结果。比如：下载一个大文件，网络，计算
    @discardableResult
    public static func utility() -> Dispatch{
        return Dispatch(queue: Queue.utility)
    }
    
    ///默认优先级,优先级等同于 DISPATCH_QUEUE_PRIORITY_DEFAULT，建议大多数情况下使用默认优先级
    @discardableResult
    public static func global() -> Dispatch{
        return Dispatch(queue: Queue.default)
    }
    
    ///自定义进程
    @discardableResult
    public static func custom(_ queue: DispatchQueue) -> Dispatch{
        return Dispatch(queue: Queue.custom(queue: queue))
    }
    
    
    fileprivate static func waitBlock(_ seconds: Double) -> () -> Void {
        return {
            let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
            let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
            
            let sem = DispatchSemaphore(value: 0)
            _ = sem.wait(timeout: time)
        }
    }
}

// MARK: ===================================扩展: DispatchQueue延迟方法=========================================
public extension DispatchQueue {
    
    /// 判断主线程
    static var isMainQueue: Bool {
        enum Static {
            static var key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }
        return DispatchQueue.getSpecific(key: Static.key) != nil
    }
}

public extension DispatchQueue {
    
    /// 判断是不是在主线程
    /// - Parameter queue: queue
    /// - Returns: true/false
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()

        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }

        return DispatchQueue.getSpecific(key: key) != nil
    }
    
    /// 延迟闭包
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - qos: qos
    ///   - flags: flags
    ///   - work: 执行闭包
    func asyncAfter(delay: Double,
                    qos: DispatchQoS = .unspecified,
                    flags: DispatchWorkItemFlags = [],
                    execute work: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: work)
    }
    
    /// 延迟闭包
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - action: 执行闭包
    func after(delay: Double, action: @escaping () -> Void) -> () -> Void {
        var lastFireTime = DispatchTime.now()
        let deadline = { lastFireTime + delay }
        return {
            self.asyncAfter(deadline: deadline()) {
                let now = DispatchTime.now()
                if now >= deadline() {
                    lastFireTime = now
                    action()
                }
            }
        }
    }
}
//#endif
