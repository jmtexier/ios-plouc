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

@interface NWMGameModel : NSObject

@property (readonly) NSUInteger round;

@property (readonly) NWMPileModel *pile;
@property (readonly) NWMCardModel *currentCard;
@property (readonly) NWMPlayerModel *computer;
@property (readonly) NWMPlayerModel *player;
@property (readonly) NWMPlayerModel *currentPlayer;

- (void)reset:(BOOL)playerStarts;

- (BOOL)canPlay;
- (NWMCardModel *)drawCard;
- (void)playCard:(NSUInteger)index;
- (void)skipTurn;

- (BOOL)gameIsOver;

- (void)nextRound;

@end
