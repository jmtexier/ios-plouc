//
//  NWMBoardViewController.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 29/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMBoardViewController.h"
#import "NWMPileModel.h"
#import "NWMHandModel.h"
#import "NWMCardModel.h"

@interface NWMBoardViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *playerCollection;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;

@property (weak, nonatomic) IBOutlet UILabel *computerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *computerCard;

@property (weak, nonatomic) IBOutlet UIButton *pileButton;
@property (weak, nonatomic) IBOutlet UILabel *pileLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pileCardImage;


@property NWMPileModel *pile;
@property NWMHandModel *playerHand;
@property NWMHandModel *computerHand;
@property NWMCardModel *currentCard;

@end

@implementation NWMBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // create a new pile of cards
        self.pile = [[NWMPileModel alloc] init];

        // deal 5 cards to player and computer
        self.playerHand = [[NWMHandModel alloc] init];
        self.computerHand = [[NWMHandModel alloc] init];
        for (NSUInteger index = 0; index < 7; ++index) {
            [self.playerHand addCard:[self.pile drawCard]];
            [self.computerHand addCard:[self.pile drawCard]];
        }
        [self.playerHand sort];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set computer's back card
    self.computerCard.image = [NWMCardModel getJokerImage];
    [self updateCardsLabel:self.computerLabel withCount:self.computerHand.count];
    
    // set pile's back card and draw first card
    [self.pileButton setImage:[NWMCardModel getBackImage] forState:UIControlStateNormal];
    [self drawCard];

    // initialize player's collection view
    [self.playerCollection setUserInteractionEnabled:YES];
    self.playerCollection.allowsSelection = YES;
    [self updateCardsLabel:self.playerLabel withCount:self.playerHand.count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)pileButton:(id)sender {
    [self drawCard];
}

- (void)drawCard
{
    NSUInteger count = self.pile.count;
    if (count > 0) {
        self.currentCard = [self.pile drawCard];
        self.pileCardImage.image = [self.currentCard getImage];
        count--;
        if (count == 0) {
            self.pileButton.enabled = NO;
        }
       [self updateCardsLabel:self.pileLabel withCount:count];
    }
}

- (void)updateCardsLabel:(UILabel *)label withCount:(NSUInteger)count
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

#pragma mark - UICollectionViewDataSource implementation

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"Hand count requested");
    
    return self.playerHand.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell for item index %d requested", indexPath.item);

    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"card" ];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"card" forIndexPath:indexPath];
    UIImage *image = [[self.playerHand getCardAtIndex:indexPath.item] getImage];
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

    NWMCardModel *card = [self.playerHand getCardAtIndex:index];

    if ([card canBeStackedOn:self.currentCard]) {
        // drop card on pile
        [self.playerHand removeCardAtIndex:index];
        self.currentCard = card;
        
        // redraw
        self.pileCardImage.image = [self.currentCard getImage];
        [self.playerCollection deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
        [self updateCardsLabel:self.playerLabel withCount:self.playerHand.count];
    }
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
