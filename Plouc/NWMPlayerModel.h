//
//  NWMPlayerModel.h
//  Plouc
//
//  Created by Jean-Michel TEXIER on 30/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWMCardModel.h"

@interface NWMPlayerModel : NSObject

@property (readonly) int cardCount;

- (void)addCard:(NWMCardModel *)card;
- (void)removeCardAtIndex:(NSUInteger)index;
- (void)swapCardAtIndex:(NSUInteger)from withCardAtIndex:(NSUInteger)to;
- (NWMCardModel *)getCardAtIndex:(NSUInteger)index;

- (void)sort;

- (BOOL)canPlayOnCard:(NWMCardModel *)topCard;

@end
