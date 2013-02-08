//
//  HelloWorldLayer.m
//  MacKookos
//
//  Created by Riku Erkkilä on 31.8.2012.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import <Carbon/Carbon.h>

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		pauseLabel = [CCLabelTTF labelWithString:@"Paused" fontName:@"Marker Felt" fontSize:16];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		pauseLabel.position =  ccp( 100 , size.height-20 );
		
		// add the label as a child to this Layer
		[self addChild: pauseLabel];
        pauseLabel.visible = NO;
        
        
        ship = [[Ship alloc] init];
        ship.position  = ccp(100.0,100.0);
        ship.velocity = ccp(50.0, 20.0);
        
        redShip = [[Ship alloc] init];
        redShip.position  = ccp(120.0,100.0);
        redShip.velocity = ccp(50.0, 20.0);


        
        rocket = [CCSprite spriteWithFile:@"rocket.png"];
        [self addChild:rocket];
        rocketBurn = [CCSprite spriteWithFile:@"rocket_burn.png"];
        [self addChild:rocketBurn];
        target = [CCSprite spriteWithFile:@"x.png"];
        [self addChild:target];
    

        redRocket = [CCSprite spriteWithFile:@"red_rocket.png"];
        [self addChild:redRocket];
        redRocketBurn = [CCSprite spriteWithFile:@"red_rocket_burn.png"];
        [self addChild:redRocketBurn];

        
        // schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
        
        self.isKeyboardEnabled = YES;
        self.isMouseEnabled = YES;
        
        turnLenght = 3.0;
        timeLeft= turnLenght;
        paused = NO;
        
      //  NSLog(@"%f", angleDifference(3.14, 3.5));

    
	}
	return self;
}

- (void) nextFrame:(ccTime)dt {
    

    
    if (paused)
        return;
    
    evenFrame = ! evenFrame;
    
    if (leftKeyHeld)
        ship.rotation += 3.1 * dt;
    
    
    if (rightKeyHeld)
        ship.rotation -= 3.1 * dt;
    
    if (upKeyHeld)
        ship.engineBurn = YES;

    /*
    if (leftKeyHeld)
    {
        ship.position = ccp( 300,300 );
        redShip.position = ccp( 300,300 );
        ship.velocity = ccp (-100,-50);
        redShip.velocity = ccp (-100,-50);
        ship.rotation = -1.0;
        redShip.rotation = -1.0;
    }*/
    
    
    [redShip goASAP3to:ship.position ];
    
    //[redShip goTo:target.position in:1.0];

    [ship update:dt];
    [redShip update:dt];
    
    
    
    
    if (ship.engineBurn && evenFrame)
    {
        rocket.visible = NO;
        rocketBurn.visible = YES;
    }
    else
    {
        rocket.visible = YES;
        rocketBurn.visible = NO;
    }
  
    if (redShip.engineBurn)// && evenFrame)
    {
        redRocket.visible = NO;
        redRocketBurn.visible = YES;
    }
    else
    {
        redRocket.visible = YES;
        redRocketBurn.visible = NO;
    }
    

    rocket.position = ship.position;
    rocket.rotation = -CC_RADIANS_TO_DEGREES(ship.rotation);
    rocketBurn.position = ship.position;
    rocketBurn.rotation =  -CC_RADIANS_TO_DEGREES(ship.rotation);

    redRocket.position = redShip.position;
    redRocket.rotation = -CC_RADIANS_TO_DEGREES(redShip.rotation);
    redRocketBurn.position = redShip.position;
    redRocketBurn.rotation =  -CC_RADIANS_TO_DEGREES(redShip.rotation);

    
    timeLeft -= dt;

/*
    if (timeLeft < 0.0)
    {
        paused = YES;
        pauseLabel.visible = YES;
        timeLeft = turnLenght;

    }*/
}






- (BOOL)ccKeyDown:(NSEvent*)keyDownEvent
{
    UInt16 keyCode = [keyDownEvent keyCode];
 	
	if (keyCode == kVK_ANSI_W)
        upKeyHeld = YES;
	if (keyCode == kVK_ANSI_D)
        rightKeyHeld = YES;
    if (keyCode == kVK_ANSI_A)
        leftKeyHeld = YES;
    if (keyCode == kVK_Space)
    {
        spaceKeyHeld = YES;
        
        paused = !paused;
        timeLeft = turnLenght;
        pauseLabel.visible = NO;
    }
    
    return YES;

}

- (BOOL)ccKeyUp:(NSEvent*)keyUpEvent
{
	UInt16 keyCode = [keyUpEvent keyCode];

 	
	if (keyCode == kVK_ANSI_W)
        upKeyHeld = NO;
	if (keyCode == kVK_ANSI_D)
        rightKeyHeld = NO;
    if (keyCode == kVK_ANSI_A)
        leftKeyHeld = NO;
    if (keyCode == kVK_Space)
        spaceKeyHeld = NO;
    
    return YES;
    
}

-(BOOL)ccMouseDown:(NSEvent *)event {
    
    CGPoint clickLocation = [[CCDirector sharedDirector] convertEventToGL:event];
    CGPoint newTarget = ccp( clickLocation.x, clickLocation.y );
    target.position = newTarget;
    //[ship goASAP2to:newTarget ];
    //[redShip goASAP3to:newTarget ];
    
    
    
    timeLeft = turnLenght;
   // paused = NO;
    
    
    return YES;
}

-(void)draw
{
    glEnable(GL_LINE_SMOOTH);
    ccDrawColor4F(1.0, 0.0, 0.0, 1.0);
    ccDrawLine( redShip.position, ccpAdd(redShip.position, redShip.velocity) );
    ccDrawColor4F(0.0, 1.0, 0.0, 1.0);
    ccDrawLine( redShip.position, ccpAdd(redShip.position, redShip.debugVec) );
    ccDrawColor4F(0.0, 0.0, 1.0, 1.0);
    ccDrawLine( redShip.position, ccpAdd(redShip.position, redShip.debugVec2) );
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end




