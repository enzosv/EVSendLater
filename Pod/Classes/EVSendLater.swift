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
        savesChanged = true
    }
    
    public func synchronizeSaves(){
        if savesChanged{
            savesChanged = !saves.writeToFile(path, atomically: true)
        }
    }
    
    public func getSavesForUrl(url:String, delete:Bool) -> [[String:AnyObject]]?{
        if let s = saves.objectForKey(url)?.copy() as? [[String:AnyObject]]{
            if delete{
                savesChanged = true
                saves.removeObjectForKey(url)
            }
            return s
        }
        return nil
    }
    
    public func getAllSaves(delete:Bool) -> NSDictionary{
        let s = saves.copy()
        if delete{
            saves.removeAllObjects()
            savesChanged = true
        }
        return s as! NSDictionary
    }
}
