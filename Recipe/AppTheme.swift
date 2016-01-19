//
//  AppTheme.swift
//  Recipe
//
//  Created by atif on 1/19/16.
//  Copyright © 2016 Atif Khan. All rights reserved.
//

import Foundation


struct AppThemeData {
    let defaultTextColor:UIColor
    var tintTextColor:UIColor
    let backgroundColor:UIColor
    let headerTextColor:UIColor
    
    
    let darkBlur:Bool // Used by blur effect
    
    let titleFont:UIFont
    let subTitleFont:UIFont
    let descriptionFont:UIFont
    let mainBodyFont:UIFont
    let headerTitleFont:UIFont
}


class AppTheme {

    static func defaultTheme() -> AppThemeData {
    
        return darkTheme()
    }
    
    static func darkTheme() -> AppThemeData {
        
        let defTextColor = UIColor.whiteColor()
        let tintTextColor = UIColor(red: 0, green: 145.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        let headerTextColor = UIColor(red: 114.0/255.0, green: 180.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        ////114,180,35

        let backColor = UIColor.blackColor()
        let darBlur = true
        let titleFont    = UIFont.boldSystemFontOfSize(20)
        let subTitleFont = UIFont.systemFontOfSize(17)
        let descrFont    = UIFont.systemFontOfSize(14)
        let mainBodyFont    = UIFont.systemFontOfSize(17)
        let headerTitleFont = UIFont.systemFontOfSize(21)

        let appThemeData = AppThemeData(defaultTextColor: defTextColor, tintTextColor: tintTextColor, backgroundColor: backColor, headerTextColor: headerTextColor, darkBlur: darBlur, titleFont: titleFont, subTitleFont: subTitleFont, descriptionFont: descrFont, mainBodyFont: mainBodyFont, headerTitleFont: headerTitleFont)
        return appThemeData
    }
}