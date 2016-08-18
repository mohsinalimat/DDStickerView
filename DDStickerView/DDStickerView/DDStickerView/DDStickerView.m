//
//  DDStickerView.m
//  DDStickerView
//
//  Created by mac on 16/8/18.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import "DDStickerView.h"
#import "DDStickerTemplateView.h"

@implementation DDStickerView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure{
    [self setBackgroundColor:[UIColor clearColor]];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutside:)]];
}

- (void)touchOutside:(UITapGestureRecognizer *)touchGesture
{
    [self hideAllStickerViewBorder];
}

/**
 *  添加贴纸
 *
 *  @param image 贴纸图像
 */
- (void)addStickerView:(UIImage*)image{
    [self addStickerView:image atPoint:self.center stickerWidth:self.frame.size.width/3];
}

/**
 *  添加贴纸
 *
 *  @param image        贴纸图像
 *  @param point        贴纸中心
 *  @param stickerWidth 贴纸宽度
 */
- (void)addStickerView:(UIImage*)image atPoint:(CGPoint)point stickerWidth:(CGFloat)stickerWidth{
    DDStickerTemplateView *v = [[DDStickerTemplateView alloc]initWithFrame:CGRectMake(0, 0, stickerWidth, 0) image:image];
    v.center = point;
    [self addSubview:v];
}

/**
 *  隐藏所有贴纸的边框
 */
- (void)hideAllStickerViewBorder{
    for (int i = 0; i < self.subviews.count; i++) {
        DDStickerTemplateView *v = self.subviews[i];
        if ([v isKindOfClass:[DDStickerTemplateView class]]) {
            [v setOperateHidden:YES];
        }
    }
}

/**
 *  移除所有贴纸
 */
- (void)removeAllStickerView{
    for (int i = 0; i < self.subviews.count; i++) {
        DDStickerTemplateView *v = self.subviews[i];
        if ([v isKindOfClass:[DDStickerTemplateView class]]) {
            [v removeFromSuperview];
        }
    }
}

@end
