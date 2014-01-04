//
//  NWMOptionsViewController.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 29/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMOptionsViewController.h"
#import "NWMUIToolkit.h"

@interface NWMOptionsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation NWMOptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //round buttons
    [NWMUIToolkit roundButtons:@[self.backButton, self.saveButton]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSaveButton:(id)sender
{
    NSLog(@"Saving options...");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
