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
        [self.player addCard:[self.pile drawCard]];
        [self.computer addCard:[self.pile drawCard]];
    }
    
    // set the top card to play on
    [self.pile playCard:[self.pile drawCard]];

    // determine first player
    _currentPlayer = (playerStarts) ? _player : _computer;
}

- (NWMCardModel *)currentCard
{
    // helper to access directly to the pile's current card
    return _pile.currentCard;
}

- (BOOL)canPlay
{
    return [_currentPlayer canPlayOnCard:self.pile.currentCard];
}

- (NWMCardModel *)drawCard
{
    NWMCardModel *card = [self.pile drawCard];
    if (card == nil) {
        // reset pile
        _pile = [[NWMPileModel alloc] init];
    }
    [_currentPlayer addCard:card];
    
    return card;
}

- (void)playCard:(NSUInteger)index
{
    // add card to pile
    [self.pile playCard:[self.currentPlayer getCardAtIndex:index]];
    
    // remove card from player's hand and move to next player
    [self.currentPlayer removeCardAtIndex:index];
    [self skipTurn];
}

- (void)skipTurn
{
    // move to next player
    _currentPlayer = [_currentPlayer isEqual:_player] ? _computer : _player;
}

- (BOOL)gameIsOver
{
    // game is over when one player has play all his(her) cards
    return (_player.cardCount == 0 || _computer.cardCount == 0);
}

- (void)nextRound
{
    // reset game and increment round counter
    NSUInteger round = _round;
    [self reset:!_playerHasStarted];
    _round = ++round;
}

@end