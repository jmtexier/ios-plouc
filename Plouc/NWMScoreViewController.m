//
//  NWMScoreViewController.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 02/01/14.
//  Copyright (c) 2014 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMScoreViewController.h"
#import "NWMUIToolkit.h"

@interface NWMScoreViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UITableView *scoreTable;

@end

@implementation NWMScoreViewController

#pragma mark - ViewController methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //round buttons
    [NWMUIToolkit roundButtons:@[self.menuButton, self.resetButton]];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Callbacks and events

- (IBAction)onMenuButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onResetButton:(id)sender {
    // ask for confirmation
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset all scores"
                                                    message:@"Do you really want to erase existing scores?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // reset scores
        NSLog(@"Resetting scores");
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Hall of Fame";
}

@end
