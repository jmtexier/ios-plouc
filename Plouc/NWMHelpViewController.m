//
//  NWMHelpViewController.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 29/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMHelpViewController.h"

@interface NWMHelpViewController ()

@end

@implementation NWMHelpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.navigationItem.title = @"How To Play";
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
