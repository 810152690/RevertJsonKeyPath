//
//  SearchPathHelper.swift
//  RevertJsonKeyPath
//
//  Created by zhu bangqian on 2018/9/5.
//  Copyright © 2018年 zhu bangqian. All rights reserved.
//

import Cocoa

struct KeyValueNode {
    var parentName: String = ""
    var index: Int?
    var key: String?
    var value: AnyObject?
}

class SearchPathHelper: NSObject {
    var nodeList: [KeyValueNode] = []
    
    func parseDictionary(params:[String:AnyObject], parentName:String?, index:Int?) {
        for key in params.keys {
            let value = params[key]
            if let _value = value {
                if (_value is String) || (_value is NSNumber){
                    var keyValueNode = KeyValueNode()
                    if let _parentName = parentName{
                        keyValueNode.parentName = _parentName
                    }
                    keyValueNode.key = key
                    keyValueNode.value = value
                    keyValueNode.index = index;
                    nodeList.append(keyValueNode);
                }else if _value is [String:AnyObject]{//字典
                    let subDic = _value as! [String:AnyObject];
                    var subpParentName = ""//"\(parentName) -> \(key)"
                    if let _parentName = parentName{
                        subpParentName = _parentName;
                        subpParentName = "\(subpParentName) -> \(key)"
                    }else{
                        subpParentName = key;
                    }
                    self.parseDictionary(params: subDic, parentName: subpParentName, index: nil)
                    var keyValueNode = KeyValueNode()
                    if let _parentName = parentName{
                        keyValueNode.parentName = _parentName
                    }
                    keyValueNode.index = index;
                    nodeList.append(keyValueNode);
                    
                }else if _value is [[String:AnyObject]]{
                    let subDicts = _value as! [[String:AnyObject]]
                    if subDicts.count > 0{
                        var subpParentName = ""//"\(parentName) -> \(key)"
                        if let _parentName = parentName{
                            subpParentName = _parentName;
                            subpParentName = "\(subpParentName) -> \(key)"
                        }else{
                            subpParentName = key;
                        }
                        
                        for position in 0...subDicts.count-1{
                            let object = subDicts[position];
                            self.parseDictionary(params: object, parentName: subpParentName, index: position)
                        }
                        var keyValueNode = KeyValueNode()
                        keyValueNode.parentName = subpParentName
                        keyValueNode.key = key
                        keyValueNode.index = index
                        nodeList.append(keyValueNode);
                    }
                }
            }
        }
    }
    
    func searchByKey(searchKey: String) -> [String] {
        var paths:[String] = []
        
        for node in self.nodeList {
            if let _key = node.key{
                if _key == searchKey{
                    let path = "\(node.parentName)->\(_key)"
                    paths.append(path)
                }
            }
        }
        return paths
    }
}
