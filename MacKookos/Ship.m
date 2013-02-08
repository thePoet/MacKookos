//
//  Ship.m
//  MacKookos
//
//  Created by Riku Erkkilä on 13.9.2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Ship.h"


@implementation Ship

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _maxRotation = 3.1;
        _maxAcceleration = 100.0;

        action = manual;
    }
    
    return self;
}

- (void) update:(CGFloat)dt
{
    timeLeft -= dt;
    if (action==manual)
        [self manualSteering:dt];
    else
        [self autoPilot:dt];
        
    self.position = ccpAdd( self.position, ccpMult(_velocity, dt) );
}


- (void) goTo:(CGPoint)target in:(CGFloat)t
{
    action = goToIn;
    _target = target;
    timeLeft = t;
}

- (void) goASAPto:(CGPoint)target
{
    action = goASAP;
    _target = target;
}

- (void) goASAP2to:(CGPoint)target
{
    action = goASAP2;
    _target = target;
}
- (void) goASAP3to:(CGPoint)target
{
    action = goASAP3;
    _target = target;
}

- (void) manualSteering:(CGFloat)dt
{
    
    if (_engineBurn)
    {
        CGPoint velInc = ccpMult( ccpForAngle(self.rotation), _maxAcceleration*dt );
        _velocity = ccpAdd(_velocity, velInc);
    }
 
}

- (void) autoPilot:(CGFloat)dt
{
    _engineBurn = NO;

    if ( action == stopASAP )
    {
        [self stopAsap:dt];
        return;
    }
    if ( action == goASAP )
   {
        [self goAsap:dt];
        return;
    }
    if ( action == goASAP2 )
    {
        [self goAsap2:dt];
        return;
    }
    if ( action == goASAP3 )
    {
        [self goAsap3:dt];
        return;
    }
    
    
/*
    CGPoint endPoint = ccpMult(_velocity, timeLeft);
    CGPoint toTarget = ccpSub( _target, self.position );
    CGPoint errorVec = ccpSub( toTarget, endPoint );

    
    if ( ccpLength(errorVec) > 4.0 )
    {
        CGFloat targetAngle = ccpToAngle ( errorVec );
        
        CGFloat angDif = angleDifference( targetAngle , self.rotation );
        
        if (fabsf(angDif) < _maxRotation*dt )
        {
            self.rotation = targetAngle;
        }
        else
        {
            if (angDif < 0)
                self.rotation = addAngles(self.rotation, -_maxRotation*dt);
            if (angDif > 0)
                self.rotation = addAngles(self.rotation, _maxRotation*dt);
        }
        
        
        
        CGPoint velInc = ccpMult( ccpForAngle(self.rotation), min( _maxAcceleration*dt, ccpLength(errorVec) ));
        
        //   if ( ccpLength(errorVec) > ccpLength(newErrorVec) )

        if (fabsf(self.rotation - targetAngle) < 0.0001)
            _engineBurn = YES;
        
        if (_engineBurn)
        {
            _velocity = ccpAdd(_velocity, velInc);
        }
    }
   */
}

- (void) goAsap:(CGFloat)dt
{

    CGPoint toTarget = ccpSub( _target, self.position );
    
    CGPoint goodVelocity = ccpProject(_velocity, toTarget);
    CGPoint badVelocity = ccpSub(_velocity, goodVelocity);
        
    
    CGFloat angleToTarget = ccpToAngle ( toTarget );
    CGFloat velocityAngle = ccpToAngle ( _velocity );
    CGFloat vtAngDif = angleDifference( angleToTarget , velocityAngle );
    
    CGFloat targetAngle = angleToTarget;
    
        
    if ( ccpLength(badVelocity) > 0.01)
    {
        if (vtAngDif <= 0)
        {
            targetAngle = angleToTarget - M_PI / 2.0;
        }
        else
        {
            targetAngle = angleToTarget + M_PI / 2.0;
        }
    }
    
        CGFloat angDif = angleDifference( targetAngle , self.rotation );
    
        if (fabsf(angDif) < _maxRotation*dt )
        {
            self.rotation = targetAngle;
        }
        else
        {
            if (angDif < 0)
                self.rotation = addAngles(self.rotation, -_maxRotation*dt);
            if (angDif > 0)
                self.rotation = addAngles(self.rotation, _maxRotation*dt);
        }
        
        CGPoint velInc = ccpMult( ccpForAngle(self.rotation), _maxAcceleration*dt );
    
         
        if ( ccpLength(badVelocity) > 0.01 )
        {
          if ( ccpLength(badVelocity) < ccpLength(ccpProject(velInc, badVelocity)) )
          {
            velInc = ccpMult( velInc, ccpLength(badVelocity) / ccpLength(ccpProject(velInc, badVelocity) ) );
          }
        }
 
        
        if (fabsf(self.rotation - targetAngle) < 0.0001)
            _engineBurn = YES;
        
        if (_engineBurn)
        {
            _velocity = ccpAdd(_velocity, velInc);
        }
}

- (void) goAsap2:(CGFloat)dt
{
    CGPoint toTarget = ccpSub( _target, self.position );
    
    CGPoint goodVelocity = ccpProject(_velocity, toTarget);
    CGPoint badVelocity = ccpSub(_velocity, goodVelocity);
    
    
    CGFloat angleToTarget = ccpToAngle ( toTarget );
    CGFloat velocityAngle = ccpToAngle ( _velocity );
    
    if ( ccpLength(_velocity) < 0.001)
        velocityAngle = angleToTarget;
    
    
    CGFloat ad = angleDifference( angleToTarget, velocityAngle );
    if ( ad > M_PI/2.0 )
        ad = M_PI - ad;
    if ( ad < -M_PI/2.0 )
        ad = -M_PI - ad;
    
    CGFloat optimalAngle = angleToTarget + ad;
    
    
    CGFloat targetAngle = optimalAngle;
    
    
    
    CGFloat angDif = angleDifference( targetAngle , self.rotation );
    
    if (fabsf(angDif) < _maxRotation*dt )
    {
        self.rotation = targetAngle;
    }
    else
    {
        if (angDif < 0)
            self.rotation = addAngles(self.rotation, -_maxRotation*dt);
        if (angDif > 0)
            self.rotation = addAngles(self.rotation, _maxRotation*dt);
    }
    
    CGPoint velInc = ccpMult( ccpForAngle(self.rotation), _maxAcceleration*dt );
    
    /*
    if ( ccpLength(badVelocity) > 0.01 )
    {
        if ( ccpLength(badVelocity) < ccpLength(ccpProject(velInc, badVelocity)) )
        {
            velInc = ccpMult( velInc, ccpLength(badVelocity) / ccpLength(ccpProject(velInc, badVelocity) ) );
        }
    }
    */
    
    
    //NSLog(@"JUU %f", ccpLength(badVelocity) );
    
    //    if (fabsf(self.rotation - targetAngle) < 0.0001)
    //    _engineBurn = YES;
    
    //if ( newErrorAngle <= errorAngle || errorAngle < 0.01 )
    //      _engineBurn = YES;
    
    
    CGPoint newVelocity = ccpAdd(_velocity, velInc);
    CGPoint newGoodVelocity = ccpProject(newVelocity, toTarget);
    CGPoint newBadVelocity = ccpSub(newVelocity, newGoodVelocity);
    CGPoint goodVelInc = ccpProject(velInc, toTarget);
    
    
    
    
    _debugVec = toTarget;
    
    _debugVec2 = ccpMult( ccpForAngle(optimalAngle), 200);
    
    //NSLog( @"EA: %f", errorAngle);
    
    if (  ( ccpLength(newBadVelocity) <= ccpLength(badVelocity) || ccpLength(newBadVelocity) < 0.001 ) &&
        
        vecAngle( goodVelInc, toTarget ) < 0.1 )
        //fabsf(errorAngle) < 0.01  )
    {
        _engineBurn = YES;
    }
    
    if (_engineBurn)
    {
        _velocity = ccpAdd(_velocity, velInc);
    }
}
- (void) goAsap3:(CGFloat)dt
{
    CGPoint toTarget = ccpSub( _target, self.position );
    
    CGPoint goodVelocity = ccpProject(_velocity, toTarget);
    CGPoint badVelocity = ccpSub(_velocity, goodVelocity);
    
    
    CGFloat angleToTarget = ccpToAngle ( toTarget );
    CGFloat velocityAngle = ccpToAngle ( _velocity );
    
    if ( ccpLength(_velocity) < 0.001)
        velocityAngle = angleToTarget;
    
    
    CGFloat ad = angleDifference( angleToTarget, velocityAngle );
    if ( ad > M_PI/2.0 )
        ad = M_PI - ad;
    if ( ad < -M_PI/2.0 )
        ad = -M_PI - ad;
    
    CGFloat optimalAngle = angleToTarget + ad*0.75;
    
    
    CGFloat targetAngle = optimalAngle;
    
    
    
    CGFloat angDif = angleDifference( targetAngle , self.rotation );
    
    if (fabsf(angDif) < _maxRotation*dt )
    {
        self.rotation = targetAngle;
    }
    else
    {
        if (angDif < 0)
            self.rotation = addAngles(self.rotation, -_maxRotation*dt);
        if (angDif > 0)
            self.rotation = addAngles(self.rotation, _maxRotation*dt);
    }
    
    CGPoint velInc = ccpMult( ccpForAngle(self.rotation), _maxAcceleration*dt );
    
    
/*    if ( ccpLength(badVelocity) > 0.01 )
    {
        if ( ccpLength(badVelocity) < ccpLength(ccpProject(velInc, badVelocity)) )
        {
            velInc = ccpMult( velInc, ccpLength(badVelocity) / ccpLength(ccpProject(velInc, badVelocity) ) );
        }
    }
  */  
    
    
    //NSLog(@"JUU %f", ccpLength(badVelocity) );
    
    //    if (fabsf(self.rotation - targetAngle) < 0.0001)
    //    _engineBurn = YES;
    
    //if ( newErrorAngle <= errorAngle || errorAngle < 0.01 )
    //      _engineBurn = YES;
    
    
    CGPoint newVelocity = ccpAdd(_velocity, velInc);
    CGPoint newGoodVelocity = ccpProject(newVelocity, toTarget);
    CGPoint newBadVelocity = ccpSub(newVelocity, newGoodVelocity);
    CGPoint goodVelInc = ccpProject(velInc, toTarget);
    
 
    
    
    _debugVec = toTarget;
    
    _debugVec2 = ccpMult( ccpForAngle(optimalAngle), 200);
    
    //NSLog( @"EA: %f", errorAngle);
    
    if (  ( ccpLength(newBadVelocity) <= ccpLength(badVelocity) || ccpLength(newBadVelocity) < 0.001 ) &&
        
        vecAngle( goodVelInc, toTarget ) < 0.1 )
        //fabsf(errorAngle) < 0.01  )
    {
        _engineBurn = YES;
    }
    
    if (_engineBurn)
    {
        _velocity = ccpAdd(_velocity, velInc);
    }
}

- (void) stopAsap:(CGFloat)dt
{
    
    CGPoint errorVec = ccpNeg(_velocity);
    CGFloat targetAngle = ccpToAngle ( errorVec );
        
    CGFloat angDif = angleDifference( targetAngle , self.rotation );
        
        if (fabsf(angDif) < _maxRotation*dt )
        {
            self.rotation = targetAngle;
        }
        else
        {
            if (angDif < 0)
                self.rotation = addAngles(self.rotation, -_maxRotation*dt);
            if (angDif > 0)
                self.rotation = addAngles(self.rotation, _maxRotation*dt);
        }
        
        
        
        CGPoint velInc = ccpMult( ccpForAngle(self.rotation), min( _maxAcceleration*dt, ccpLength(errorVec) ));
        
        
        if (fabsf(self.rotation - targetAngle) < 0.0001)
            _engineBurn = YES;
        
        if (_engineBurn)
        {
            _velocity = ccpAdd(_velocity, velInc);
        }
    
}


CGFloat fixAngle(CGFloat angle)
{
    while (angle >= 2*M_PI )
        angle -= 2*M_PI;
    while (angle < 0 )
        angle += 2*M_PI;
    
    return angle;
}


CGFloat angleDifference(CGFloat angle1, CGFloat angle2)
{
    
    CGFloat angDif = angle1 - angle2;
    
    if ( angDif >  M_PI)
    {
        angDif -= 2*M_PI;
    }
    if ( angDif <  -M_PI)
    {
        angDif += 2*M_PI;
    }
    
    return angDif;
}


CGFloat vecAngle(CGPoint vec1, CGPoint vec2)
{

    CGFloat angle = angleDifference(ccpToAngle(vec1), ccpToAngle(vec2));
    
    //ccpAngleSigned( ccpNormalize(vec1), ccpNormalize(vec2) );
   /*
    if ( angle >  M_PI/2.0)
    {
        angle -= 2*M_PI;
    }
    if ( angle <  -M_PI/2.0)
    {
        angle += 2*M_PI;
    }
    */
    NSLog( @"VVVV: %f %f     %f %f      %f ",vec1.x,vec1.y,vec2.x,vec2.y, angle);
 
    return angle;
}

CGFloat addAngles(CGFloat angle1, CGFloat angle2)
{
    return fixAngle(angle1 + angle2);
}

    
@end
