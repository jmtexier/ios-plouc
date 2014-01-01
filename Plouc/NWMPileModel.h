//
//  NWMPileModel.h
//  Plouc
//
//  Created by Jean-Michel TEXIER on 30/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWMCardModel.h"

@interface NWMPileModel : NSObject

@property (readonly) int cardCount;
@property (readonly) NWMCardModel *currentCard;

- (NWMCardModel *)drawCard;

- (void)playCard:(NWMCardModel *)card;

- (void)shuffle;

- (void)reset;

- (void)resetWithoutCards:(NSMutableArray *)cardsToRemove andWithCurrentCard:(NWMCardModel *)current;

@end
