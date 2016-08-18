//
//  DDStickerView.h
//  DDStickerView
//
//  Created by mac on 16/8/18.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDStickerView : UIView

/**
 *  添加贴纸
 *
 *  @param image 贴纸图像
 */
- (void)addStickerView:(UIImage*)image;

/**
 *  添加贴纸
 *
 *  @param image        贴纸图像
 *  @param point        贴纸中心
 *  @param stickerWidth 贴纸宽度
 */
- (void)addStickerView:(UIImage*)image atPoint:(CGPoint)point stickerWidth:(CGFloat)stickerWidth;

@end
