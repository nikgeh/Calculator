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

- (void)resetElements
{
    [expressionArray release];
    self.waitingOperation = nil;
    operand = 0;
    waitingOperand = 0;
    expressionArray = [[NSMutableArray alloc] initWithObjects:nil];        
}

- (id)init
{
    self = [super init];
    if (self) {
        [self resetElements];
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


/**
 @return the expression @property
 */
- (id)expression 
{
    NSMutableArray *copyOfArray = [expressionArray copy];
    [copyOfArray autorelease];
    return copyOfArray;
}

- (void)addTermToExpression:(id)term
{
    [expressionArray addObject:term];
}

- (void)setOperand:(double)aDouble 
{
    operand = aDouble;
    NSNumber *newOperand = [NSNumber numberWithDouble:aDouble];
    [self addTermToExpression:newOperand];
}

- (void)setVariableAsOperand:(NSString *)variable 
{
    [self addTermToExpression:[NSString stringWithFormat:@"%@%@", VARIABLE_PREFIX, variable]];
}

- (double)performOperation:(NSString *)operation 
{
    if ([operation isEqual:@"sqrt"]) {
        operand = sqrt(operand);
    } else if ([@"+/-" isEqual:operation]) {
        operand = -operand;
    } else if ([@"sin" isEqual:operation]) {
        operand = sin(operand);
    } else if ([@"cos" isEqual:operation]) {
        operand = cos(operand);
    } else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        waitingOperand = operand;
    }
    [self addTermToExpression:operation];
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

- (void)clearCalculator
{
    [self resetElements];
}

// Whether the token is a variable string
+ (BOOL)isVariableString:(NSString *)tokenString
{
    return [tokenString hasPrefix:VARIABLE_PREFIX] && 
        [tokenString length] > [VARIABLE_PREFIX length];
}

// Strips out the VARIABLE_PREFIX from the token to return the variable value
+ (NSString *)getVariableFromVariableString:(NSString *)tokenString
{
    return [tokenString substringFromIndex:[VARIABLE_PREFIX length]];
}


+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables 
{
    CalculatorBrain *brain = [[CalculatorBrain alloc] initWithBlankExpressions];
    NSArray *myExpression = (NSArray *)anExpression;
    for (id token in myExpression) {
        if ([token isKindOfClass:[NSString class]]) {
            // This is an operator or variable
            NSString *tokenString = (NSString *)token;
            
            if ([self isVariableString:tokenString]) {
                // This is a variable, so get the value from the map
                // and set it as an operand
                NSString *variableString = 
                        [self getVariableFromVariableString:tokenString];
                NSNumber *variableValue = [variables objectForKey:variableString];
                [brain setOperand:[variableValue doubleValue]];
            } else {
                // This is an operator, so perform the operation on the brain
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

// Returns a set of the variables in the given expression
// or null if there are no variables
+ (NSSet *)variablesInExpression:(id)anExpression
{
    NSMutableSet *variables = [[NSMutableSet alloc] init];

    NSArray *myExpression = (NSArray *)anExpression;
    for (id token in myExpression) {
        if ([token isKindOfClass:[NSString class]]) {
            // This is an operator or variable
            NSString *tokenString = (NSString *)token;
            if ([self isVariableString:tokenString]) {
                // It's a variable, add it to the set
                [variables addObject:[self getVariableFromVariableString:tokenString]];
            }
        }
    }
    
    // Create an immutable set and return it
    // We could return the mutable set, but just to be complete...
    NSSet *immutableVariables = [variables count] == 0 ? 
                                nil : [[NSSet alloc] initWithSet:variables];    
    [variables release];
    [immutableVariables autorelease];
    return immutableVariables;
}

+ (NSString *)descriptionOfExpression:(id)anExpression 
{
    NSMutableArray *sb = [[NSMutableArray alloc] init];
    for (id token in anExpression) {
        if ([token isKindOfClass:[NSString class]]) {
            // This is an operator or variable
            NSString *tokenString = (NSString *)token;
            
            if ([self isVariableString:tokenString]) {
                tokenString = [self getVariableFromVariableString:tokenString];
            } 
            [sb addObject:tokenString];
        } else if ([token isKindOfClass:[NSNumber class]]) {
            NSNumber *operand = (NSNumber *)token;
            [sb addObject:[operand stringValue]];
        } else {
            // What do we do here? Throw something?
        }
    }
    
    NSString *descriptionString = [sb componentsJoinedByString:@" "];
    [sb release];
    return descriptionString;
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
