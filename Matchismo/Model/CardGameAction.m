//
//  CardGameAction.m
//  Matchismo
//
//  Created by Justin Gazlay on 9/18/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "CardGameAction.h"
#import "Card.h"

@interface CardGameAction()

@property (readwrite, strong, nonatomic) NSArray *chosenCards; // of Card
@property (readwrite, nonatomic) NSInteger pointsEarned;
@property (readwrite, nonatomic) CardGameActionType actionType;

@end

@implementation CardGameAction

-(instancetype)initCardGameActionWithChosenCards:(NSArray *)chosenCards
{
    self = [super init];
    
    if (self) {
        self.chosenCards = chosenCards;
        self.actionType = CardChosen;
        self.pointsEarned = 0;
    }
    
    return self;
}

-(CardGameActionType)matchCards
{
    if (self.actionType == CardChosen) {
        self.pointsEarned = [self getMatchScore];
        
        [self setMatchActionType];
    }
    
    return self.actionType;
}

-(NSInteger)applyMatchBonusMultiplier:(int)bonusMultiplier
{
    if (self.actionType == Match) {
        self.pointsEarned = self.pointsEarned * bonusMultiplier;
    }
    return self.pointsEarned;
}

-(NSInteger)subtractMismatchPenalty:(int)mismatchPenalty
{
    if (self.actionType == Mismatch) {
        self.pointsEarned -= mismatchPenalty;
    }
    return self.pointsEarned;
}

#pragma mark - Private Helper Methods

- (int)getMatchScore
{
    int matchScore = 0;
    for (Card *card in self.chosenCards) {
        NSMutableArray *remainingCards = [self.chosenCards mutableCopy];
        [remainingCards removeObject:card];
        
        if ([remainingCards count] >= 1) {
            matchScore += [card match:remainingCards];
        }
    }
    
    return matchScore;
}

- (void)setMatchActionType
{
    if (self.pointsEarned) {
        self.actionType = Match;
    } else {
        self.actionType = Mismatch;
    }
}



@end
