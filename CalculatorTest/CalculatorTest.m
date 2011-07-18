//
//  CalculatorTest.m
//  CalculatorTest
//
//  Created by Nik on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorTest.h"
#import "CalculatorBrain.h"

@implementation CalculatorTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


/**
 Performs a series of self tests on the Calculator Brain.
 TODO: Move this to a unit test?
 http://denizdemir.com/2011/03/24/ios-unit-testing-with-xcode-4-and-core-data/
 */
- (void)testCalculatorBrain
{
    NSString *x = @"x";
    NSString *y = @"y";
    
    CalculatorBrain *myBrain = [[CalculatorBrain alloc] init];
    // 4+x+15*x*36+y+43
    [myBrain setOperand:4];
    [myBrain performOperation:@"+"];
    [myBrain setVariableAsOperand:x];
    [myBrain performOperation:@"+"];
    [myBrain setOperand:15];
    [myBrain performOperation:@"*"];
    [myBrain setVariableAsOperand:x];
    [myBrain performOperation:@"*"];
    [myBrain setOperand:36];
    [myBrain performOperation:@"+"];
    [myBrain setVariableAsOperand:y];
    [myBrain performOperation:@"+"];
    [myBrain setOperand:43];
    [myBrain performOperation:@"="];
    
    NSMutableDictionary *expressionsDict = [[NSMutableDictionary alloc] init];
    [expressionsDict setValue:[NSNumber numberWithInt:17] forKey:x];
    [expressionsDict setValue:[NSNumber numberWithDouble:35.781] forKey:y];
    
    // Test that the set is correct
    NSSet *varSet = [CalculatorBrain variablesInExpression:myBrain.expression];
    assert([varSet count] == 2);
    //for (NSString *var in varSet) {
    //    NSLog(@"******* %@", var);
    //}
    assert([varSet member:x]);
    assert([varSet member:y]);
    
    //NSString *expression = [CalculatorBrain descriptionOfExpression:myBrain.expression];
    //double result = [CalculatorBrain evaluateExpression:myBrain.expression 
    //                                usingVariableValues:expressionsDict];
    [expressionsDict release];
    [myBrain release];
}


@end
