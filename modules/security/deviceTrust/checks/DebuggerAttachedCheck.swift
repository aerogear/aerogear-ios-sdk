import Foundation

/**
 IsDebuggerCheck implements the `DeviceCheck` protocol

 It can check whether or not the application is being debugged
 */
public class DebuggerAttachedCheck: DeviceCheck {
    public var name = "Debugger check"

    public init() {}

    /**
     - Check if a debugger is attached.

     - Returns: A Device Check result with a true or false passing property
     */
    public func check() -> DeviceCheckResult {
        return DeviceCheckResult(self.name, isDebuggerAttached())
    }
    
    private func isDebuggerAttached() -> Bool {
        var info = kinfo_proc()
        var mib : [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
}
