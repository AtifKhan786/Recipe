//
//  ReceipeItemDetail.swift
//  Recipe
//
//  Created by atif on 6/18/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class ReceipeItemDetail: Item {

    override init(info: [NSString : AnyObject]) {
        
        super.init(info: info)
  
    }
    
    //    MARK: Used only for simulation purpose
    
    class func simulatedReceipeDetail() -> ReceipeItemDetail?{
        
        let url = NSBundle.mainBundle().URLForResource("productpage", withExtension: "json")
        
        let inputStream = NSInputStream(URL: url!)
        inputStream?.open()
        do {
            let parsedData = (try NSJSONSerialization.JSONObjectWithStream(inputStream!, options: NSJSONReadingOptions.MutableContainers)) as? Dictionary<NSString,AnyObject>
            let receipeDetail = ReceipeItemDetail(info: parsedData!)
            return receipeDetail
        } catch {
            
        }
        
        return nil
    }
}
