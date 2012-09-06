//
//  Game.m
//  ColorBlocks
//
//  Created by Diana Zmuda on 9/5/12.
//  Copyright (c) 2012 Diana Zmuda. All rights reserved.
//

#import "Game.h"
#import "Block.h"
#import "GameView.h"
#import "GameViewController.h"

@implementation Game

-(void)initializeGame {
    // initialize the array of columns
    self.columns = [NSMutableArray new];
    for (int i = 0; i < 6; i++) {
        [self.columns addObject:[NSMutableArray new]];
        [self populateColumn:[self.columns objectAtIndex:i]];
    }
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 420, 100, 50)];
    [self.gvc.currentView addSubview:self.scoreLabel];
    
    float angle = M_PI;
    self.scoreLabel.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
    
    [self.gvc.currentView setNeedsDisplay];
}

-(void)populateColumn:(NSMutableArray*)column {
    for (int i = 0; i < 8; i++) {
        Block *block = [Block new];
        [block configBlock];
        block.column = column;
        [column addObject:block];
    }
    [self setLocationForColumn:column];
}

-(void)setLocationForColumn:(NSMutableArray*)column {    
    for (Block *block in column) {
        CABasicAnimation *fallAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        fallAnimation.fromValue = [NSValue valueWithCGPoint:block.layer.position];
        block.layer.position = CGPointMake(([self.columns indexOfObject:column] + 1) * 47, ([column indexOfObject:block] + 1) * 52);
        fallAnimation.toValue = [NSValue valueWithCGPoint:block.layer.position];
        fallAnimation.duration = 0.3; //?
        [self.gvc.currentView.layer addSublayer:block.layer];
        // Animate
        [block.layer addAnimation:fallAnimation forKey:@"fallAnimation"];
    }
}

-(NSMutableSet*)findNeighborsForBlock:(Block*)block {
    int blockIndex = [block.column indexOfObject:block];
    NSMutableSet *blocksToCheck = [NSMutableSet new];
    
    // Check in the same column
    if (blockIndex == 0) {
        [blocksToCheck addObject:[block.column objectAtIndex:(blockIndex + 1)]];
    } else if (blockIndex == [block.column count] - 1) {
        [blocksToCheck addObject:[block.column objectAtIndex:(blockIndex - 1)]];
    } else {
        [blocksToCheck addObject:[block.column objectAtIndex:(blockIndex + 1)]];
        [blocksToCheck addObject:[block.column objectAtIndex:(blockIndex - 1)]];
    }
    
    // Check in adjacent column
    int columnIndex = [self.columns indexOfObject:block.column];
    if (columnIndex == 0) {
        [blocksToCheck addObject:[[self.columns objectAtIndex:(columnIndex + 1) ] objectAtIndex:(blockIndex)]];
    } else if (columnIndex == [self.columns count] - 1) {
        [blocksToCheck addObject:[[self.columns objectAtIndex:(columnIndex - 1) ] objectAtIndex:(blockIndex)]];
    } else {
        [blocksToCheck addObject:[[self.columns objectAtIndex:(columnIndex + 1) ] objectAtIndex:(blockIndex)]];
        [blocksToCheck addObject:[[self.columns objectAtIndex:(columnIndex - 1) ] objectAtIndex:(blockIndex)]];
    }
    
    return blocksToCheck;
}

-(void)createDeletionSetWithBlock:(Block*)block withVisitedBlocks:(NSMutableSet*)visitedBlocks withDeletionSet:(NSMutableSet*)deletionSet{
    NSMutableSet *neighbors = [self findNeighborsForBlock:block];
    [visitedBlocks addObject:block];
    for (Block* neighbor in neighbors) {
        if (CGColorEqualToColor(neighbor.layer.backgroundColor, block.layer.backgroundColor) == YES && [visitedBlocks containsObject:neighbor] == NO) {
            [deletionSet addObject:neighbor];
            [self createDeletionSetWithBlock:neighbor withVisitedBlocks:visitedBlocks withDeletionSet:deletionSet];
        }
    }
}

-(void)seekAndDestroy:(Block*)block {
    NSMutableSet* visitedBlocks = [NSMutableSet new];
    [visitedBlocks addObject:block];
    NSMutableSet* deletionSet = [NSMutableSet new];
    [deletionSet addObject:block];
    [self createDeletionSetWithBlock:block withVisitedBlocks:visitedBlocks withDeletionSet:deletionSet];
    
    // destroy all blocks
    if ([deletionSet count] < 2) {
        return;
    }
    for (Block *block in deletionSet) {
        // delete block
        [block.column removeObject:block];
        [block.layer removeFromSuperlayer];
        self.score += 1;
        self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
        
        // new block
        Block *newBlock = [Block new];
        [newBlock configBlock];
        newBlock.column = block.column;
        [newBlock.column addObject:newBlock];
        [self setLocationForColumn:newBlock.column];
        [self.gvc.currentView.layer addSublayer:newBlock.layer];        
    }
    [self.gvc.currentView setNeedsDisplay];
}


@end
