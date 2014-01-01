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

@property NSMutableArray *stack;

@end

@implementation NWMPileModel

- (id)init
{
    self = [super init];
    if (self) {
        [self reset];
    }

    return self;
}

- (void)reset
{
    [self resetWithoutCards:nil andWithCurrentCard:nil];
}

- (void)resetWithoutCards:(NSMutableArray *)cards andWithCurrentCard:(NWMCardModel *)current
{
    // initialize pile with all possible cards
    NSLog(@"Resetting pile...");
    self.stack = [@[] mutableCopy];
    for (NSUInteger color = Hearts; color <=Clubs; ++color) {
        for (NSUInteger value = Ace; value <= King; ++value) {
            NWMCardModel *card = [[NWMCardModel alloc] initWithColor:color andValue:value];
            if (cards == nil || [cards indexOfObject:card.uniqueId] == NSNotFound) {
                [self.stack addObject:card];
            }
        }
    }

    NSLog(@"Pile size is %d", [self.stack count]);

    // shuffle once
    [self shuffle];
    
    // do not draw card at the very beginning
    _currentCard = current;
}

- (int)cardCount
{
    return [self.stack count];
}

- (NWMCardModel *)drawCard
{
    NWMCardModel *card = self.stack.lastObject;
    [self.stack removeLastObject];

    return card;
}

- (void)playCard:(NWMCardModel *)card
{
    _currentCard = card;
}

- (void)shuffle
{
    NSLog(@"Shuffing pile cards...");
    NSUInteger count = self.cardCount;
    for (NSUInteger index = 0; index < count; ++index) {
        // select a random element between i and end of array to swap with
        NSInteger randomSize = count - index;
        NSInteger substitute = arc4random_uniform(randomSize) + index;
        [self.stack exchangeObjectAtIndex:index withObjectAtIndex:substitute];
    }
}

@end
