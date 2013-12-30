//
//  NWMHandModel.h
//  Plouc
//
//  Created by Jean-Michel TEXIER on 30/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWMCardModel.h"

@interface NWMHandModel : NSObject

@property (readonly) int count;

- (void)addCard:(NWMCardModel *)card;

- (NWMCardModel *)getCardAtIndex:(NSUInteger)index;

- (void)removeCardAtIndex:(NSUInteger)index;

- (void)sort;

@end
