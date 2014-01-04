//
//  NWMUIToolkit.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 02/01/14.
//  Copyright (c) 2014 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMUIToolkit.h"

@implementation NWMUIToolkit

+(void)roundButtons:(NSArray *)buttons
{
    for(UIButton *button in buttons) {
        [self roundButton:button];
    }
}

+(void)roundButton:(UIButton *)button
{
    button.layer.cornerRadius = 6;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blackColor].CGColor;
}

+(CGPoint)rotate:(CGPoint)point
{
    return CGPointMake(point.y, point.x);
}

+(CGPoint)findCenter:(CGRect)bounds
{
    return CGPointMake(bounds.origin.x + (bounds.size.width / 2), bounds.origin.y + (bounds.size.height / 2));
}

@end
