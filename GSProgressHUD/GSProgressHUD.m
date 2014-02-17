// GSProgressHUD.m
//
// Copyright (c) 2014 Gard Sandholt
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GSProgressHUD.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat const kHUDWidth = 70.f;
static CGFloat const kHUDHeight = 66.f;

@interface GSProgressHUD ()

@property(nonatomic, strong) UIImageView *statusIcon;
@property(nonatomic, strong) UILabel *statusLabel;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;

- (void)showType:(GSProgressHUDViewType)viewType;
- (void)dismiss;
- (void)popImage:(UIImage *)image withStatus:(NSString *)status;
- (void)showImage:(UIImage *)image withStatus:(NSString *)status;

@end

@implementation GSProgressHUD


+ (GSProgressHUD *)sharedView {
    static GSProgressHUD *sharedView;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedView = [[GSProgressHUD alloc] initWithFrame:CGRectMake(0.f, 0.f, kHUDWidth, kHUDHeight)];
        sharedView.currentHUDType = GSProgressHUDViewTypeIndicator;
    });
    return sharedView;
}

+ (void)popImage:(UIImage *)image withStatus:(NSString *)status {
    [[GSProgressHUD sharedView] popImage:image withStatus:status];
}

+ (void)showImage:(UIImage *)image withStatus:(NSString *)status {
    [[GSProgressHUD sharedView] showImage:image withStatus:status];
}

+ (void)show {
    [[GSProgressHUD sharedView] showType:GSProgressHUDViewTypeIndicator];
}

+ (void)dismiss {
    [[GSProgressHUD sharedView] dismiss];
}

+ (BOOL)isVisible {
    return ([GSProgressHUD sharedView].alpha == 1.f);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.alpha = 0.f;
        self.layer.cornerRadius = 8.f;
        self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:.75f];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.f, 5.f);
        self.layer.shadowRadius = 10.f;
        self.layer.shadowOpacity = .7f;
    }
    
    return self;
}

- (void)showType:(GSProgressHUDViewType)viewType {
    if (!self.superview) {
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self];
                break;
            }
        }
    }
    
    self.center = CGPointMake(self.superview.frame.size.width/2.f, self.superview.frame.size.height/2.f);
    
    // Clear previous added views
    if (self.statusIcon.superview) {
        [self.statusIcon removeFromSuperview];
    }
    if (self.statusLabel.superview) {
        [self.statusLabel removeFromSuperview];
    }
    if (self.activityView.superview) {
        [self.activityView removeFromSuperview];
    }
    
    // Set view type views
    switch (viewType) {
        case GSProgressHUDViewTypeIndicator:
            if (!self.activityView.superview) {
                [self addSubview:self.activityView];
            }
            break;
        case GSProgressHUDViewTypeIcon:
            if (!self.statusIcon.superview) {
                [self addSubview:self.statusIcon];
            }
            if (!self.statusLabel.superview) {
                [self addSubview:self.statusLabel];
            }
            break;
    }
    
    // Show view
    if (self.alpha != 1.f) {
        
        self.transform = CGAffineTransformScale(self.transform, .7f, .7f);
        
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.transform = CGAffineTransformScale(self.transform, 1.f/.7f, 1.f/.7f);
                             self.alpha = 1.f;
                         } completion:nil];
    }
}

- (void)popImage:(UIImage *)image withStatus:(NSString *)status {
    [self showImage:image withStatus:status];
    
    double delayInSeconds = 0.55;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self dismiss];
    });
}

- (void)showImage:(UIImage *)image withStatus:(NSString *)status {
    
    self.statusIcon.image = image;
    self.statusLabel.text = status;
    
    if (![GSProgressHUD isVisible]) {
        [self showType:GSProgressHUDViewTypeIcon];
    }
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 1.3f, 1.3f);
                         self.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         
                         self.transform = CGAffineTransformScale(self.transform, 1.f/1.3f, 1.f/1.3f);
                     }];
    
}

- (UIImageView *)statusIcon {
    if (!_statusIcon) {
        _statusIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, (kHUDHeight/2.f)-17.f, 20.f, 20.f)];
        _statusIcon.center = CGPointMake(kHUDWidth/2.f, _statusIcon.center.y);
        _statusIcon.backgroundColor = [UIColor clearColor];
        _statusIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _statusIcon;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.f, kHUDHeight-21.f, kHUDWidth-5.f, 10.f)];
        _statusLabel.center = CGPointMake(kHUDWidth/2.f, _statusLabel.center.y);
        _statusLabel.font = [UIFont boldSystemFontOfSize:10.f];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _statusLabel;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = CGPointMake(kHUDWidth/2.f, kHUDHeight/2.f);
        [_activityView startAnimating];
    }
    return _activityView;
}

@end
