//
//  Ship.h
//  MacKookos
//
//  Created by Riku Erkkilä on 13.9.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MovableObject.h"



typedef enum  {
    goToIn, goASAP, stopASAP, goASAP2, goASAP3, manual
} Action;

@interface Ship : MovableObject
{
    Action action;
    CGFloat timeLeft;
}

@property BOOL engineBurn;
@property CGPoint target;
@property CGPoint velocity;
@property CGPoint debugVec;
@property CGPoint debugVec2;

@property CGFloat maxRotation;
@property CGFloat maxAcceleration;

- (void) update:(CGFloat)dt;
- (void) autoPilot:(CGFloat)dt;
- (void) goTo:(CGPoint)target in:(CGFloat)t;
- (void) goASAPto:(CGPoint)target;
- (void) goASAP2to:(CGPoint)target;
- (void) goASAP3to:(CGPoint)target;
- (void) stop;


@end
