//
//  Block.m
//  ColorBlocks
//
//  Created by Diana Zmuda on 9/5/12.
//  Copyright (c) 2012 Diana Zmuda. All rights reserved.
//

#import "Block.h"

@implementation Block

-(void)configBlock {
    self.layer = [CALayer layer];
    self.layer.bounds = CGRectMake(0,0,30,40);
    //iphone is 320x480
    self.layer.position = CGPointMake(160, 480);
    NSArray* colors = [[NSArray alloc] initWithObjects:[UIColor purpleColor], [UIColor blackColor], [UIColor greenColor], [UIColor blueColor], nil];
    self.layer.backgroundColor = [[colors objectAtIndex:(arc4random() % [colors count])] CGColor];
}

@end
