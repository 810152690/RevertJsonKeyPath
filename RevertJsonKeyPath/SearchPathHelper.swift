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
                    keyValueNode.key = key;
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
                            let subpParentNameWithIndex = "\(subpParentName)_\(position)"
                            self.parseDictionary(params: object, parentName: subpParentNameWithIndex, index: position)
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
    
    func search(word: String) -> [String] {
        var paths:[String] = []
        let searchKeyResultPaths = self.searchByKey(searchKey: word)
        if searchKeyResultPaths.count > 0 {
            paths.append("根据key搜索的结果：")
            paths += searchKeyResultPaths
        }
        
        let searchValueResultPaths = self.searchByValue(searchValue: word)
        if searchValueResultPaths.count > 0 {
            paths.append("根据value搜索的结果：")
            paths += searchValueResultPaths
        }
        return paths
    }
    
    func searchByKey(searchKey: String) -> [String] {
        var paths:[String] = []
        
        for node in self.nodeList {
            if let _key = node.key{
                var path = ""
                if _key == searchKey{
                    path = "\(node.parentName)->\(_key)"
                    paths.append(path)
//                    if let _index = node.index{
//                        path = "\(node.parentName)->\(_key)_\(_index)"
//                        paths.append(path)
//                    }else{
//                        path = "\(node.parentName)->\(_key)"
//                        paths.append(path)
//                    }
                }
            }
        }
        return paths
    }
    
    func searchByValue(searchValue: String) -> [String] {
        var paths:[String] = []
        for node in self.nodeList {
            if let _value = node.value{
                
                var valueToString = ""
                if _value is String, let valueString = _value as? String{
                    valueToString = valueString
                }else if _value is NSNumber, let valueNumber = _value as? NSNumber {
                    valueToString = "\(valueNumber)"
                }
                if valueToString == searchValue{
                    var path = ""
                    if let _key = node.key{
                        path = "\(node.parentName)->\(_key) : \(valueToString)"
//                        if let _index = node.index{
//                            path = "\(node.parentName)->\(_key)_\(_index) : \(valueToString)"
//                        }else{
//                            path = "\(node.parentName)->\(_key) : \(valueToString)"
//                        }
                    }else{
                        path = "\(node.parentName): \(valueToString)"
                    }
                    
                    paths.append(path)
                }
            }
        }
        return paths;
    }
}
