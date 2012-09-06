//
//  Game.h
//  ColorBlocks
//
//  Created by Diana Zmuda on 9/5/12.
//  Copyright (c) 2012 Diana Zmuda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameViewController;
@class Block;

@interface Game : NSObject

@property (strong) NSMutableArray *columns;
@property (strong) GameViewController *gvc;
@property (strong) UILabel *scoreLabel;
@property int score;

-(void)initializeGame;
-(void)seekAndDestroy:(Block*)block;

@end
