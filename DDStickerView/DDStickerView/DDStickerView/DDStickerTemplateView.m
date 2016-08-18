//
//  DDStickerTemplateView.m
//  DDStickerView
//
//  Created by mac on 16/8/18.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import "DDStickerTemplateView.h"

#define INSET 10.f

CG_INLINE CGPoint CGRectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CG_INLINE CGRect CGRectScale(CGRect rect, CGFloat wScale, CGFloat hScale)
{
    return CGRectMake(rect.origin.x * wScale, rect.origin.y * hScale, rect.size.width * wScale, rect.size.height * hScale);
}

CG_INLINE CGFloat CGPointGetDistance(CGPoint point1, CGPoint point2)
{
    //Saving Variables.
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);
    
    return sqrt((fx*fx + fy*fy));
}

CG_INLINE CGFloat CGAffineTransformGetAngle(CGAffineTransform t)
{
    return atan2(t.b, t.a);
}

@interface DDStickerTemplateView ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *rotateBtn;

@end

@implementation DDStickerTemplateView{
    CGRect _initialBounds;
    CGFloat _initialDistance;
    CGPoint _beginningPoint;
    CGPoint _beginningCenter;
    CGPoint _prevPoint;
    CGPoint _touchLocation;
    CGFloat _deltaAngle;
    CGAffineTransform _startTransform;
    CGRect _beginBounds;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image{
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, (frame.size.width - 2 * INSET) / (image.size.width/image.size.height) + 2 *INSET)];
    if (self) {
        self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(INSET, INSET, self.frame.size.width - 2*INSET, self.frame.size.height - 2*INSET)];
        self.bgImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.bgImageView.layer.borderWidth = 1;
        self.bgImageView.userInteractionEnabled = YES;
        self.bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.bgImageView.image = image;
        [self addSubview:self.bgImageView];
        
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeBtn.frame = CGRectMake(0, 0, INSET*2, INSET*2);
        [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"DDStickerView.bundle/CLOSE.png"] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeBtn];
        
        self.rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rotateBtn.frame = CGRectMake(self.frame.size.width - INSET*2, self.frame.size.height - INSET*2, INSET*2, INSET*2);
        [self.rotateBtn setBackgroundImage:[UIImage imageNamed:@"DDStickerView.bundle/RESIZE.png"] forState:UIControlStateNormal];
        self.rotateBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.rotateBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick:)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *move = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveViewGesture:)];
        [self addGestureRecognizer:move];
        
        UIPanGestureRecognizer *rotate = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(rotateViewPanGesture:)];
        [self.rotateBtn addGestureRecognizer:rotate];
    }
    
    return self;
}

- (void)closeClick:(UIButton*)sender{
    [self removeFromSuperview];
}

- (void)moveViewGesture:(UIPanGestureRecognizer *)recognizer{
    
    [self setOperateHidden:NO];
    
    _touchLocation = [recognizer locationInView:self.superview];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _beginningPoint = _touchLocation;
        _beginningCenter = self.center;
        
        [self setCenter:CGPointMake(_beginningCenter.x+(_touchLocation.x-_beginningPoint.x), _beginningCenter.y+(_touchLocation.y-_beginningPoint.y))];
        
        _beginBounds = self.bounds;
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self setCenter:CGPointMake(_beginningCenter.x+(_touchLocation.x-_beginningPoint.x), _beginningCenter.y+(_touchLocation.y-_beginningPoint.y))];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self setCenter:CGPointMake(_beginningCenter.x+(_touchLocation.x-_beginningPoint.x),_beginningCenter.y+(_touchLocation.y-_beginningPoint.y))];
        
    }
    
    _prevPoint = _touchLocation;
}

- (void)rotateViewPanGesture:(UIPanGestureRecognizer *)recognizer{
    
    _touchLocation = [recognizer locationInView:self.superview];
    
    CGPoint center = CGRectGetCenter(self.frame);
    
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        _deltaAngle = atan2(_touchLocation.y-center.y, _touchLocation.x-center.x)-CGAffineTransformGetAngle(self.transform);
        
        _initialBounds = self.bounds;
        _initialDistance = CGPointGetDistance(center, _touchLocation);
        
    } else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        float ang = atan2(_touchLocation.y-center.y, _touchLocation.x-center.x);
        
        float angleDiff = _deltaAngle - ang;
        [self setTransform:CGAffineTransformMakeRotation(-angleDiff)];
        
        //Finding scale between current touchPoint and previous touchPoint
        double scale = sqrtf(CGPointGetDistance(center, _touchLocation)/_initialDistance);
        
        CGRect scaleRect = CGRectScale(_initialBounds, scale, scale);
        [self setBounds:scaleRect];
        
        [self setNeedsDisplay];
        
    } else if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
    }
}

- (void)viewClick:(UITapGestureRecognizer*)sender{
    [self setOperateHidden:NO];
}

/**
 *  显示/隐藏操作view
 *
 *  @param hidden 隐藏
 */
- (void)setOperateHidden:(BOOL)hidden{
    if (hidden) {
        self.bgImageView.layer.borderWidth = 0;
        self.closeBtn.hidden = YES;
        self.rotateBtn.hidden = YES;
    }else{
        self.bgImageView.layer.borderWidth = 1;
        self.closeBtn.hidden = NO;
        self.rotateBtn.hidden = NO;
    }
}
@end
