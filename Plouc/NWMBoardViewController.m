//
//  NWMBoardViewController.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 29/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMBoardViewController.h"
#import "NWMGameModel.h"
#import "NWMPileModel.h"
#import "NWMPlayerModel.h"
#import "NWMCardModel.h"

@interface NWMBoardViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *playerCollection;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;

@property (weak, nonatomic) IBOutlet UIImageView *computerCard;
@property (weak, nonatomic) IBOutlet UILabel *computerLabel;

@property (weak, nonatomic) IBOutlet UIButton *pileButton;
@property (weak, nonatomic) IBOutlet UIImageView *pileCardImage;
@property (weak, nonatomic) IBOutlet UILabel *pileLabel;

@end

@implementation NWMBoardViewController

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

    // set computer's back card
    self.computerCard.image = [NWMCardModel getJokerImage];
    [self updateHandCountLabel:self.computerLabel withCount:self.game.computer.cardCount];
    
    // set pile's back card and draw first card
    [self.pileButton setImage:[NWMCardModel getBackImage] forState:UIControlStateNormal];
    [self.pileCardImage setImage:[self.game.pile.currentCard getImage]];

    // initialize player's collection view
    [self.playerCollection setUserInteractionEnabled:YES];
    self.playerCollection.allowsSelection = YES;
    [self updateHandCountLabel:self.playerLabel withCount:self.game.player.cardCount];

    // implement swipe gesture to allow player to play one of his(her) cards
    UISwipeGestureRecognizer *swipeCell = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(onCellSwipped:)];
    [swipeCell setDirection:UISwipeGestureRecognizerDirectionUp];
    swipeCell.numberOfTouchesRequired = 1;
    [self.playerCollection addGestureRecognizer:swipeCell];
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
    [self playCard:indexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)pileButton:(id)sender {
    [self drawCard];
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

#pragma mark - Game logic

- (void)playCard:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.item;
    NWMCardModel *card = [self.game.player getCardAtIndex:index];
    if ([card canBeStackedOn:self.game.currentCard]) {
        // play card
        [self.game playCard:index];
        self.pileCardImage.image = [self.game.currentCard getImage];
        
        // redraw player's hand (after 'playCard' turn has changed, so we check if it's computer's turn)
        if (self.game.currentPlayer == self.game.computer) {
            [self.playerCollection deleteItemsAtIndexPaths:@[indexPath]];
            [self updateHandCountLabel:self.playerLabel withCount:self.game.player.cardCount];
        } else {
            // computer has played
            [self updateHandCountLabel:self.computerLabel withCount:self.game.computer.cardCount];
        }
    } else {
        // display sound or do something...
    }
}

- (void)drawCard
{
    // draw card and skip turn
    [self.game drawCard];

    // redraw
    if (self.game.currentPlayer == self.game.computer) {
        [self updateHandCountLabel:self.computerLabel withCount:self.game.computer.cardCount];
    } else {
        [self.playerCollection reloadData];
        [self updateHandCountLabel:self.playerLabel withCount:self.game.player.cardCount];
    }

    // skip turn
    [self.game skipTurn];
}

#pragma mark - UICollectionViewDataSource implementation

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.game.player.cardCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell for item index %d requested", indexPath.item);

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
