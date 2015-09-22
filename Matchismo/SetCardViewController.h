//
//  SetCardViewController.h
//  Matchismo
//
//  Created by Justin Gazlay on 9/15/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCard.h"

@interface SetCardViewController : UIViewController

-(instancetype)initWithSetCard:(SetCard *)card;
- (NSAttributedString *)attributedStringDescription;

@end
