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

- (void)updateDisplayWithResult:(NSDictionary *)variableValues
{
    display.text = [NSString stringWithFormat:@"%g",
                    [CalculatorBrain evaluateExpression:brain.expression
                                    usingVariableValues:nil]];     
}

/**
 Updates the display with the value of the evaluated expression
 */
- (void)updateDisplayWithExpression
{
    if ([CalculatorBrain variablesInExpression:brain.expression]) {
        display.text = [CalculatorBrain descriptionOfExpression:brain.expression];
    } else {
        [self updateDisplayWithResult:nil];
    }
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

- (IBAction)variablePressed:(UIButton *)sender
{
    if (!isTypingNumber) {        
        [brain setVariableAsOperand:sender.titleLabel.text];
        [self updateDisplayWithExpression];
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
    /*double result = */[brain performOperation:operation];
    //[display setText:[NSString stringWithFormat:@"%g", result]];
    [self updateDisplayWithExpression];
}

- (IBAction)clearPressed:(UIButton *)sender
{
    [brain clearCalculator];
    isTypingNumber = NO;
    display.text = @"0";
}


- (IBAction)solveExpression:(id)sender 
{
    NSString *expression = [CalculatorBrain descriptionOfExpression:brain.expression];
    NSMutableString *sb = [[NSMutableString alloc] initWithString:expression];
    if (![expression hasSuffix:@"="]) {
        [sb appendString:@"="];
    }
    [sb appendString:@" "];

    // Create fake dictionary
    NSMutableDictionary *expressionsDict = [[NSMutableDictionary alloc] init];
    [expressionsDict setValue:[NSNumber numberWithInt:17] forKey:@"x"];
    [expressionsDict setValue:[NSNumber numberWithDouble:35.781] forKey:@"y"];
    [expressionsDict setValue:[NSNumber numberWithDouble:14] forKey:@"z"];
    
    double result = [CalculatorBrain evaluateExpression:brain.expression
                                    usingVariableValues:expressionsDict];
    [expressionsDict release];

    [sb appendString:[NSString stringWithFormat:@"%g", result]];
    display.text = sb;
    [sb release];
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
