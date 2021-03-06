//
//  NWMUIToolkit.h
//  Plouc
//
//  Created by Jean-Michel TEXIER on 02/01/14.
//  Copyright (c) 2014 Jean-Michel TEXIER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWMUIToolkit : NSObject

+(void)roundButtons:(NSArray *)buttons;
+(void)roundButton:(UIButton *)button;

+(CGPoint)rotate:(CGPoint)point;
+(CGPoint)findCenter:(CGRect)bounds;

@end
