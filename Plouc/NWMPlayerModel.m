//
//  NWMPlayerModel.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 30/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMPlayerModel.h"

@interface NWMPlayerModel ()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation NWMPlayerModel

-(id)init
{
    if (self = [super init]) {
        self.cards = [@[] mutableCopy];
    }
    return self;
}

- (int)cardCount
{
    return [self.cards count];
}

- (void)addCard:(NWMCardModel *)card
{
    [self.cards addObject:card];
}

- (void)removeCardAtIndex:(NSUInteger)index
{
    [self.cards removeObjectAtIndex:index];
}

- (void)swapCardAtIndex:(NSUInteger)from withCardAtIndex:(NSUInteger)to {
    [self.cards exchangeObjectAtIndex:from withObjectAtIndex:to];
}

- (NWMCardModel *)getCardAtIndex:(NSUInteger)index
{
    return self.cards[index];
}

- (void)sort
{
    [self.cards sortUsingComparator:^(NWMCardModel *obj1, NWMCardModel *obj2) {
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

- (BOOL)canPlayOnCard:(NWMCardModel *)topCard
{
    // play can play if at least one of his(her) card can be stacked on the top card
    for(NWMCardModel *card in _cards) {
        if ([card canBeStackedOn:topCard])
            return YES;
    }

    return NO;
}

@end
