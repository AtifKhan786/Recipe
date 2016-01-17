//
//  Theme.swift
//  Recipe
//
//  Created by atif on 6/15/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class Theme: NSObject {

    private static var themeInUse_:Theme = Theme()
    
    private var fontName_regular:String
    private var fontName_bold:String
    private var fontName_light:String
    private var fontName_thin:String

    override  init() {
        fontName_regular    = "SFUIText-Regular"
        fontName_bold       = "SFUIText-Bold"
        fontName_light      = "SFUIDisplay-Light"//SFUIDisplay-Light, SFUIDisplay-Thin
        fontName_thin      = "SFUIDisplay-Thin"//SFUIDisplay-Light,

        //Theme.printFont()
        super.init()
    }

    class func printFont(){
        let families = UIFont.familyNames()
        for family in families {
            let fonts = UIFont.fontNamesForFamilyName(family )
            debugPrint("Family: \(family) Fonts -- \(fonts)")
        }
    }
    
    class func mainTheme() ->Theme {
        return Theme.themeInUse_
    }
    
    func regularFont(size:CGFloat) -> UIFont {
        let font = UIFont(name: fontName_regular, size: size)
        return font!
    }
    
    func boldFont(size:CGFloat ) -> UIFont {
        let font = UIFont(name: fontName_bold, size: size)
        return font!
    }
    
    func lightFont(size:CGFloat) -> UIFont {
        let font = UIFont(name: fontName_light, size: size)
        return font!
    }
    
    func thinFont(size:CGFloat ) ->UIFont {
        let font = UIFont(name: fontName_thin, size: size)
        return font!
    }
}
