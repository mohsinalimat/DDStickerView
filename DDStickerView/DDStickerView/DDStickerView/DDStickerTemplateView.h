//
//  DDStickerTemplateView.h
//  DDStickerView
//
//  Created by mac on 16/8/18.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDStickerTemplateView : UIView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image;

/**
 *  显示/隐藏操作view
 *
 *  @param hidden 隐藏
 */
- (void)setOperateHidden:(BOOL)hidden;

@end
