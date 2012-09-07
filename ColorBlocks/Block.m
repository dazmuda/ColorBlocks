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
    self.layer.bounds = CGRectMake(0,0,45,60);
    //iphone is 320x480
    self.layer.position = CGPointMake(160, 0);
    
    NSArray* colors = [[NSArray alloc] initWithObjects:[UIColor purpleColor], [UIColor blackColor], [UIColor greenColor], [UIColor blueColor], nil];
    
    UIImage *ned = [UIImage imageNamed:@"ned-ruggeri.jpg"];
    UIImage *kush = [UIImage imageNamed:@"kush-patel.jpg"];
    UIImage *jonathan = [UIImage imageNamed:@"jonathan-nieder.jpg"];
    UIImage *diana = [UIImage imageNamed:@"diana-zmuda.jpg"];
    NSArray *faces = [[NSArray alloc] initWithObjects:ned, kush, jonathan, diana, nil];
   
    int randInt = arc4random() % [faces count];
    self.layer.contents = (__bridge id)([[faces objectAtIndex:randInt] CGImage]);
    // float angle = M_PI;
    //self.layer.transform = CATransform3DMakeRotation(angle, 0, 0.0, 1.0);
    
    self.layer.backgroundColor = [[colors objectAtIndex:randInt] CGColor];
}

@end
