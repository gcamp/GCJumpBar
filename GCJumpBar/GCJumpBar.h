//
//  GCJumpBar.h
//  GCJumpBarDemo
//
//  Created by Guillaume Campagna on 11-05-24.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GCJumpBarDelegate;

@interface GCJumpBar : NSControl

@property (nonatomic, assign) IBOutlet id<GCJumpBarDelegate> delegate;

@property (nonatomic, retain) IBOutlet NSMenu* menu;
@property (nonatomic, retain) NSIndexPath* selectedIndexPath;

 //Change automatically the font in the menu to be the same as the Jump Bar and resize the image to 16x16
@property (nonatomic, assign) BOOL changeFontAndImageInMenu;

- (id) initWithFrame:(NSRect)frameRect menu:(NSMenu*) aMenu;

@end

@protocol GCJumpBarDelegate <NSObject>

@optional
- (void) jumpBar:(GCJumpBar*) jumpBar didSelectItemAtIndexPath:(NSIndexPath*) indexPath;

@end