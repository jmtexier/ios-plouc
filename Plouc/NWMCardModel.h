//
//  NWMCardModel.h
//  Plouc
//
//  Created by Jean-Michel TEXIER on 30/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWMCardModel : NSObject

+(UIImage *)getBackImage;
+(UIImage *)getJokerImage;

typedef NS_ENUM(NSUInteger, CardColor) {
    Hearts = 0,
    Diamonds = 1,
    Spades = 2,
    Clubs = 3
};

typedef NS_ENUM(NSUInteger, CardValue) {
    Ace = 1,
    Two = 2,
    Three = 3,
    Four = 4,
    Five = 5,
    Six = 6,
    Seven = 7,
    Eight = 8,
    Nine = 9,
    Ten = 10,
    Knave = 11,
    Queen = 12,
    King = 13
};

- (id)initWithColor:(NSUInteger)color andValue:(NSUInteger)value;

@property (readonly) CardColor color;
@property (readonly) CardValue value;

- (UIImage *)getImage;

@property (readonly) BOOL isAttack;
@property (readonly) BOOL isChainable;
@property (readonly) NSUInteger attackCost;

- (BOOL)canBeStackedOn:(NWMCardModel *)card;

@end
