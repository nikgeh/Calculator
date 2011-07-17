//
//  CalculatorBrain.m
//  Calculator
//  Handles the logic for the Calculator
//
//  Created by Nik on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

#define VARIABLE_PREFIX @"%"

@interface CalculatorBrain()
- (void)performWaitingOperation;
- (id)initWithBlankExpressions;
@property (retain) NSString *waitingOperation;
@end

@implementation CalculatorBrain

// When we synthesize @property (retain) waitingOperation, we 
// will release any memory associated with it when we set a new value
@synthesize waitingOperation;

- (id)init
{
    self = [super init];
    if (self) {
        expressionArray = [[NSMutableArray alloc] initWithObjects:nil];        
    }
    return self;
}

- (id)initWithBlankExpressions
{
    self = [super init];
    if (self) {
        expressionArray = nil;        
    }
    return self;
}


// Returns the expression @property
- (id)expression 
{
    NSMutableArray *copyOfArray = [expressionArray copy];
    [copyOfArray autorelease];
    return copyOfArray;
}


- (void)setOperand:(double)aDouble 
{
    operand = aDouble;
    NSNumber *newOperand = [NSNumber numberWithDouble:aDouble];
    [expressionArray addObject:newOperand];
}

- (void)setVariableAsOperand:(NSString *)variable 
{
    [expressionArray addObject:[NSString stringWithFormat:@"%s%s", VARIABLE_PREFIX, variable]];
}

- (double)performOperation:(NSString *)operation 
{
    if ([operation isEqual:@"sqrt"]) {
        operand = sqrt(operand);
    } else if ([@"+/-" isEqual:operation]) {
        operand = -operand;
    } else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        waitingOperand = operand;
    }
    [expressionArray addObject:operation];
    return operand;
}

- (void)performWaitingOperation 
{
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


+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables 
{
    CalculatorBrain *brain = [[CalculatorBrain alloc] initWithBlankExpressions];
    NSArray *myExpression = (NSArray *)anExpression;
    for (id token in myExpression) {
        if ([token class] == [NSString class]) {
            // This is an operator or variable
            NSString *tokenString = (NSString *)token;
            if ([tokenString hasPrefix:VARIABLE_PREFIX]) {
                [brain setVariableAsOperand:tokenString];
            } else {
                [brain performOperation:tokenString];
            }
        } else if ([token isKindOfClass:[NSNumber class]]){
            // This is an operand
            [brain setOperand:[((NSNumber *)token) doubleValue]];
        } else {
            // What do we do here? Throw something?
        }
    }
    double retVal = brain->operand;
    [brain release];
    return retVal;
}

+ (NSSet *)variablesInExpression:(id)anExpression
{
    // TODO
    return nil;
}

+ (NSString *)descriptionOfExpression:(id)anExpression 
{
    // TODO
    return nil;
}

+ (id)propertyListForExpression:(id)anExpression
{
    // TODO
    return nil;
}

+ (id)expressionForPropertyList:(id)propertyList
{
    // TODO
    return nil;
}

- (void)dealloc
{
    self.waitingOperation = nil;
    [expressionArray release];
    [super dealloc];
}


@end
