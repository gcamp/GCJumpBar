//
//  NSMenu+IndexPath.m
//  GCJumpBarDemo
//
//  Created by Guillaume Campagna on 11-05-25.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import "NSMenu+IndexPath.h"

@implementation NSMenu (IndexPath)

- (NSMenuItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSMenu* menu = self;
    for (NSUInteger position = 0; position < indexPath.length - 1 ; position ++) {
        menu = [[menu itemAtIndex:[indexPath indexAtPosition:position]] submenu];
    }
    
    return [menu itemAtIndex:[indexPath indexAtPosition:indexPath.length - 1]];
}

@end
