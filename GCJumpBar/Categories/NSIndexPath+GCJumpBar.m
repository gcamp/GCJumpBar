//
//  NSIndexPath+GCJumpBar.m
//  GCJumpBarDemo
//
//  Created by Guillaume Campagna on 11-05-25.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import "NSIndexPath+GCJumpBar.h"

@implementation NSIndexPath (GCJumpBar)

- (NSString *)stringRepresentation {
    NSMutableString* reprensentation = [[NSMutableString alloc] initWithCapacity:[self length] * 2 - 1];
    [reprensentation appendFormat:@"%ld", (long)[self indexAtPosition:0]];
    
    for (NSUInteger position = 1; position < self.length ; position ++) {
        [reprensentation appendFormat:@".%ld", (long)[self indexAtPosition:position]];
    }
    
    return [reprensentation autorelease];
}

- (NSIndexPath*) indexPathByAddingIndexPath:(NSIndexPath*) indexPath {
    NSIndexPath* path = [[self copy] autorelease];
    for (NSUInteger position = 0; position < indexPath.length ; position ++) {
        path = [path indexPathByAddingIndex:[indexPath indexAtPosition:position]];
    }
    return path;
}

- (NSIndexPath *)indexPathByAddingIndexInFront:(NSUInteger)index {
    NSIndexPath* indexPath = [NSIndexPath indexPathWithIndex:index];
    return [indexPath indexPathByAddingIndexPath:self];
}

- (NSIndexPath *)subIndexPathFromPosition:(NSUInteger)position {
    return [self subIndexPathWithRange:NSMakeRange(position, self.length - position)];
}

- (NSIndexPath *)subIndexPathToPosition:(NSUInteger)position {
    return [self subIndexPathWithRange:NSMakeRange(0, position)];
}

- (NSIndexPath *)subIndexPathWithRange:(NSRange)range {
    NSIndexPath* path = [[[NSIndexPath alloc] init] autorelease];
    
    for (NSUInteger position = range.location; position < (range.location + range.length) ; position ++) {
        path = [path indexPathByAddingIndex:[self indexAtPosition:position]];
    }
    
    return path;
}

@end
