//
//  GameViewController.h
//  ColorBlocks
//
//  Created by Diana Zmuda on 9/5/12.
//  Copyright (c) 2012 Diana Zmuda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Block;
@class GameView;
@class Game;

@interface GameViewController : UIViewController

@property (strong) GameView *currentView;
@property (strong) Game *currentGame;

-(void)blocktouched:(Block*)currentBlock;

@end
