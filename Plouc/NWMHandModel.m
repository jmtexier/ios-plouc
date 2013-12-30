//
//  NWMHandModel.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 30/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMHandModel.h"

@interface NWMHandModel ()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation NWMHandModel

-(id)init
{
    if (self = [super init]) {
        self.cards = [@[] mutableCopy];
    }
    return self;
}

- (int)count
{
    return [self.cards count];
}

- (void)addCard:(NWMCardModel *)card
{
    [self.cards addObject:card];
}

- (NWMCardModel *)getCardAtIndex:(NSUInteger)index
{
    return self.cards[index];
}

- (void)removeCardAtIndex:(NSUInteger)index
{
    [self.cards removeObjectAtIndex:index];
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

@end
