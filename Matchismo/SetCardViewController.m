//
//  SetCardViewController.m
//  Matchismo
//
//  Created by Justin Gazlay on 9/15/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "SetCardViewController.h"


@interface SetCardViewController()
@property SetCard *card;

@end

@implementation SetCardViewController

-(instancetype)initWithSetCard:(SetCard *)card
{
    self = [super init];
    
    if (self) {
        self.card = card;
    }
    
    return self;
}

- (NSAttributedString *)attributedStringDescription
{
    NSMutableAttributedString *cardDescription = [[NSMutableAttributedString alloc] init];
    
    [cardDescription appendAttributedString:[self allSymbolsForCard]];
    [cardDescription addAttribute:NSForegroundColorAttributeName value:[self colorForCard]
                            range:NSMakeRange(0, [cardDescription length])];
    
    NSAttributedString *shadedCardDescription = [self shadeCardDescription:cardDescription];

    return shadedCardDescription;
}

#pragma mark - Helper Methods

- (NSAttributedString *)cardSymbol
{
    return [[NSAttributedString alloc] initWithString:[self validSymbols][self.card.symbolIdentifier]];
}


- (UIColor *)colorForCard
{
    return [self validColors][self.card.colorIdentifier];
}


- (NSAttributedString *)allSymbolsForCard
{
    NSMutableAttributedString *symbolsToAdd = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < self.card.number; i++) {
        [symbolsToAdd appendAttributedString:[self cardSymbol]];
    }
    
    return symbolsToAdd;
}


- (NSAttributedString *)shadeCardDescription:(NSAttributedString *)cardDescription
{
    NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithAttributedString:cardDescription];
    
    if ([self isSolidCard]) {
        return description;
    } else if ([self isOutlinedCard]) {
        description = [[self outlinedCardDescription:description] mutableCopy];
    } else if ([self isSemiTransparentCard]) {
        description = [[self semiTransparentCardDescription:description] mutableCopy];
    }
    
    return description;
}


- (BOOL)isSolidCard
{
    return self.card.shadingIdentifier == 0;
}


- (BOOL)isOutlinedCard
{
    return self.card.shadingIdentifier == 1;
}


- (BOOL)isSemiTransparentCard
{
    return self.card.shadingIdentifier == 2;
}

- (NSAttributedString *)outlinedCardDescription:(NSMutableAttributedString *)description
{
    [description addAttributes: @{NSStrokeWidthAttributeName : @4} range:NSMakeRange(0, [description length])];
    return description;
}

- (NSAttributedString *)semiTransparentCardDescription:(NSMutableAttributedString *)description
{
    UIColor *newColor = [description attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
    
    [description addAttributes:@{NSForegroundColorAttributeName : [newColor colorWithAlphaComponent:0.3],
                                 NSStrokeWidthAttributeName : @-4,
                                 NSStrokeColorAttributeName : newColor}
                         range:NSMakeRange(0, [description length])];
    return description;
}


- (NSArray *)validSymbols
{
    return @[@"●", @"▲", @"■"];
}

- (NSArray *)validColors
{
    return @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]];
}



@end
