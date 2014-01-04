//
//  NWMModalViewController.h
//  Plouc
//
//  Created by Jean-Michel TEXIER on 04/01/14.
//  Copyright (c) 2014 Jean-Michel TEXIER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWMModalViewController : UIViewController

@property CGSize originalSize;

-(void)presentIn:(UIViewController *)parent;

@end
