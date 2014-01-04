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
#import "NWMScoreViewController.h"
#import "NWMHelpViewController.h"
#import "NWMUIToolkit.h"

@interface NWMMenuViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;

@end


@implementation NWMMenuViewController

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    //round buttons
    [NWMUIToolkit roundButtons:@[self.startNewGameButton, self.helpButton,
                                 self.scoreButton, self.optionsButton]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - Callbacks and events

- (IBAction)startNewGameButton:(id)sender {
    NWMBoardViewController *boardVC = [[NWMBoardViewController alloc] init];
    [self.navigationController pushViewController:boardVC animated:YES];
}

- (IBAction)helpButton:(id)sender {
    NWMHelpViewController *helpVC = [[NWMHelpViewController alloc] init];
    [self.navigationController pushViewController:helpVC animated:YES];
}
- (IBAction)scoreButton:(id)sender {
    NWMScoreViewController *scoreVC = [[NWMScoreViewController alloc] init];
    [self.navigationController pushViewController:scoreVC animated:YES];
}

- (IBAction)optionsButton:(id)sender {
    NWMOptionsViewController *optionsVC = [[NWMOptionsViewController alloc] init];
    [self.navigationController pushViewController:optionsVC animated:YES];
}

@end
