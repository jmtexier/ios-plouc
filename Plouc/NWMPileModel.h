//
//  NWMPileModel.h
//  Plouc
//
//  Created by Jean-Michel TEXIER on 30/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWMCardModel.h"

@interface NWMPileModel : NSObject

@property (readonly) int count;

- (NWMCardModel *)drawCard;

- (void)shuffle;

@end
