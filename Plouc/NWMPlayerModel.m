//
//  NWMPlayerModel.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 30/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMPlayerModel.h"

@implementation NWMPlayerModel

-(id)init
{
    if (self = [super init]) {
        _hand = [@[] mutableCopy];
    }
    return self;
}

- (int)cardCount
{
    return [_hand count];
}

- (void)addCard:(NWMCardModel *)card
{
    // add card at first place so player can see the addition
    [_hand insertObject:card atIndex:0];
}

- (void)removeCardAtIndex:(NSUInteger)index
{
    [_hand removeObjectAtIndex:index];
}

- (void)swapCardAtIndex:(NSUInteger)from withCardAtIndex:(NSUInteger)to {
    [_hand exchangeObjectAtIndex:from withObjectAtIndex:to];
}

- (NWMCardModel *)getCardAtIndex:(NSUInteger)index
{
    return _hand[index];
}

- (void)sortHand
{
    [_hand sortUsingComparator:^(NWMCardModel *obj1, NWMCardModel *obj2) {
        // sort by color
        if ( obj1.color < obj2.color ) {
            return NSOrderedAscending;
        } else if ( obj1.color > obj2.color ) {
            return NSOrderedDescending;
        } else {
            // and then, sort by value
            if (obj1.value < obj2.value) {
                return NSOrderedAscending;
            } else if (obj1.value > obj2.value) {
                return NSOrderedDescending;
            } else
                return NSOrderedSame;
        }
    }];
}

@end
