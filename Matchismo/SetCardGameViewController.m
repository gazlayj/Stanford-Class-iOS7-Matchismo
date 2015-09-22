//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Justin Gazlay on 9/14/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardViewController.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.game.numberOfCardsToCompareMatch = 3;

}

#pragma mark - CardGameViewControllerMethods
-(Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

-(UIImage *)backgroundImageForCard:(Card *)card
{
    return card.isChosen ? [UIImage imageNamed:@"strokedCardFront"] : [UIImage imageNamed:@"cardFront"];
}

-(NSAttributedString *)titleForCard:(Card *)card
{
    return [self getAttributedStringForCard:card];
}

- (NSAttributedString *)getAttributedStringForCard:(Card *)card
{
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        SetCardViewController *setVC = [[SetCardViewController alloc] initWithSetCard:setCard];
        return [setVC attributedStringDescription];
    }
    
    return nil;
}



@end
