//
//  NWMMenuViewController.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 29/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMMenuViewController.h"

#import "NWMBoardViewController.h"
#import "NWMOptionsViewController.h"
#import "NWMHelpViewController.h"

@implementation NWMMenuViewController

- (IBAction)startNewGameButton:(id)sender {
    NWMBoardViewController *boardVC = [[NWMBoardViewController alloc] init];
    [self.navigationController pushViewController:boardVC animated:YES];
}

- (IBAction)helpButton:(id)sender {
    NWMHelpViewController *helpVC = [[NWMHelpViewController alloc] init];
    [self.navigationController pushViewController:helpVC animated:YES];
}

- (IBAction)optionsButton:(id)sender {
    NWMOptionsViewController *optionsVC = [[NWMOptionsViewController alloc] init];
    [self.navigationController pushViewController:optionsVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Plouc!";
}

@end
