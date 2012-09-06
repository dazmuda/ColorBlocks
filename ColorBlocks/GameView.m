//
//  GameView.m
//  ColorBlocks
//
//  Created by Diana Zmuda on 9/5/12.
//  Copyright (c) 2012 Diana Zmuda. All rights reserved.
//

#import "GameView.h"
#import "Block.h"

@interface GameView ()


@end

@implementation GameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // initialize the array of columns
        self.columns = [NSMutableArray new];
        for (int i = 0; i < 6; i++) {
            [self.columns addObject:[NSMutableArray new]];
            [self populateColumn:[self.columns objectAtIndex:i]];
        }
        [self setNeedsDisplay];
    }
    return self;
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
        [self.layer addSublayer:block.layer];
    }
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
        for (NSMutableArray* column in self.columns) {
            for (int i = 0; i < [column count]; i++) {
                Block *currentBlock = [column objectAtIndex:i];
                //check if touch is inside frame of block
                if (CGRectContainsPoint(currentBlock.layer.frame, touchPoint)) {

                    //remove the block
                    
                    break;
                }
            }
        }
    }
    
}

-(NSMutableArray *)findSameBlocks:(Block *)block {
    //create an array of the blocks above and below
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
    
    NSMutableArray *blocksToDelete = [NSMutableArray new];
    for (Block *checkingBlock in blocksToCheck) {
        if (CGColorEqualToColor(block.layer.backgroundColor, checkingBlock.layer.backgroundColor)) {
            [blocksToDelete addObject:checkingBlock];
            [blocksToDelete addObjectsFromArray:[[self findSameBlocks:checkingBlock] copy]];
        }
    }
    
    [blocksToDelete addObject:block];
    return blocksToDelete;
}




-(void)seekAndDestroy:(Block *)currentBlock{
    
    NSMutableArray *firstBlocksToDelete = [self findSameBlocks:currentBlock];
    // recursive action
    for (Block *blockToDelete in firstBlocksToDelete) {
        //call this method
        //get back a block to add
        NSMutableArray *secondBlocksToDelete = [self findSameBlocks:blockToDelete];
        
        //only add the block if it isnt in the blocks to delete array
        for (Block *secondBlockToDelete in secondBlocksToDelete) {
            if (![firstBlocksToDelete containsObject:secondBlockToDelete]) {
                [firstBlocksToDelete addObject:secondBlockToDelete];
            }
        }
    }
    
    // destroy all blocks
    for (Block *block in firstBlocksToDelete) {
        [block.column removeObject:block];
        [block.layer removeFromSuperlayer];
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
