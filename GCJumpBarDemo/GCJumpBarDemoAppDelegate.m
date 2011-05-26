//
//  GCJumpBarDemoAppDelegate.m
//  GCJumpBarDemo
//
//  Created by Guillaume Campagna on 11-05-24.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import "GCJumpBarDemoAppDelegate.h"
#import "NSIndexPath+GCJumpBar.h"

@implementation GCJumpBarDemoAppDelegate

@synthesize window;
@synthesize label;

- (void)jumpBar:(GCJumpBar *)jumpBar didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    label.stringValue = [NSString stringWithFormat:@"Index path : %@", indexPath.stringRepresentation];
}

@end
