//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Justin Gazlay on 9/1/15.
//  Copyright (c) 2015 Justin Gazlay. All rights reserved.
//
// Abstract Class. Implement below methods in Subclass.

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;
// Protected
// For Subclass implementation only
- (Deck *)createDeck; // abstract
- (UIImage *)backgroundImageForCard:(Card *)card;
- (NSAttributedString *)titleForCard:(Card *)card;


@end
