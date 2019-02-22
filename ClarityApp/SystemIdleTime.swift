//
//  Created by Dariusz Rybicki on 17/04/16.
//  Copyright © 2016 Darrarski. All rights reserved.
//
import Foundation

/**
 Returns number of seconds since system became idle
 
 returns: `Double?`: System idle time in seconds or nil when unable to retrieve it
 */
public func SystemIdleTime() -> Double? {
    var iterator: io_iterator_t = 0
    defer { IOObjectRelease(iterator) }
    guard IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IOHIDSystem"), &iterator) == KERN_SUCCESS else { return nil }
    
    let entry: io_registry_entry_t = IOIteratorNext(iterator)
    defer { IOObjectRelease(entry) }
    guard entry != 0 else { return nil }
    
    var unmanagedDict: Unmanaged<CFMutableDictionary>? = nil
    defer { unmanagedDict?.release() }
    guard IORegistryEntryCreateCFProperties(entry, &unmanagedDict, kCFAllocatorDefault, 0) == KERN_SUCCESS else { return nil }
    guard let cfDict = unmanagedDict?.takeUnretainedValue() else { return nil }
    
    guard let dict = cfDict as? [String: AnyObject] else {
        return nil
    }

    let value = dict["HIDIdleTime"]
    let number: CFNumber = unsafeBitCast(value, to: CFNumber.self)
    var nanoseconds: Int64 = 0
    guard CFNumberGetValue(number, CFNumberType.sInt64Type, &nanoseconds) else { return nil }
    let interval = Double(nanoseconds) / Double(NSEC_PER_SEC)
    
    return interval
}
