//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Nik on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface CalculatorViewController : UIViewController {
    CalculatorBrain *brain;
    IBOutlet UILabel *display;
    IBOutlet UILabel *solvedExpression;
    BOOL isTypingNumber;
}

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)solveExpression:(id)sender;

@end
