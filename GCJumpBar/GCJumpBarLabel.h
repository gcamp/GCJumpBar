//
//  GCJumpBarLabel.h
//  GCJumpBarDemo
//
//  Created by Guillaume Campagna on 11-05-24.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol GCJumpBarLabelDelegate;

@interface GCJumpBarLabel : NSControl

@property (nonatomic, retain) NSImage* image;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, getter = isLastLabel) BOOL lastLabel;

@property (nonatomic, assign) NSUInteger indexInLevel;
@property (nonatomic, assign) NSUInteger level;

@property (nonatomic, readonly) CGFloat minimumWidth;

@property (nonatomic, assign) id<GCJumpBarLabelDelegate> delegate;

@end

@protocol GCJumpBarLabelDelegate <NSObject>

- (NSMenu*) menuToPresentWhenClickedForJumpBarLabel:(GCJumpBarLabel*) label;
- (void) jumpBarLabel:(GCJumpBarLabel*) label didReceivedClickOnItemAtIndexPath:(NSIndexPath*) indexPath;

@end
