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

- (IBAction)solveExpression:(id)sender 
{
    double result = [brain solveExpression];
    solvedExpression.text = [NSString stringWithFormat:@"%g", result];
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
