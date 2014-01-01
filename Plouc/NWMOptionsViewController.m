//
//  NWMOptionsViewController.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 29/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMOptionsViewController.h"

@interface NWMOptionsViewController ()

@end

@implementation NWMOptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Options";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(saveOptions)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveOptions
{
    NSLog(@"Saving options...");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
