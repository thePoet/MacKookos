//
//  AppDelegate.h
//  MacKookos
//
//  Created by Riku Erkkilä on 31.8.2012.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"

@interface MacKookosAppDelegate : NSObject <NSApplicationDelegate>
{
	NSWindow	*window_;
	CCGLView	*glView_;
}

@property (assign) IBOutlet NSWindow	*window;
@property (assign) IBOutlet CCGLView	*glView;

- (IBAction)toggleFullScreen:(id)sender;

@end
