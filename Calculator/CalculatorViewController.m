//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Nik on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"

@implementation CalculatorViewController

- (CalculatorBrain *)brain 
{
    if (!brain) brain = [[CalculatorBrain alloc] init];
    return brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digitString = [[sender titleLabel] text];
    if (isTypingNumber) {
        // Append the number to whatever's in the display
        [display setText:[[display text] stringByAppendingString:digitString]];
    } else {
        [display setText:digitString];
        isTypingNumber = YES;
    }
     
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (isTypingNumber) {
        // Update the operand to the number the the user has currently typed so far
        [[self brain] setOperand:[[display text] doubleValue]];
        isTypingNumber = NO;
    }
    NSString *operation = [[sender titleLabel] text];
    double result = [[self brain] performOperation:operation];
    [display setText:[NSString stringWithFormat:@"%g", result]];
}


- (void)dealloc
{
    [brain release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
