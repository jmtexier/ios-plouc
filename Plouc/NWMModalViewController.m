//
//  NWMModalViewController.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 04/01/14.
//  Copyright (c) 2014 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMModalViewController.h"
#import "NWMUIToolkit.h"

@interface NWMModalViewController ()

@end

@implementation NWMModalViewController

-(void)presentIn:(UIViewController *)parent
{
    
    UIViewController *overlay = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    overlay.view.backgroundColor = [UIColor clearColor];
    overlay.view.alpha = 0.5;
    
    [parent presentViewController:overlay animated:YES completion:nil];

    [overlay addChildViewController:self];
    self.view.superview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin
                                            | UIViewAutoresizingFlexibleRightMargin | UIViewContentModeBottomRight;
    self.view.superview.frame = CGRectMake(0, 0, self.originalSize.width, self.originalSize.height);
    self.view.superview.center = [NWMUIToolkit findCenter:UIScreen.mainScreen.bounds];
    if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation)) {
        self.view.superview.center = [NWMUIToolkit rotate:self.view.superview.center];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    return self;
}

- (void)viewDidLoad
{
    // memorize parent size
    self.originalSize = self.view.bounds.size;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
