//
//  Block.h
//  ColorBlocks
//
//  Created by Diana Zmuda on 9/5/12.
//  Copyright (c) 2012 Diana Zmuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Block : NSObject

@property (strong) CALayer *layer;
@property (strong) NSMutableArray *column;
-(void)configBlock;

@end
