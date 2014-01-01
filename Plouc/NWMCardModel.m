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
        _deck = [UIImage imageNamed:@"CardDeckSprite.png"].CGImage;
    }
    return _deck;
}

+(UIImage *)getColorImage:(CardColor)color
{
    return [NWMCardModel getImageFromOffset:(54+color)];
}

+(UIImage *)getWhiteImage
{
    return [NWMCardModel getImageFromOffset:58];
}

+(UIImage *)getBackImage
{
    return [NWMCardModel getImageFromOffset:52];
}

+(UIImage *)getJokerImage
{
    return [NWMCardModel getImageFromOffset:53];
}

+ (UIImage *)getImageFromColor:(NSUInteger)color andValue:(NSUInteger)value
{
    // extract card from deck image (see 'CardDeckSprite.png' resource)
    // card dimensions are 112x148px with a transparent border of 1px
    NSUInteger offset = (color * 13 + value - 1);
    return [self getImageFromOffset:offset];
}

+ (UIImage *)getImageFromOffset:(NSUInteger)offset
{
    // extract card from deck image (see 'CardDeckSprite.png' resource)
    // card dimensions are 112x148px with a transparent border of 1px
    int x = 112*offset;
    
    CGImageRef partOfDeck = CGImageCreateWithImageInRect(NWMCardModel.deck, CGRectMake(x, 0, 112, 148));
    UIImage *image = [UIImage imageWithCGImage:partOfDeck];
    CGImageRelease(partOfDeck);
    
    // resize to half-size (56x74px)
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(56, 74), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, 56, 74)];
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
        case Two:
        case Six:
        case Seven:
            return YES;
            
        default:
            return NO;
    }
}

- (NSNumber *)uniqueId
{
    // a unique id (offset) based on color and value
    return [NSNumber numberWithInt:(self.color*13 + self.value - 1)];
}

- (BOOL) canBeStackedOn:(NWMCardModel *)card
{
    // check if current card can be stacked on another card
    return (self.value == Eight || self.color == card.color || self.value == card.value);
}

- (NSUInteger) attackStrength
{
    switch (self.value) {
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

- (NSString *)description
{
    return [NSString stringWithFormat:@"Card %u of %u", self.value, self.color];
}
@end
