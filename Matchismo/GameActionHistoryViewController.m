//
//  GameActionHistoryViewController.m
//  Matchismo
//
//  Created by Emily H Gazlay on 9/20/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "GameActionHistoryViewController.h"

@interface GameActionHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *gameActionDescriptionTextView;

@end

@implementation GameActionHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.gameActionDescriptionTextView.attributedText = [self actionsHistoryDescription];
}

- (NSAttributedString *)actionsHistoryDescription
{
    NSMutableAttributedString *actionsDescriptions = [[NSMutableAttributedString alloc] init];
    for (NSAttributedString *actionDescription in self.gameActionHistoryStrings) {
        if ([self.gameActionHistoryStrings indexOfObject:actionDescription] > 0) {
            [actionsDescriptions appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
        
        [actionsDescriptions appendAttributedString:actionDescription];
    }

    return [actionsDescriptions copy];
}



@end
