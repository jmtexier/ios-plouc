//
//  NWMGameModel.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 31/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMGameModel.h"

@interface NWMGameModel ()

@property BOOL playerHasStarted;

@end


@implementation NWMGameModel

- (id)init
{
    return [self init:YES];
}

- (id)init:(BOOL)playerStarts
{
    self = [super init];
    if (self) {
        [self reset:playerStarts];
        _playerScore = 0;
        _round = 1;
    }
    return self;
}

- (void)reset:(BOOL)playerStarts
{
    // initialize pile and players
    _pile = [[NWMPileModel alloc] init];
    _computer = [[NWMPlayerModel alloc] init];
    _player = [[NWMPlayerModel alloc] init];
    _playerHasStarted = playerStarts;
    
    // deal 5 cards to each players
    for (NSUInteger index = 0; index < 5; ++index) {
        [_player addCard:[_pile drawCard]];
        [_computer addCard:[_pile drawCard]];
    }
    
    // set the top card to play on
    [_pile playCard:[_pile drawCard]];

    // set first player
    _currentPlayer = (playerStarts) ? _player : _computer;
}

- (NWMCardModel *)currentCard
{
    // helper to access directly to the pile's current card
    return _pile.currentCard;
}

- (BOOL)playersTurn
{
    return [_currentPlayer isEqual:_player];
}

- (BOOL)computersTurn
{
    return [_currentPlayer isEqual:_computer];
}

- (NWMCardModel *)getNextCardOnPile
{
    if (_pile.cardCount == 0) {
        NSLog(@"Pile is empty! Need to re-shuffle....");
        // keep trace of all existing cards (in players hands or currently on top of the pile)
        NSMutableArray *cards = [@[] mutableCopy];
        for(NWMCardModel *card in _player.hand) {
            [cards addObject:card.uniqueId];
        }
        for(NWMCardModel *card in _computer.hand) {
            [cards addObject:card.uniqueId];
        }
        [cards addObject:_pile.currentCard.uniqueId];

        // reset pile while keeping current card and not duplicated in hand cards
        [_pile resetWithoutCards:cards andWithCurrentCard:_pile.currentCard];
    }
    
    return [_pile drawCard];
}

-(void)drawCard
{
    // add card to current player
    [_currentPlayer addCard:[self getNextCardOnPile]];
}

- (void)playCard:(NSUInteger)index
{
    // get card to play
    NWMCardModel *card = [_currentPlayer getCardAtIndex:index];

    // add card on top of pile
    [_pile playCard:card];
    
    // remove card from player's hand
    [_currentPlayer removeCardAtIndex:index];
    
    // notify delegate before putting card on the pile
    [self.delegate onGameCardPlayed:card];

    // check if card played was an attack
    if (card.isAttack) {
        // add 'attack-strength' cards to opponent
        NWMPlayerModel *opponent = (self.computersTurn) ? _player : _computer;
        NSUInteger cardsToDraw = card.attackStrength;
        while (cardsToDraw > 0) {
            [opponent addCard:[self getNextCardOnPile]];
            cardsToDraw--;
        }
        // same player, play again
        [self nextTurn:YES];
    } else {
        // move to next player
        [self nextTurn:NO];
    }
}

- (void)nextTurn
{
    [self nextTurn:NO];
}

- (void)nextTurn:(BOOL)withSamePlayer
{
    // first check if game is over
    if ([self gameIsOver]) {
        // update player's score
        [self updatePlayerScore];
        [self.delegate onGameOver];
    } else {
        // change current player?
        if (!withSamePlayer) {
            _currentPlayer = [_currentPlayer isEqual:_player] ? _computer : _player;
        }
        [self.delegate onGameNextTurn];
    }
}

- (void)updatePlayerScore
{
    // mark 1 point for a win, 2 points if opponent as more than 5 cards, 5 points if more than 10 cards
    NSUInteger cardsLeft = (self.playerWon) ? _computer.cardCount : _player.cardCount;
    NSInteger score = (cardsLeft > 10) ? 4 : ((cardsLeft > 5) ? 2 : 1);
    
    if (self.playerWon)
        _playerScore += score;
    else
        _playerScore -= score;
}

- (BOOL)gameIsOver
{
    // game is over when one player has play all his(her) cards
    return (_player.cardCount == 0 || _computer.cardCount == 0);
}

- (BOOL)playerWon
{
    // player won is he(she) has no more cards
    return (_player.cardCount == 0);
}

- (void)nextRound
{
    // reset game and increment round counter
    NSUInteger round = _round;
    [self reset:!_playerHasStarted];
    _round = ++round;
    
    // notify new turn
    [self.delegate onGameNextTurn];
}

#pragma mark - Computer (very) Articial Intelligence :-O

- (void)playAsComputer
{
    NSLog(@"Playing as computer");
    NSUInteger index = [self computeCardToPlay];
    if (index == NSUIntegerMax) {
        // computer wasn't able to play and draw a card
        NSLog(@"Computer draw a card");
        [self nextTurn:NO];
    } else {
        // retrieve the card to play by the computer
        NWMCardModel *cardPlayed = [_computer getCardAtIndex:index];
        NSLog(@"Computer is playing %@", cardPlayed.description);
        [self playCard:index];
    }
    
}

- (NSUInteger)computeCardToPlay
{
    NSUInteger index = [self findBestCardToPlay];
    if (index == NSUIntegerMax) {
        // cannot play... draw a card and retry
        [self drawCard];
        index = [self findBestCardToPlay];
    }

    return index;
}

- (NSUInteger)findBestCardToPlay
{
    // find the best card to play for current player....
    // dumb algorithm: select strongest attack first, then same color (Ace first), then same value, then an Eight
    int topScore = -1;
    NSUInteger topIndex = NSUIntegerMax;
    NSUInteger index = 0;
    NSLog(@"Finding best card to put on %@", self.pile.currentCard.description);
    for(NWMCardModel *card in _currentPlayer.hand) {
        if ([card canBeStackedOn:self.pile.currentCard]) {
            int cardScore = [self computeCardScore:card];
            if (cardScore > topScore) {
                NSLog(@"Electing card %@ with score %d", card.description, cardScore);
                topScore = cardScore;
                topIndex = index;
            }
        }
        index++;
    }
    
    return topIndex;
}

- (int)computeCardScore:(NWMCardModel *) card
{
    if (card.isAttack)
        return (card.attackStrength * 10);
    else if (card.value == Ace)
        return 5;
    else if (card.value == Eight)
        return 1;
    
    return 0;
}

@end