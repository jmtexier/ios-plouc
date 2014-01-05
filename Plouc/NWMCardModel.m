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

+ (NSDictionary *)ColorNames
{
    return @{@(Hearts) : @"Hearts",
             @(Diamonds) : @"Diamonds",
             @(Spades) : @"Spades",
             @(Clubs) : @"Clubs",
             @(Special): @"Special" };
}
+(NSString *)ColorName:(CardColor)color
{
    return [NWMCardModel ColorNames][@(color)];
}

+ (NSDictionary *)ValueNames
{
    return @{@(Ace) : @"Ace",
             @(Two) : @"2",
             @(Three) : @"3",
             @(Four) : @"4",
             @(Five) : @"5",
             @(Six) : @"6",
             @(Seven) : @"7",
             @(Eight) : @"8",
             @(Nine) : @"9",
             @(Ten) : @"10",
             @(Knave) : @"Knave",
             @(Queen) : @"Queen",
             @(King) : @"King",
             @(Special): @"Special" };
}

+ (NSDictionary *)SpecialValueNames
{
    return @{@(Joker) : @"Ace",
             @(Eight_Hearts) : @"8 of Hearts",
             @(Eight_Diamonds) : @"8 of Diamonds",
             @(Eight_Spades) : @"8 of Spades",
             @(Eight_Clubs): @"8 of Clubs" };
}


+(NSString *)ValueName:(CardValue)value
{
    return [NWMCardModel ValueNames][@(value)];
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
    int x = 112*(int)offset;
    
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
    if (card.color == Special) {
        // when an 8 has been played, we have a special color == 4 ('Special' enum value)
        // and value is then equals to Special_Heigts + true color value
        return (self.value == Eight || self.color == (card.value - Special_Eights));
    }
    
    // otherwise, an eight can always been stack or else you need same color or same value
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
            
        // Ace is not a chainable attack but has some strength
        case Ace:
            return 1;

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
    if (self.color == Special) {
        return [NSString stringWithFormat:@"Special %@", [NWMCardModel ValueName:self.value]];
    }

    return [NSString stringWithFormat:@"%@ of %@", [NWMCardModel ValueName:self.value], [NWMCardModel ColorName:self.color]];
}
@end
