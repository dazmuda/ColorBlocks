//
//  GameViewController.m
//  ColorBlocks
//
//  Created by Diana Zmuda on 9/5/12.
//  Copyright (c) 2012 Diana Zmuda. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"
#import "Game.h"
#import "Block.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentView = [GameView new];
        self.currentView.gvc = self;
        self.view = self.currentView;
        
        self.currentGame = [Game new];
        self.currentGame.gvc = self;
        [self.currentGame initializeGame];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)blocktouched:(Block *)currentBlock {
    //block touched would call the game method to find other blocks and delete them
    [self.currentGame seekAndDestroy:currentBlock];
}

@end
