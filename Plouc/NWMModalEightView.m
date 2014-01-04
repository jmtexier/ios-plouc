//
//  NWMModalEightView.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 04/01/14.
//  Copyright (c) 2014 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMModalEightView.h"
#import "NWMCardModel.h"

@interface NWMModalEightView ()

@property (nonatomic) UIView *buttonLayer;
@property (nonatomic) IBOutlet UIButton *buttonHearts;
@property (nonatomic) IBOutlet UIButton *buttonSpades;
@property (nonatomic) IBOutlet UIButton *buttonClubs;
@property (nonatomic) IBOutlet UIButton *buttonDiamonds;

@end

@implementation NWMModalEightView

#pragma mark - View methods


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.buttonLayer = [self createBackLayer];
        [self addSubview:self.buttonLayer];
        self.buttonHearts   = [self addButttonAt:CGPointMake(0, 0) withColorImage:Hearts];
        self.buttonSpades   = [self addButttonAt:CGPointMake(1, 0) withColorImage:Spades];
        self.buttonClubs    = [self addButttonAt:CGPointMake(0, 1) withColorImage:Clubs];
        self.buttonDiamonds = [self addButttonAt:CGPointMake(1, 1) withColorImage:Diamonds];
    }
    
    return self;
}

-(UIView *)createBackLayer
{
    CGSize size = self.bounds.size;
    CGFloat x = (size.width - 126)/2;
    CGFloat y = (size.height - 168)/2;
    UIView *layer = [[UIView alloc] initWithFrame:CGRectMake(x, y, 136,168)];
    layer.backgroundColor = [UIColor whiteColor];
    layer.opaque = YES;
    layer.layer.cornerRadius = 6;
    layer.layer.borderWidth = 1;
    layer.layer.borderColor = [UIColor blackColor].CGColor;
    
    return layer;
}

-(UIButton *)addButttonAt:(CGPoint)position withColorImage:(NSUInteger)color
{
    CGFloat x = 8 + position.x * 64;
    CGFloat y = 8 + position.y * 80;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 56, 72)];
    [button setImage:[NWMCardModel getColorImage:color] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = color;
    [self.buttonLayer addSubview:button];
    
    return button;
}

-(void)onButton:(UIButton *)sender
{
    NSLog(@"A button has been clicked : %d", sender.tag);
    [self removeFromSuperview];
    [self.delegate onColorSelected:sender.tag];
}

@end
