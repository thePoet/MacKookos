//
//  HelloWorldLayer.h
//  MacKookos
//
//  Created by Riku Erkkilä on 31.8.2012.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Ship.h"


// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    Ship* ship;
    Ship* redShip;
    
    CCSprite* rocket;
    CCSprite* rocketBurn;
    CCSprite* redRocket;
    CCSprite* redRocketBurn;
    CCSprite* target;
    
    CCLabelTTF* pauseLabel;
    
    BOOL upKeyHeld;
    BOOL leftKeyHeld;
    BOOL rightKeyHeld;
    BOOL spaceKeyHeld;
    
    
    BOOL evenFrame;
    
    BOOL paused;
    
    CGFloat turnLenght;
    CGFloat timeLeft;
    
   // CGPoint rocketPos;
    //CGPoint velocity;
    //CGFloat rocketRot;

    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
