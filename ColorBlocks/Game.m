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
    [self.gvc.currentView setNeedsDisplay];
}

-(void)populateColumn:(NSMutableArray*)column {
    for (int i = 0; i < 8; i++) {
        Block *block = [Block new];
        [block configBlock];
        block.column = column;
        [column addObject:block];
    }
    for (Block *block in column) {
        block.layer.position = CGPointMake(([self.columns indexOfObject:column] + 1) * 45, ([column indexOfObject:block] + 1) * 50);
        [self.gvc.currentView.layer addSublayer:block.layer];
    }

}

-(NSMutableArray*)findNeighborsForBlock:(Block*)block {
    int blockIndex = [block.column indexOfObject:block];
    NSMutableArray *blocksToCheck = [NSMutableArray new];
    
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
        [blocksToCheck addObject:[[self.columns objectAtIndex:(columnIndex - 1) ] objectAtIndex:(blockIndex)]];
        [blocksToCheck addObject:[[self.columns objectAtIndex:(columnIndex + 1) ] objectAtIndex:(blockIndex)]];
    }
    
    return blocksToCheck;
}

-(void)removeBlock:(Block*)block blocksToDelete:(NSMutableSet*)blocksToDelete {
    [blocksToDelete addObject:block];
    for (Block* neighbor in [self findNeighborsForBlock:block]) {
        if (!CGColorEqualToColor(neighbor.layer.backgroundColor, block.layer.backgroundColor)) {
            continue;
        }
        if (![blocksToDelete containsObject:neighbor]) {
            continue;
        }
        [self removeBlock:neighbor blocksToDelete:blocksToDelete];
            
    }
}

-(void)seekAndDestroy:(Block*)block {
    
    NSMutableSet* blocksToDelete = [NSMutableSet new];
    [self removeBlock:block blocksToDelete:blocksToDelete];
    
    // destroy all blocks
    for (Block *block in blocksToDelete) {
        [block.column removeObject:block];
        [block.layer removeFromSuperlayer];
    }
    [self.gvc.currentView setNeedsDisplay];
}


@end
