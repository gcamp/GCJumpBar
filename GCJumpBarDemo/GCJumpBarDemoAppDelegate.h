//
//  GCJumpBarDemoAppDelegate.h
//  GCJumpBarDemo
//
//  Created by Guillaume Campagna on 11-05-24.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCJumpBar.h"

@interface GCJumpBarDemoAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
