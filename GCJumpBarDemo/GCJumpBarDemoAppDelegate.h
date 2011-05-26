//
//  GCJumpBarDemoAppDelegate.h
//  GCJumpBarDemo
//
//  Created by Guillaume Campagna on 11-05-24.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCJumpBar.h"

@interface GCJumpBarDemoAppDelegate : NSObject <NSApplicationDelegate, GCJumpBarDelegate> {
    NSWindow *window;
    NSTextField *label;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *label;

@end
