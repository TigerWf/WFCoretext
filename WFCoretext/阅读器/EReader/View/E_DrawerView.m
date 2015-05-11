//
//  E_DrawerView.m
//  WFReader
//
//  Created by 吴福虎 on 15/2/15.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import "E_DrawerView.h"
#import "UIImage+ImageEffects.h"
#define ListViewW (3* self.frame.size.width/4)

@implementation E_DrawerView

- (id)initWithFrame:(CGRect)frame parentView:(UIView *)p{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.parent = p;
        self.alpha = 0;
        UIImage *background = [self blurredSnapshot];
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.image = background;
        [self addSubview:backgroundView];
        
       
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDrawView)];
        tapGes.delegate = self;
        [self addGestureRecognizer:tapGes];
        
         [self configUI];
        
      }
    return self;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint touchPoint = [touch locationInView:self];
    CGRect blurRect = CGRectMake(ListViewW, 0, self.frame.size.width - ListViewW, self.frame.size.height);
    if (CGRectContainsPoint(blurRect, touchPoint)) {
        return YES;
    }else{
        return NO;
    }
    
}


- (void)hideDrawView{
   
    [UIView animateWithDuration:0.25 animations:^{
         _listView.frame = CGRectMake(-ListViewW, 0, ListViewW, self.frame.size.height);
         self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_listView removeFromSuperview];
        _listView = nil;
        [_delegate openTapGes];
        [self removeFromSuperview];
    }];
    

}

- (void)removeE_ListView{
    
    [_listView removeFromSuperview];
    _listView = nil;
    [_delegate openTapGes];
    [self removeFromSuperview];

}

- (void)configUI{

    if (_listView == nil) {
        
        _listView = [[E_ListView alloc] initWithFrame:CGRectMake(- ListViewW, 0, ListViewW, self.frame.size.height)];
        _listView.delegate = self;
        [self addSubview:_listView];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _listView.frame = CGRectMake(0, 0, ListViewW, self.frame.size.height);
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        
       
        
    }else{
    
    
    }
    
    
}

- (void)clickMark:(E_Mark *)eMark{
   
    [UIView animateWithDuration:0.25 animations:^{
        _listView.frame = CGRectMake(-ListViewW, 0, ListViewW, self.frame.size.height);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_listView removeFromSuperview];
        _listView = nil;
        [_delegate openTapGes];
        [_delegate turnToClickMark:eMark];
        [self removeFromSuperview];
    }];

}

- (void)clickChapter:(NSInteger)chaperIndex{
    
    [UIView animateWithDuration:0.25 animations:^{
        _listView.frame = CGRectMake(-ListViewW, 0, ListViewW, self.frame.size.height);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_listView removeFromSuperview];
        _listView = nil;
        [_delegate openTapGes];
         [_delegate turnToClickChapter:chaperIndex];
        [self removeFromSuperview];
    }];
   
}

- (UIImage *)blurredSnapshot {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.parent.frame), CGRectGetHeight(self.parent.frame)), NO, 1.0f);
    [self.parent drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.parent.frame), CGRectGetHeight(self.parent.frame)) afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    
    
    UIGraphicsEndImageContext();
    
    return blurredSnapshotImage;
}

@end
