//
//  ViewController.swift
//  RevertJsonKeyPath
//
//  Created by zhu bangqian on 2018/9/5.
//  Copyright © 2018年 zhu bangqian. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var jsonTextView: NSScrollView!
    @IBOutlet weak var keyWordTextField: NSTextField!
    
    @IBOutlet var inputJsonTextView: NSTextView!
    
    @IBOutlet var resultTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        jsonTextView.inputContext
    }
    @IBAction func pressedSearch(_ sender: Any) {
        let jsonString = inputJsonTextView.string;
        let jsonData = jsonString.data(using: .utf8);
        var jsonDic: NSDictionary?
        if let _jsonData = jsonData {
            do{
                try jsonDic = JSONSerialization.jsonObject(with: _jsonData, options: .mutableContainers) as? NSDictionary;
            }catch{
                
            }
        }
        
        print("jsonDic : \(String(describing: jsonDic))");
        
        let searchPathHelper = SearchPathHelper.init()
        searchPathHelper.parseDictionary(params: jsonDic as! [String : AnyObject], parentName: nil, index: nil)
        print("count: \(searchPathHelper.nodeList.count)")
        
        let searchPath = self.keyWordTextField.stringValue
        let results = searchPathHelper.search(word: searchPath)//searchByK(searchKey: searchPath)
        var joinResult = "\n"
        for resultPath in results {
            joinResult += resultPath
            joinResult += "\n"
        }
        
        resultTextView.string = joinResult;
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
}

