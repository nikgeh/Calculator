//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Nik on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController()
- (void)initComponents;
- (void)releaseComponents;
@property (retain) CalculatorBrain *brain;
@end


@implementation CalculatorViewController
@synthesize brain;

- (void)initComponents
{
    CalculatorBrain *calcBrain = [[CalculatorBrain alloc] init];
    brain = [[CalculatorBrain alloc] init];
    [calcBrain release];
}

- (void)releaseComponents
{
    brain = nil;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digitString = [sender.titleLabel text];
    if (isTypingNumber) {
        // Append the number to whatever's in the display
        display.text = [display.text stringByAppendingString:digitString];
    } else {
        [display setText:digitString];
        isTypingNumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (isTypingNumber) {
        // Update the operand to the number the the user has currently typed so far
        [brain setOperand:[display.text doubleValue]];
        isTypingNumber = NO;
    }
    NSString *operation = [[sender titleLabel] text];
    double result = [brain performOperation:operation];
    [display setText:[NSString stringWithFormat:@"%g", result]];
}

/**
 Performs a series of self tests on the Calculator Brain.
 TODO: Move this to a unit test?
 */
- (void)selfTest
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
    
    NSString *expression = [CalculatorBrain descriptionOfExpression:myBrain.expression];
    double result = [CalculatorBrain evaluateExpression:myBrain.expression 
                                    usingVariableValues:expressionsDict];
    solvedExpression.text = [NSString stringWithFormat:@"%@ = %g", expression, result];
    [expressionsDict release];
    [myBrain release];
}

- (IBAction)solveExpression:(id)sender 
{
    //double result = [brain solveExpression];
    //solvedExpression.text = [NSString stringWithFormat:@"%g", result];
    [self selfTest];
}

- (void)dealloc
{
    [self initComponents];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    // Initialize the brain
    [self initComponents];
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self releaseComponents];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
