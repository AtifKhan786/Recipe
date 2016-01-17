//
//  StepsWithImageCollectionViewCell.swift
//  Recipe
//
//  Created by atif on 6/19/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//
//UIColor(red: 33.0/255.0, green: 133.0/255.0, blue: 89.0/255.0, alpha: 1.0) // Green
//UIColor(red: 20.0/255.0, green: 141.0/255.0, blue: 228.0/255.0, alpha: 1.0) // Blue

import UIKit

class StepsWithImageCollectionViewCell: BackgroundImageLayerCollectionViewCell {
    let numberRadius = CGFloat(60.0)
    var numberMainLayer_:CALayer?
    var numberCircleLayer:CAShapeLayer?
    var numberTextLabel = UILabel()
    var textView = UITextView()
    
    override func setItem(item: Item) {
        super.setItem(item)
        commonInit()

        textView.text = item.name
        if item.subItemIndex != nil {
            let text = "\(item.subItemIndex! + 1)"
            numberTextLabel.text = text
        }else { }
        
    }
    
    private func commonInit(){
        if numberMainLayer_ != nil {return}
        numberMainLayer_ = CALayer()
        numberCircleLayer = CAShapeLayer()

        
        numberMainLayer_?.addSublayer(numberCircleLayer!)
        
        numberCircleLayer?.strokeColor = UIColor(red: 20.0/255.0, green: 141.0/255.0, blue: 228.0/255.0, alpha: 1.0).CGColor
        numberCircleLayer?.lineWidth = 4
        numberCircleLayer?.fillColor = UIColor.clearColor().CGColor

        
        self.backgroundColor = UIColor.whiteColor()
        textView.font = Theme.mainTheme().lightFont(20)
        textView.editable = false
        textView.textContainerInset = UIEdgeInsetsZero
        textView.scrollEnabled = true
        
        numberTextLabel.backgroundColor = UIColor.whiteColor()
        numberTextLabel.textAlignment = NSTextAlignment.Center
        numberTextLabel.font = Theme.mainTheme().boldFont(28)
        numberTextLabel.textColor = UIColor(red: 20.0/255.0, green: 141.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        numberMainLayer_?.backgroundColor = UIColor.clearColor().CGColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    private func setUpNumberLayers(){
        commonInit()

        numberMainLayer_?.frame = stepNumberFrame()
        numberTextLabel.frame = numberMainLayer_!.frame
        let bound = numberMainLayer_!.bounds

        numberCircleLayer?.frame = bound
        
        let bezierPath = UIBezierPath(ovalInRect: bound)
        numberCircleLayer?.path = bezierPath.CGPath
        
    }
    
    private func setUpLayers(){
        if textView.superview == nil {
            self.contentView .addSubview(textView)
            self.contentView.addSubview(numberTextLabel)

        }
        setUpNumberLayers()
        if numberMainLayer_?.superlayer == nil && numberMainLayer_ != nil{
            self.contentView.layer .addSublayer(numberMainLayer_!)
        }
        
      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUpLayers()
        let cellWidth = self.bounds.size.width
        
        textView.frame = CGRectMake(20, 20, cellWidth - 40.0 , self.bounds.size.height - 40)
        let exclusionPath = UIBezierPath(ovalInRect: CGRectMake(0, 0, numberRadius + 5, numberRadius))
        //UIBezierPath(rect: CGRectMake(0, 0, numberRadius + 5, numberRadius ))
        textView.textContainer.exclusionPaths = [exclusionPath]
    }
    
//    override func setImageLayerFrame(){
//        let imgFrame = contentView.bounds
//        imgLayer_?.frame = imgFrame
//    }

    private func stepNumberFrame() -> CGRect {
        let frame = CGRectMake(20, 20, numberRadius, numberRadius)
        return frame
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        self.layoutIfNeeded()
        self.updateConstraints()
//
//        var height = textView.contentSize.height
        var height = textView.systemLayoutSizeFittingSize(CGSizeMake(size.width - 40, 1000)).height
        height += 40
        if height < numberRadius + 40 {
            height = numberRadius + 40
        }
        height = ceil(height)
        let newSize = CGSizeMake(size.width, height)
        return newSize
    }
}
