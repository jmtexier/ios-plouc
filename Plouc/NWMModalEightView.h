//
//  NWMModalEightView.h
//  Plouc
//
//  Created by Jean-Michel TEXIER on 04/01/14.
//  Copyright (c) 2014 Jean-Michel TEXIER. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NWMModalEightDelegate

-(void)onColorSelected:(NSUInteger)color;

@end

@interface NWMModalEightView : UIView

@property (weak, nonatomic) id<NWMModalEightDelegate> delegate;

@end
