//
//  NWMCardModel.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 30/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMCardModel.h"

@implementation NWMCardModel

static CGImageRef _deck;

+ (CGImageRef)deck
{
    if (!_deck) {
        _deck = [UIImage imageNamed:@"Card-Deck.png"].CGImage;
    }
    return _deck;
}

+(UIImage *)getBackImage
{
    // back card is the first card after all 4 colors
    return [NWMCardModel getImageFromColor:4 andValue:1];
}

+(UIImage *)getJokerImage
{
    // joker card is the second card after all 4 colors
    return [NWMCardModel getImageFromColor:4 andValue:2];
}

+ (UIImage *)getImageFromColor:(NSUInteger)color andValue:(NSUInteger)value
{
    // extract card from deck image (see 'Card-Deck.png' resource)
    // card dimensions are 110x146px with a transparent border of 2px
    int offset = color * 13 + value - 1;
    int x = 2 + 112*(offset % 9);
    int y = 2 + 148*(offset / 9);
    
    CGImageRef partOfDeck = CGImageCreateWithImageInRect(NWMCardModel.deck, CGRectMake(x, y, 110, 146));
    UIImage *image = [UIImage imageWithCGImage:partOfDeck];
    CGImageRelease(partOfDeck);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(55, 72), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, 55, 72)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (id)initWithColor:(NSUInteger)color andValue:(NSUInteger)value
{
    if (self = [self init]) {
        _color = color;
        _value = value;
    }
    return self;
}

- (BOOL)isAttack
{
    switch (self.value) {
        case Ace:
        case Two:
        case Six:
        case Seven:
            return YES;
            
        default:
            return NO;
    }
}

- (BOOL)isChainable
{
    switch (self.value) {
        case Two:
        case Six:
        case Seven:
            return YES;
            
        default:
            return NO;
    }
}

- (BOOL) canBeStackedOn:(NWMCardModel *)card
{
    // check if current card can be stacked on another card
    return (self.value == Eight || self.color == card.color || self.value == card.value);
}

- (NSUInteger) attackCost
{
    switch (self.value) {
        case Ace:
            return 3;
        case Two:
            return 2;
        case Six:
            return 1;
        case Seven:
            return 0;

        default:
            return 0;
    }
}

- (UIImage *)getImage
{
    return [NWMCardModel getImageFromColor:self.color andValue:self.value];
}

@end
