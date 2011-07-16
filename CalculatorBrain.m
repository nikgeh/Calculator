//
//  CalculatorBrain.m
//  Calculator
//  Handles the logic for the Calculator
//
//  Created by Nik on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (retain) NSString *waitingOperation;
@end

@implementation CalculatorBrain

// When we synthesize @property (retain) waitingOperation, we 
// will release any memory associated with it when we set a new value
@synthesize waitingOperation;

- (void)setOperand:(double)aDouble {
    operand = aDouble;
}

- (void)performWaitingOperation {
    if ([@"+" isEqual:self.waitingOperation]) {
        operand = waitingOperand + operand;
    } else if ([@"-" isEqual:self.waitingOperation]) {
        operand = waitingOperand - operand;
    } else if ([@"*" isEqual:self.waitingOperation]) {
        operand = waitingOperand * operand;
    } else if ([@"/" isEqual:self.waitingOperation]) {
        if (operand) {
            operand = waitingOperand / operand;            
        }
    }
}

- (double)performOperation:(NSString *)operation {
    if ([operation isEqual:@"sqrt"]) {
        operand = sqrt(operand);
    } else if ([@"+/-" isEqual:operation]) {
        operand = -operand;
    } else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        waitingOperand = operand;
    }
    return operand;
}

- (void)dealloc
{
    self.waitingOperation = nil;
    [super dealloc];
}


@end
