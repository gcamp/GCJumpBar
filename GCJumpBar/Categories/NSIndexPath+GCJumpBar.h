//
//  NSIndexPath+GCJumpBar.h
//  GCJumpBarDemo
//
//  Created by Guillaume Campagna on 11-05-25.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (GCJumpBar)

//Return a string of form @"1.2.3.4.5"
@property (nonatomic, readonly) NSString* stringRepresentation;

- (NSIndexPath*) indexPathByAddingIndexPath:(NSIndexPath*) indexPath;
- (NSIndexPath*) indexPathByAddingIndexInFront:(NSUInteger) index;

- (NSIndexPath*) subIndexPathFromPosition:(NSUInteger) position;
- (NSIndexPath*) subIndexPathToPosition:(NSUInteger) position;
- (NSIndexPath*) subIndexPathWithRange:(NSRange) range;

@end
