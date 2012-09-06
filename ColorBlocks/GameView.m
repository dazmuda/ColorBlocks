//
//  GameView.m
//  ColorBlocks
//
//  Created by Diana Zmuda on 9/5/12.
//  Copyright (c) 2012 Diana Zmuda. All rights reserved.
//

#import "GameView.h"
#import "Block.h"
#import "Game.h"
#import "GameViewController.h"

@interface GameView ()


@end

@implementation GameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float angle = M_PI;
        self.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
        [self setNeedsDisplay];
    }
    return self;
}



- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self deleteBlockAtTouches:touches];
    
}

- (void) deleteBlockAtTouches:(NSSet*)touches {
    //enumerate through the NSSet
    NSEnumerator *enumerator = [touches objectEnumerator];
    UITouch *touch;
    
    while ((touch = [enumerator nextObject])) {
        //for each touch, create a new CGPoint
        CGPoint touchPoint = [touch locationInView:self];
        for (NSMutableArray* column in self.gvc.currentGame.columns) {
            for (int i = 0; i < [column count]; i++) {
                Block *currentBlock = [column objectAtIndex:i];
                //check if touch is inside frame of block
                if (CGRectContainsPoint(currentBlock.layer.frame, touchPoint)) {
                    //call a method in gameviewcontroller
                    [self.gvc blocktouched:currentBlock];
                    //block touched would call the game method to find other blocks and delete them
                    break;
                }
            }
        }
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
