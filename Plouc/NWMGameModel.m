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
@property BOOL canPlayOnAce;

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
        _canPlayOnAce = NO;
        _cardsToDrawIfNoAcePlayed = 0;
        _playerScore = 0;
        _computerScore = 0;
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
    
    // debug
    NSLog(@"----------------------------------------");
    for(NWMCardModel *card in _computer.hand) {
        NSLog(@"Computer card: %@", card.description);
    }
    NSLog(@"----------------------------------------");
    for(NWMCardModel *card in _player.hand) {
        NSLog(@"Player card: %@", card.description);
    }
    NSLog(@"----------------------------------------");

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
    
    if (self.playersTurn) {
        // computer can always play on Ace if player draw a card
        _canPlayOnAce = YES;

        // update number of cards player has to draw on Ace
        if (_cardsToDrawIfNoAcePlayed > 0) {
            _cardsToDrawIfNoAcePlayed--;
            NSLog(@"Player has to play an Ace or draw up to %lu cards", _cardsToDrawIfNoAcePlayed);
        }
    }
}

-(BOOL)canPlay:(NWMCardModel *)card
{
    // has computer played an Ace?
    if (_cardsToDrawIfNoAcePlayed > 0) {
        NSLog(@"Player has to play an Ace or draw up to %lu cards", _cardsToDrawIfNoAcePlayed);
        return (card.value == Ace);
    }
    
    return [card canBeStackedOn:self.currentCard];
}

-(void)playCard:(NSUInteger)index
{
    // get card to play
    NWMCardModel *card = [_currentPlayer getCardAtIndex:index];

    // add card on top of pile
    [_pile playCard:card];
    
    // remove card from player's hand
    [_currentPlayer removeCardAtIndex:index];

    if (self.computersTurn) {
        // when computer plays an Ace, player will have to play an Ace or draw up to 3 cards
        if (card.value == Ace) {
            NSLog(@"Player has to play an Ace or draw up to 3 cards");
            _cardsToDrawIfNoAcePlayed = 3;
        }
        // when computer plays an Eight, it has to choose the best color for it...
        if (card.value == Eight) {
            NSUInteger color = [self findBestColorToPlayWith:card];
            NSLog(@"Computer played 8 and choose %@", [NWMCardModel ColorName:color]);
            [_pile playCard:[[NWMCardModel alloc] initWithColor:Special andValue:(Special_Eights + color)]];
        }
    } else {
        // if player played an Ace make sure the he(she) has no more cards to draw
        if (card.value == Ace) {
            _cardsToDrawIfNoAcePlayed = 0;
        }
    }
    
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
        // if player has played an Eight, wait for 'nextTurn'
        if (card.value != Eight || self.computersTurn)
        {
            // move to next player
            [self nextTurn:NO];
        }
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
        _computerScore += score;
    
    NSLog(@"----------------------------------------");
    NSLog(@"Game over. Player %lu - Computer %lu", _playerScore, _computerScore);
    NSLog(@"----------------------------------------");
    NSLog(@"");
    
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
    
    NSLog(@"Next round. Starting round #%lu", _round);
    NSLog(@"----------------------------------------");
    NSLog(@" ");

    // notify new turn
    [self.delegate onGameNextTurn];
}

#pragma mark - Computer (very) Articial Intelligence :-O

- (void)playAsComputer
{
    NSUInteger index = NSUIntegerMax;
    
    // on an Ace, computer has to play an Ace or draw up to 3 cards
    NSLog(@"Computer has to play on %@", _pile.currentCard.description);
    // however, let's make sure it's not its own Ace is has to play on
    if (_pile.currentCard.value == Ace && !_canPlayOnAce) {
        NSUInteger attempt = 0;
        while (attempt < 3) {
            index = [self findAceInCurrentHand];
            if (index < NSUIntegerMax)
                break;
            
            // draw a new card and retry
            NSLog(@"... Computer has no Ace");
            [self drawCard];
            attempt++;
        }
    } else {
        // compute best card to play based on AI level
        index = [self computeCardToPlay];
    }

    // was computer able to play or did it draw a card?
    if (index == NSUIntegerMax) {
        [self nextTurn:NO];
    } else {
        // retrieve the card to play by the computer
        NWMCardModel *cardPlayed = [_computer getCardAtIndex:index];
        NSLog(@"> Computer is playing %@", cardPlayed.description);
        _canPlayOnAce = NO;
        [self playCard:index];
    }
}

- (NSUInteger)findAceInCurrentHand
{
    NSUInteger index = 0;
    for (NWMCardModel *card in _currentPlayer.hand) {
        if (card.value == Ace) return index;
        index++;
    }

    return NSUIntegerMax;
}

- (NSUInteger)computeCardToPlay
{
    NSUInteger index = [self findBestCardToPlay];
    if (index == NSUIntegerMax) {
        // cannot play... draw a card and retry
        NSLog(@"> Computer draw a card with hand:");
        for(NWMCardModel *card in _currentPlayer.hand) {
            NSLog(@"   - %@", card.description);
        }
        [self drawCard];
        index = [self findBestCardToPlay];
    }

    return index;
}

- (NSUInteger)findBestCardToPlay
{
    // find the best card to play for current player....
    // dumb algorithm: select strongest attack first, then same color (Ace first), then same value, then an Eight
    NSUInteger topScore = 0;
    NSUInteger topIndex = NSUIntegerMax;
    NSUInteger index = 0;

    NSLog(@"> Computer searching for best card to play...");
    for(NWMCardModel *card in _currentPlayer.hand) {
        NSLog(@"    #%lu %@", index, card.description);
        if ([card canBeStackedOn:self.pile.currentCard]) {
            NSUInteger cardScore = [self computeCardScore:card];
            if (cardScore > topScore) {
                NSLog(@"    --> Electing %@ with score %lu", card.description, cardScore);
                topScore = cardScore;
                topIndex = index;
            }
        }
        index++;
    }
    if (topIndex == NSUIntegerMax)
        NSLog(@"  - Computer has to pass");
    else
        NSLog(@"  - Computer choose card #%lu", topIndex);

    return topIndex;
}

- (NSUInteger)findBestColorToPlayWith:(NWMCardModel *)card
{
    /**
     * when computer has played an Eight, it has to find the best color to choose
     * - either choose most represented color in computer's hand
     *   or choose color with most powerfull attacks
     */
    NSUInteger colorScores[4];
    for (NSUInteger i=0; i<4; i++) {
        colorScores[i] = 0;
    }
    NSUInteger topScore = 0;
    NSUInteger topColor = 0;
    
    NSLog(@"> Computer searching for best color to play...");
    for(NWMCardModel *otherCard in _currentPlayer.hand) {
        // ignore current card
        if (otherCard.value != 8 || otherCard.color != card.color) {
            NSLog(@"    - %@", otherCard.description);
            NSInteger score = (NSInteger)colorScores[otherCard.color];
            score = score + 1 + otherCard.attackStrength;
            colorScores[otherCard.color] = score;
            if (score > topScore) {
                NSLog(@"    --> Electing %@", [NWMCardModel ColorName:otherCard.color]);
                topColor = otherCard.color;
                topScore = score;
            }
        }
    }
    NSLog(@"> Computer choose %@", [NWMCardModel ColorName:topColor]);
    
    // return most frequent color in hand
    return topColor;
}

- (NSUInteger)computeCardScore:(NWMCardModel *) card
{
    /**
     * initial score is as follow:
     * - Two    => 30
     * - Six    => 20
     * - Seven  => 10
     * - Ace    => 6    // ace have some drawback as player can counter
     * - *      => 4
     * - Eight  => 1    // keep your Eight for last resort
     */
    NSUInteger score = 4;
    if (card.isAttack)
        score = ((card.attackStrength + 1) * 10);
    else if (card.value == Ace)
        score = 6;
    else if (card.value == Eight)
        score = 1;
    
    /**
     * be smarter...
     *
     * - 2 Aces are extremely valuable
     * - An Eight with at least 2 attacks in another color is more valuable
     * - An Eight with at least 1 attack in anoter color and player with few cards is also valuable
     */
    if (card.value == Ace) {
        for(NWMCardModel *otherCard in _currentPlayer.hand) {
            // check for other Aces
            if (otherCard.value == Ace && otherCard.color != card.color)
                score = 15;
        }
    } else if (card.value == Eight) {
        NSUInteger colorScores[4];
        for (NSUInteger i=0; i<4; i++) {
            colorScores[i] = 0;
        }
        NSUInteger topScore = 0;
        NSUInteger topColor = _pile.currentCard.color;
        for(NWMCardModel *otherCard in _currentPlayer.hand) {
            // ignore current card
            if (otherCard.value != Eight || otherCard.color != card.color) {
                NSUInteger colorScore = (NSUInteger)colorScores[otherCard.color];
                colorScore = colorScore + 1 + otherCard.attackStrength;
                colorScores[otherCard.color] = colorScore;
                if (colorScore > topScore) {
                    topScore = colorScore;
                    topColor = otherCard.color;
                }
            }
        }

        // opponent has only 1 or 2cards, let's select where we can hit him(her)!
        if (_player.cardCount < 3 && topScore > 1) {
            topScore += 5;
        }
        
        // do not select Eight if top color is already current color
        if (topColor != _pile.currentCard.color) {
            score += topScore;
        }
    }
    
    /**
     * be even more smart...
     *
     * - Find a long sequence of attacks (chain of attacks) to get rid of a maximum of cards in one turn
     * - Last Ace of pile is always valuable (Aces have been counted and memorized by computer)
     * - An Eight is extremely valuable if Player has one card and we know he(she) has not a specific color
     *   either statistically or because he(she) draw a card for a specific color in the last turns (Cards
     *   have been counted and last player's moves memorized by computer)
     *
     *   //TODO
     */
    
    return score;
}

@end