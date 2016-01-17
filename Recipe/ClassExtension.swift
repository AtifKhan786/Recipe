//
//  StringExtension.swift
//  Recipe
//
//  Created by atif on 7/6/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

extension Dictionary {
    static func dictionaryForAttributeString(font:UIFont?, textColor:UIColor?, kern:CGFloat?) -> Dictionary<String, AnyObject>{
        var dictionary = Dictionary<String, AnyObject> ()
        if font != nil {
            dictionary[NSFontAttributeName] = font!
        }
        
        if textColor != nil {
            dictionary[NSForegroundColorAttributeName] = textColor!
        }
        
        if kern != nil {
            dictionary[NSKernAttributeName] = kern!
        }
        
        return dictionary
    }

}

extension String {
    
    func attributeString(font:UIFont?, textColor:UIColor?, kern:CGFloat?) -> NSAttributedString{
        
        var dictionary = Dictionary<String, AnyObject> ()
        if font != nil {
            dictionary[NSFontAttributeName] = font!
        }
        
        if textColor != nil {
            dictionary[NSForegroundColorAttributeName] = textColor!
        }
        
        if kern != nil {
            dictionary[NSKernAttributeName] = kern!
        }
        
        let attr = NSAttributedString(string: self, attributes: dictionary)
        return attr
    }
    
}


extension NSAttributedString  {
    
   static func dictionaryForAttributeString(font:UIFont?, textColor:UIColor?, kern:CGFloat?) -> Dictionary<String, AnyObject>{
        var dictionary = Dictionary<String, AnyObject> ()
        if font != nil {
            dictionary[NSFontAttributeName] = font!
        }
        
        if textColor != nil {
            dictionary[NSForegroundColorAttributeName] = textColor!
        }
        
        if kern != nil {
            dictionary[NSKernAttributeName] = kern!
        }
        
        return dictionary
    }

    
    func attributedStringForFirstMatchWithNewAttributes(matchString:String, attributes:Dictionary<String, AnyObject>) ->NSAttributedString?{
        let completeString = self.string as NSString
        let range = completeString.rangeOfString(matchString as String, options: NSStringCompareOptions.CaseInsensitiveSearch)
//        var r:Range?= nil
        if (range.location != NSNotFound) {
            let mutatedAttributeString = self.mutableCopy() as! NSMutableAttributedString
            mutatedAttributeString.setAttributes(attributes, range: range)
            return mutatedAttributeString
        }
            return nil
    }
}

extension UIColor {

    static func GreanPeasTexture () -> UIColor{
        let img = UIImage(named: "green-peas-texture")
        let color = UIColor(patternImage: img!)
        
        return color
    }
    
    static func OtherNeedItemTextureBackground() -> UIColor{
        return UIColor.darkGrayColor()
    }
    
    static func IngredientTextureBackground() -> UIColor{
        return UIColor(red: 172.0, green: 22.0, blue: 58.0, alpha: 1.0)
    }
}

extension UIView {
    
    class func convertToImage(view:UIView, afterScreenUpdate:Bool) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: afterScreenUpdate)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func convertToImage(view:UIView) -> UIImage {
        return convertToImage(view, afterScreenUpdate: false)
    }
}
