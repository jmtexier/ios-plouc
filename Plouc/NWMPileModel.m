//
//  NWMPileModel.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 30/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMPileModel.h"
#import "NWMCardModel.h"

@interface NWMPileModel ()

@property (strong, nonatomic) NSMutableArray *stack;

@end

@implementation NWMPileModel

- (id)init
{
    // initialize pile with all cards
    if (self = [super init]) {
        self.stack = [@[] mutableCopy];
        for (NSUInteger color = Hearts; color <=Clubs; ++color) {
            for (NSUInteger value = Ace; value <= King; ++value) {
                [self.stack addObject:[[NWMCardModel alloc] initWithColor:color andValue:value]];
            }
        }
    }
    // shuffle once
    [self shuffle];
    
    return self;
}

- (int)count
{
    return [self.stack count];
}

- (NWMCardModel *)drawCard
{
    NWMCardModel *card = self.stack.lastObject;
    [self.stack removeLastObject];

    return card;
}

- (void)shuffle
{
    NSUInteger count = self.count;
    for (NSUInteger index = 0; index < count; ++index) {
        // select a random element between i and end of array to swap with
        NSInteger randomSize = count - index;
        NSInteger substitute = arc4random_uniform(randomSize) + index;
        [self.stack exchangeObjectAtIndex:index withObjectAtIndex:substitute];
    }
}

@end
