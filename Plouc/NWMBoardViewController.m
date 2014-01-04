//
//  NWMBoardViewController.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 29/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMBoardViewController.h"
#import "NWMModalEightView.h"
#import "NWMUIToolkit.h"

#import "NWMGameModel.h"
#import "NWMPileModel.h"
#import "NWMPlayerModel.h"
#import "NWMCardModel.h"

@interface NWMBoardViewController ()  <UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate,
                                       NWMGameDelegate, NWMModalEightDelegate>

@property (readonly) NWMGameModel *game;

@property (weak, nonatomic) IBOutlet UIButton *giveUpButton;

@property (weak, nonatomic) IBOutlet UICollectionView *playerCollection;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UIButton *skipTurnButton;

@property (weak, nonatomic) IBOutlet UIImageView *computerCard;
@property (weak, nonatomic) IBOutlet UILabel *computerLabel;

@property (weak, nonatomic) IBOutlet UIButton *pileButton;
@property (weak, nonatomic) IBOutlet UILabel *pileLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pileCardImage;
@property (weak, nonatomic) IBOutlet UIImageView *penultimateCardImage;
@property (weak, nonatomic) IBOutlet UIImageView *antepenultimateCardImage;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundLabel;

@property (strong, nonatomic) IBOutlet NWMModalEightView *pick8View;

@end

@implementation NWMBoardViewController

#pragma mark - ViewController methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _game = [[NWMGameModel alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // enable game delegation
    _game.delegate = self;

    // set computer's back card
    [self.computerCard setImage:[NWMCardModel getBackImage]];

    //round buttons
    [NWMUIToolkit roundButtons:@[self.pileButton, self.skipTurnButton, self.giveUpButton]];

    // set pile's back images
    [self.pileButton setImage:[NWMCardModel getBackImage] forState:UIControlStateNormal];
    [self.view sendSubviewToBack:self.penultimateCardImage];
    [self.penultimateCardImage setImage:[NWMCardModel getWhiteImage]];
    [self.view sendSubviewToBack:self.antepenultimateCardImage];
    [self.antepenultimateCardImage setImage:[NWMCardModel getWhiteImage]];

    // initialize player's collection view
    [self.playerCollection setUserInteractionEnabled:YES];
    self.playerCollection.allowsSelection = YES;

    // implement swipe gesture to allow player to play one of his(her) cards
    UISwipeGestureRecognizer *swipeCell = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(onCellSwipped:)];
    [swipeCell setDirection:UISwipeGestureRecognizerDirectionUp];
    swipeCell.numberOfTouchesRequired = 1;
    [self.playerCollection addGestureRecognizer:swipeCell];
    
    // draw board
    [self drawBoard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Callbacks and events

- (IBAction)onPileTouch:(id)sender {
    // draw card from pile and allow skip
    [self.game drawCard];
    [self.skipTurnButton setTitle:@"Pass my turn" forState:UIControlStateNormal];
    self.skipTurnButton.enabled = true;
    self.skipTurnButton.alpha = 1.0;
    
    // disable pile
    self.pileButton.enabled = false;
    self.pileButton.alpha = 0.4f;

    // redraw labels and collection
    [self.playerCollection reloadData];
    [self updateHandCountLabel:self.playerLabel withCount:self.game.player.cardCount];
}

- (IBAction)onSkipTurn:(id)sender {
    if (self.game.gameIsOver) {
        // reset ante and penultimate images
        [self.antepenultimateCardImage setImage:[NWMCardModel getWhiteImage]];
        [self.penultimateCardImage setImage:[NWMCardModel getWhiteImage]];

        // if game was over, let's start another round
        [self.game nextRound];
        self.roundLabel.text = [[NSString alloc] initWithFormat:@"Round #%d", self.game.round];
    } else {
        // otherwise, player will skip his(her) turn
        [self.game nextTurn];
    }
}

- (IBAction)onGiveUp:(id)sender {
    // ask for confirmation
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Give Up!"
                                                    message:@"Hey loser, you really wanna quit?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // back to menu
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)updateHandCountLabel:(UILabel *)label withCount:(NSUInteger)count
{
    switch (count) {
        case 0:
            label.text = @"(empty)";
            break;
            
        case 1:
            label.text = @"(last one!)";
            break;
            
        case 2:
            label.text = @"(two left!)";
            break;
            
        default:
            label.text =[[NSString alloc] initWithFormat:@"(%d cards)", count];
    }
}

- (void)onCellSwipped:(UISwipeGestureRecognizer *)gestureRecognizer {
    // ensure gesture is done
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    // ensure swipe is done on a cell
    CGPoint p = [gestureRecognizer locationInView:self.playerCollection];
    NSIndexPath *indexPath = [self.playerCollection indexPathForItemAtPoint:p];
    if (indexPath == nil)
        return;
    
    // play card corresponding to cell (if possible)
    NSUInteger index = indexPath.item;
    NWMCardModel *card = [self.game.player getCardAtIndex:index];
    if ([card canBeStackedOn:self.game.currentCard]) {
        // play card
        [self.game playCard:index];
    } else {
        // send a sound or do something...
    }
}

#pragma mark - NWMGameDelegate implementation


-(void)onGameCardPlayed:(NWMCardModel *)card;
{
    NSLog(@"Card played: %@", card.description);
    // move penultimate card image to antepenultimate position
    [self.antepenultimateCardImage setImage:[self.penultimateCardImage.image copy]];

    // move current card image to penultimate position
    [self.penultimateCardImage setImage:[self.pileCardImage.image copy]];

    // set played image on top of pile
    [self.pileCardImage setImage:[card getImage]];
    
    // check is player has played an Eight
    if (card.value == Eight && self.game.playersTurn) {
        // display color selector except if it is the last card
        if (self.game.player.cardCount == 0) {
            [self.game nextTurn];
        } else {
            self.pick8View = [[NWMModalEightView alloc] initWithFrame:self.view.bounds];
            self.pick8View.delegate = self;
            [self.view addSubview:self.pick8View];
        }
    }
}

-(void)onGameNextTurn
{
    // play for computer?
    if (self.game.computersTurn) {
        // simulate some thinking there ...
        [self.game playAsComputer];
        return;
    }
    [self drawBoard];
}

-(void)onColorSelected:(NSUInteger)color
{
    NSLog(@"User has selected color %d", color);
    // user has selected its color
    self.pick8View = nil;
    
    //change pile current color and redraw
    [self.game.pile playCard:[[NWMCardModel alloc] initWithColor:Special andValue:(Special_Eights + color)]];
    self.pileCardImage.image = [self.game.currentCard getImage];
    
    // explicitely invoke next turn
    [self.game nextTurn];
}

-(void)drawBoard
{
    // is this to the player or to the computer to play?
    BOOL playerOK = self.game.playersTurn;

    CGFloat alphaOK = (playerOK) ? 1.0 : 0.4;
    CGFloat alphaKO = (playerOK) ? 0.4 : 1.0;
    NSString *label = (playerOK) ? @"Play or Draw" : @"AI is thinking...";
    
    self.pileButton.enabled = playerOK;
    self.pileButton.alpha = alphaOK;
    
    self.playerCollection.userInteractionEnabled = playerOK;
    self.playerCollection.alpha = alphaOK;
    
    self.skipTurnButton.enabled = !playerOK;
    self.skipTurnButton.alpha = alphaKO;
    [self.skipTurnButton setTitle:label forState:UIControlStateNormal];

    // redraw and update labels as some attack may have been played
    self.pileCardImage.image = [self.game.currentCard getImage];
    [self updateHandCountLabel:self.pileLabel withCount:self.game.pile.cardCount];
    [self.playerCollection reloadData];
    [self updateHandCountLabel:self.playerLabel withCount:self.game.player.cardCount];
    [self updateHandCountLabel:self.computerLabel withCount:self.game.computer.cardCount];
}

- (void)onGameOver
{
    // draw board
    [self drawBoard];

    // set final message
    NSString *label = (self.game.playerWon) ? @"You Win! :)" : @"Loser!! :(";
    self.skipTurnButton.enabled = true;
    self.skipTurnButton.alpha = 1.0;
    [self.skipTurnButton setTitle:label forState:UIControlStateNormal];
    
    // update player's score label
    self.scoreLabel.text = [[NSString alloc] initWithFormat:@"Score: %d", self.game.playerScore];
}

#pragma mark - UICollectionViewDataSource implementation

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.game.player.cardCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"card" ];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"card" forIndexPath:indexPath];

    UIImage *image = [[self.game.player getCardAtIndex:indexPath.item] getImage];
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    
    view.frame = CGRectMake(0, 0, 55, 73);
    view.contentMode = UIViewContentModeScaleAspectFit;

    [cell.contentView addSubview:view];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate implementation

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.item;
    NSLog(@"Card %d selected", index);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Card has been de-selected at index %d", indexPath.item);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // should we display a menu for this cell?
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView
         performAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender
{
    NSLog(@"User has selected an action in the menu at index %d", indexPath.item);
}

@end
