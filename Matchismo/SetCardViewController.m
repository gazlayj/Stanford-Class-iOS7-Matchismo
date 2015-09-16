//
//  SetCardViewController.m
//  Matchismo
//
//  Created by Justin Gazlay on 9/15/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "SetCardViewController.h"

@implementation SetCardViewController

+(NSAttributedString *)getAttributedStringDescriptionForCard:(SetCard *)card
{
    NSMutableAttributedString *cardDescription = [[NSMutableAttributedString alloc] init];
    
    [cardDescription appendAttributedString:[self symbolForCard:card]];
    [cardDescription appendAttributedString:[self duplicateSymbolsForCard:card]];
    [cardDescription addAttribute:NSForegroundColorAttributeName value:[self colorForCard:card]
                            range:NSMakeRange(0, [cardDescription length])];
    
    NSAttributedString *shadedCardDescription = [self shadeCardDescription:cardDescription forCard:card];

    return shadedCardDescription;
}

#pragma mark - Helper Methods

+ (NSAttributedString *)symbolForCard:(SetCard *)card
{
    return [[NSAttributedString alloc] initWithString:[self validSymbols][card.symbolIdentifier]];
}


+ (UIColor *)colorForCard:(SetCard *)card
{
    return [self validColors][card.colorIdentifier];
}


+ (NSAttributedString *)duplicateSymbolsForCard:(SetCard *)card
{
    NSMutableAttributedString *symbolsToAdd = [[NSMutableAttributedString alloc] init];
    for (int i = 1; i < card.number; i++) {
        [symbolsToAdd appendAttributedString:[self symbolForCard:card]];
    }
    
    return symbolsToAdd;
}


+ (NSAttributedString *)shadeCardDescription:(NSAttributedString *)cardDescription forCard:(SetCard *)card
{
    NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithAttributedString:cardDescription];
    
    if ([self isSolidCard:card]) {
        return description;
    } else if ([self isOutlinedCard:card]) {
        [description addAttribute:NSStrokeWidthAttributeName value:@3 range:NSMakeRange(0, [description length])];
    } else if ([self isSemiTransparentCard:card]) {
        UIColor *newColor = [description attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
        [description addAttribute:NSForegroundColorAttributeName value:[newColor colorWithAlphaComponent:0.5] range:NSMakeRange(0, [description length])];
    }
    return description;
}


+ (BOOL)isSolidCard:(SetCard *)card
{
    return card.shadingIdentifier == 0;
}


+ (BOOL)isOutlinedCard:(SetCard *)card
{
    return card.shadingIdentifier == 1;
}


+ (BOOL)isSemiTransparentCard:(SetCard *)card
{
    return card.shadingIdentifier == 2;
}




+ (NSArray *)validSymbols
{
    return @[@"●", @"▲", @"■"];
}

+ (NSArray *)validColors
{
    return @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]];
}



@end
