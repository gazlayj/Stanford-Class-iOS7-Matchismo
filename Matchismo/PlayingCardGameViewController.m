//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Justin Gazlay on 9/14/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.game.numberOfCardsToCompareMatch = 2;
}

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
