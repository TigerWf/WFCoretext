//
//  CDSideBarController.h
//  CDSideBar
//
//  Created by Christophe Dellac on 9/11/14.
//  Copyright (c) 2014 Christophe Dellac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  change by tiger --
 */
@protocol CDSideBarControllerDelegate <NSObject>

- (void)menuButtonClicked:(int)index;
- (void)changeGestureRecognizers;

@end

@interface CDSideBarController : NSObject
{
    UIView              *_backgroundMenuView;
    UIButton            *_menuButton;
    NSMutableArray      *_buttonList;
}

@property (nonatomic, strong) UIView *backgroundMenuView;
@property (nonatomic, retain) UIColor *menuColor;
@property (nonatomic) BOOL isOpen;
@property (nonatomic, retain) UITapGestureRecognizer *singleTap;
@property (nonatomic, retain) id<CDSideBarControllerDelegate> delegate;

- (CDSideBarController*)initWithImages:(NSArray*)buttonList;
- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position;
- (void)showMenu;

@end
