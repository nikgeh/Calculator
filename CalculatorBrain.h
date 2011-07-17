//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Nik on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalculatorBrain : NSObject {
    @private
    double operand;
    double waitingOperand;
    NSString *waitingOperation;
    NSMutableArray *expressionArray;
}

- (void)setOperand:(double)aDouble;
- (double)performOperation:(NSString *)operation;
- (void)setVariableAsOperand:(NSString *)variable;

@property (readonly) id expression;

+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables;

+ (NSSet *)variablesInExpression:(id)anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression;

+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;

@end
