//
//  EVSendLater.swift
//  Pods
//
//  Created by Lorenzo Rey Vergara on 08/10/2015.
//
//

public class EVSendLater : NSObject {
    
    private var saves:NSMutableDictionary!
    private var savesChanged = false
    private var savesCreated = false
    private let path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("EVSendLaters")
    public var saveImmediately = false
    
    public class var sharedManager : EVSendLater {
        struct Static {
            static let instance : EVSendLater = EVSendLater()
            
        }
        Static.instance.initializeSaves()
        return Static.instance
    }
    
    private func initializeSaves(){
        if !savesCreated{
            let fileManager = NSFileManager.defaultManager()
            
            if !fileManager.fileExistsAtPath(path){
                saves = NSMutableDictionary()
            } else{
                saves = NSMutableDictionary(contentsOfFile: path)
            }
            savesCreated = true
        }
        
    }
    
    
    public func saveForLater(url:String, params:[NSObject:AnyObject]){
        if let list = saves.objectForKey(url) as? NSMutableArray{
            list.addObject(params)
        } else{
            saves.setObject(NSMutableArray(array: [params]), forKey: url)
        }
        
        setSavesChanged()
    }
    
    public func synchronizeSaves(){
        if savesChanged{
            savesChanged = !saves.writeToFile(path, atomically: true)
        }
    }
    
    public func getSavesForUrl(url:String, delete:Bool) -> [[String:AnyObject]]?{
        return saves.objectForKey(url)?.copy() as? [[String:AnyObject]]
    }
    
    public func getAllSaves() -> NSDictionary{
        return saves
    }
    
    public func removeFromSaves(url:String, params:[String:AnyObject]){
        if let array = saves.objectForKey(url) as? NSMutableArray{
            array.removeObject(params)
            setSavesChanged()
        }
    }
    
    func setSavesChanged(){
        savesChanged = true
        if saveImmediately{
            synchronizeSaves()
        }
    }
}
