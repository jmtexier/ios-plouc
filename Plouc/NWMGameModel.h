//
//  NWMGameModel.h
//  Plouc
//
//  Created by Jean-Michel TEXIER on 31/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWMPileModel.h"
#import "NWMPlayerModel.h"

@protocol NWMGameDelegate

-(void)onGameOver;

-(void)onGameNextTurn;

-(void)onGameCardPlayed:(NWMCardModel *)card;

@end

@interface NWMGameModel : NSObject

@property (weak) NSObject<NWMGameDelegate> *delegate;

@property (readonly) NSInteger computerScore;
@property (readonly) NSInteger playerScore;
@property (readonly) NSUInteger round;
@property (readonly) NWMPileModel *pile;
@property (readonly) NWMCardModel *currentCard;
@property (readonly) NWMPlayerModel *computer;
@property (readonly) NWMPlayerModel *player;
@property (readonly) NWMPlayerModel *currentPlayer;
@property NSUInteger cardsToDrawIfNoAcePlayed;

- (void)reset:(BOOL)playerStarts;

- (void)drawCard;
- (NSUInteger)computeCardToPlay;
- (void)playCard:(NSUInteger)index;
- (void)nextTurn;
- (void)playAsComputer;
- (BOOL)canPlay:(NWMCardModel *)card;

@property (readonly) BOOL computersTurn;
@property (readonly) BOOL playersTurn;
@property (readonly) BOOL gameIsOver;
@property (readonly) BOOL playerWon;

- (void)nextRound;

@end
