//
//  GCJumpBar.m
//  GCJumpBarDemo
//
//  Created by Guillaume Campagna on 11-05-24.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import "GCJumpBar.h"
#import "GCJumpBarLabel.h"
#import "NSIndexPath+GCJumpBar.h"
#import "NSMenu+IndexPath.h"

const CGFloat GCJumpBarNormalHeight = 23.0;

@interface GCJumpBar () <GCJumpBarLabelDelegate>

- (void) performLayout;

- (GCJumpBarLabel*) labelAtLevel:(NSUInteger) level;
- (void) changeFontInMenu:(NSMenu*) subMenu;

@end

@implementation GCJumpBar

@synthesize delegate;
@synthesize menu;
@synthesize selectedIndexPath;
@synthesize changeFontInMenu;

- (id)initWithCoder:(NSCoder *)aDecoder {    
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSRect frame = self.frame;
        frame.size.height = GCJumpBarNormalHeight;
        self.frame = frame;
        
        self.changeFontInMenu = YES;
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)frameRect {
    return [self initWithFrame:frameRect menu:nil];
}

- (id) initWithFrame:(NSRect)frameRect menu:(NSMenu*) aMenu {
    frameRect.size.height = GCJumpBarNormalHeight;
    
    self = [super initWithFrame:frameRect];
    if (self) {
        self.menu = aMenu;
        self.changeFontInMenu = YES;
    }
    
    return self;
}

#pragma mark - Setters

- (void)setMenu:(NSMenu *)newMenu {
    if (newMenu != menu) {
        [menu release];
        menu = [newMenu retain];
        
        if (menu != nil && self.selectedIndexPath == nil) self.selectedIndexPath = [NSIndexPath indexPathWithIndex:0];
        if (self.changeFontInMenu) [self changeFontInMenu:self.menu];
    }
}

- (void)setSelectedIndexPath:(NSIndexPath *)newSelectedIndexPath {
    if (newSelectedIndexPath != selectedIndexPath) {
        [selectedIndexPath release];
        selectedIndexPath = [newSelectedIndexPath retain];
        
        [self performLayout];
        
        if ([self.delegate respondsToSelector:@selector(jumpBar:didSelectItemAtIndexPath:)]) {
            [self.delegate jumpBar:self didSelectItemAtIndexPath:self.selectedIndexPath];
        }
    }
}

- (void)setEnabled:(BOOL)flag {
    [super setEnabled:flag];
    
    for (NSControl* view in [self subviews]) {
        [view setEnabled:flag];
    }
    
    [self setNeedsDisplay];
}

#pragma mark - Layout

- (void)performLayout {    
    NSIndexPath* atThisPointIndexPath = [[[NSIndexPath alloc] init] autorelease];
    CGFloat baseX = 0;
    for (NSUInteger position = 0; position < self.selectedIndexPath.length ; position ++) {
        NSUInteger selectedIndex = [self.selectedIndexPath indexAtPosition:position];
        atThisPointIndexPath = [atThisPointIndexPath indexPathByAddingIndex:selectedIndex];
        
        GCJumpBarLabel* label = [self labelAtLevel:atThisPointIndexPath.length];
        
        NSMenuItem* item = [self.menu itemAtIndexPath:atThisPointIndexPath];
        label.text = item.title;
        label.image = item.image;
        label.indexInLevel = selectedIndex;
        
        [label sizeToFit];
        NSRect frame = [label frame];
        frame.origin.x = baseX;
        baseX += frame.size.width;
        label.frame = frame;
    }
    
    NSView* viewToRemove = nil;
    NSUInteger position = self.selectedIndexPath.length + 1;
    while ((viewToRemove = [self viewWithTag:position])) {
        [viewToRemove removeFromSuperview];
        position ++;
    }
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)dirtyRect {
    //Draw main gradient
    dirtyRect.size.height = self.bounds.size.height;
    dirtyRect.origin.y = 0;
    
    NSGradient* mainGradient = nil;
    if (!self.isEnabled || !self.window.isKeyWindow) mainGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.96 alpha:1.0] 
                                                                                                  endingColor:[NSColor colorWithCalibratedWhite:0.85 alpha:1.0]];
    else mainGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.85 alpha:1.0] 
                                                      endingColor:[NSColor colorWithCalibratedWhite:0.73 alpha:1.0]];
    [mainGradient drawInRect:dirtyRect angle:-90];
    [mainGradient release];  
    
    //Draw both stroke lines
    if (!self.isEnabled || !self.window.isKeyWindow) [[NSColor colorWithCalibratedWhite:0.5 alpha:1.0] set];
    else [[NSColor colorWithCalibratedWhite:0.33 alpha:1.0] set];
    
    dirtyRect.size.height = 1;
    NSRectFill(dirtyRect);
    
    dirtyRect.origin.y = self.frame.size.height - 1;
    NSRectFill(dirtyRect);
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    [super viewWillMoveToWindow:newWindow];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignKeyNotification object:self.window];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeKeyNotification object:self.window];
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    
    if (self.window != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay) name:NSWindowDidResignKeyNotification object:self.window];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay) name:NSWindowDidBecomeKeyNotification object:self.window];  
    }
}

#pragma mark - Helper

- (GCJumpBarLabel *)labelAtLevel:(NSUInteger)level {
    GCJumpBarLabel* label = [self viewWithTag:level];
    if (label == nil) {
        label = [[GCJumpBarLabel alloc] init];
        label.level = level;
        label.frame = NSMakeRect(0, 0, 0, self.frame.size.height);
        label.delegate = self;
        label.enabled = self.isEnabled;
        
        [self addSubview:label];
        [label release];
    }
    
    return label;
}

- (void) changeFontInMenu:(NSMenu*) subMenu {
    for (NSMenuItem* item in [subMenu itemArray]) {
        NSMutableAttributedString* attributedString = [[item attributedTitle] mutableCopy];
        if (attributedString == nil) attributedString = [[NSMutableAttributedString alloc] initWithString:item.title];
        [attributedString addAttributes:[NSDictionary dictionaryWithObject:[NSFont systemFontOfSize:12.0]
                                                                    forKey:NSFontAttributeName]
                                  range:NSMakeRange(0, attributedString.length)];
        [item setAttributedTitle:attributedString];
        [attributedString release];
        
        if ([item hasSubmenu]) [self changeFontInMenu:[item submenu]];
    }
}

#pragma mark - GCJumpBarLabelDelegate

- (NSMenu *)menuToPresentWhenClickedForJumpBarLabel:(GCJumpBarLabel *)label {    
    NSIndexPath* subIndexPath = [self.selectedIndexPath subIndexPathToPosition:label.level];
    
    return [[self.menu itemAtIndexPath:subIndexPath] menu];
}

- (void)jumpBarLabel:(GCJumpBarLabel *)label didReceivedClickOnItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath* subIndexPath = [self.selectedIndexPath subIndexPathToPosition:label.level - 1];
    self.selectedIndexPath = [subIndexPath indexPathByAddingIndexPath:indexPath];
}

@end
