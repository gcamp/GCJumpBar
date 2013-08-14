//
//  GCJumpBarLabel.m
//  GCJumpBarDemo
//
//  Created by Guillaume Campagna on 11-05-24.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import "GCJumpBarLabel.h"
#import "NSIndexPath+GCJumpBar.h"

const CGFloat GCJumpBarLabelMargin = 5.0;

const NSInteger GCJumpBarLabelAccessoryMenuLabelTag = -1;

@interface GCJumpBarLabel ()

@property (nonatomic, readonly) NSDictionary* attributes;
@property (nonatomic, retain) NSMenu* clickedMenu;

- (void)setPropretyOnMenu:(NSMenu *)menu;

@end

@implementation GCJumpBarLabel

@synthesize image, text, lastLabel;
@synthesize indexInLevel, clickedMenu;
@synthesize delegate = delegate;

#pragma mark - View subclass

- (void)sizeToFit {
    [super sizeToFit];
    
    CGFloat width = (2 + (self.image != nil)) * GCJumpBarLabelMargin;
    
    NSSize textSize = [self.text sizeWithAttributes:self.attributes];
    width += ceil(textSize.width);
    width += ceil(self.image.size.width);
    if (!self.lastLabel) width += 7; //Separator image
    
    NSRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

#pragma mark - Getter/Setters

- (CGFloat)minimumWidth {
    return GCJumpBarLabelMargin + self.image.size.width + (self.image != nil) * GCJumpBarLabelMargin + (!self.lastLabel) * 7;
}

- (void)setImage:(NSImage *)newImage {
    if (image != newImage) {
        [image release];
        image = [newImage retain];
        
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)newText {
    if (text != newText) {
        [text release];
        text = [newText retain];
        
        [self setNeedsDisplay];
    }
}

- (NSUInteger)level {
    return self.tag;
}

- (void)setLevel:(NSUInteger)level {
    self.tag = level;
}

#pragma mark - Delegate

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.isEnabled) {
        self.clickedMenu = [self.delegate menuToPresentWhenClickedForJumpBarLabel:self];
        [self setPropretyOnMenu:self.clickedMenu];
        
        CGFloat xPoint = (self.tag == GCJumpBarLabelAccessoryMenuLabelTag ? - 9 : - 16);
        
        [self.clickedMenu popUpMenuPositioningItem:[self.clickedMenu itemAtIndex:self.indexInLevel] 
                                        atLocation:NSMakePoint(xPoint , self.frame.size.height - 4) inView:self];  
    }
}

- (void) menuClicked:(id) sender {
    NSMenuItem* item = sender;
    NSIndexPath* indexPath = [[[NSIndexPath alloc] init] autorelease];
    
    if (self.tag != GCJumpBarLabelAccessoryMenuLabelTag) {
        while (![[self.clickedMenu itemArray] containsObject:item]) {
            indexPath = [indexPath indexPathByAddingIndexInFront:[[item menu] indexOfItem:item]];
            item = [item parentItem];
        }  
    }
    indexPath = [indexPath indexPathByAddingIndexInFront:[[item menu] indexOfItem:item]];
    
    [self.delegate jumpBarLabel:self didReceivedClickOnItemAtIndexPath:indexPath];
    
    self.clickedMenu = nil;
}

#pragma mark - Dawing

- (void)drawRect:(NSRect)dirtyRect {
    CGFloat baseLeft = 0;
    
    if (self.tag == GCJumpBarLabelAccessoryMenuLabelTag) {
        NSImage* separatorImage = [NSImage imageNamed:@"GCJumpBarAccessorySeparator"];
        [separatorImage drawAtPoint:NSMakePoint(baseLeft + 1, self.frame.size.height / 2 - separatorImage.size.height / 2)
                           fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];  
        baseLeft += separatorImage.size.width + GCJumpBarLabelMargin;
    }
    else baseLeft = GCJumpBarLabelMargin; 
    
    if (self.image != nil) {
        int top = 0;
        if (self.isFlipped)
            top = floor(self.frame.size.height / 2 + self.image.size.height / 2);
        else
            top = floor(self.frame.size.height / 2 - self.image.size.height / 2);
        [self.image drawInRect:NSMakeRect(baseLeft, floor(self.frame.size.height / 2 - self.image.size.height / 2), self.image.size.width, self.image.size.height)
                       fromRect:NSZeroRect
                      operation:NSCompositeSourceOver
                      fraction:1.0
                respectFlipped:YES
                         hints:nil];
        baseLeft += ceil(self.image.size.width) + GCJumpBarLabelMargin;
    }
    
    if (self.text != nil) {
        NSSize textSize = [self.text sizeWithAttributes:self.attributes];
        CGFloat width = self.frame.size.width - baseLeft - GCJumpBarLabelMargin;
        if (!self.lastLabel && self.tag != GCJumpBarLabelAccessoryMenuLabelTag) width -= 7;
        
        if (width > 0) {
            [self.text drawInRect:CGRectMake(baseLeft, self.frame.size.height / 2 - textSize.height / 2
                                             , width, textSize.height) 
                   withAttributes:self.attributes];
            baseLeft += width + GCJumpBarLabelMargin;  
        }
    }
    
    if (!self.lastLabel && self.tag != GCJumpBarLabelAccessoryMenuLabelTag) {
        NSImage* separatorImage = [NSImage imageNamed:@"GCJumpBarSeparator"];
        [separatorImage drawAtPoint:NSMakePoint(baseLeft, self.frame.size.height / 2 - separatorImage.size.height / 2)
                           fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];  
    }
}

#pragma mark - Helper

- (NSDictionary *)attributes {
    NSShadow* highlightShadow = [[NSShadow alloc] init];
    highlightShadow.shadowOffset = CGSizeMake(0, -1.0);
    highlightShadow.shadowColor = [NSColor colorWithCalibratedWhite:1.0 alpha:0.5];
    highlightShadow.shadowBlurRadius = 0.0;
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    
    NSDictionary* attributes = [[NSDictionary alloc] initWithObjectsAndKeys:[NSColor blackColor], NSForegroundColorAttributeName,
                                highlightShadow, NSShadowAttributeName,
                                [NSFont systemFontOfSize:12.0], NSFontAttributeName ,
                                style, NSParagraphStyleAttributeName, nil];
    [highlightShadow release];
    [style release];
    
    return [attributes autorelease];
}

- (void)setPropretyOnMenu:(NSMenu *)menu {
    for (NSMenuItem* item in [menu itemArray]) {
        if (item.isEnabled) {
            [item setTarget:self];
            [item setAction:@selector(menuClicked:)];  
            if ([item hasSubmenu]) [self setPropretyOnMenu:item.submenu];  
        }
    }
}

@end
