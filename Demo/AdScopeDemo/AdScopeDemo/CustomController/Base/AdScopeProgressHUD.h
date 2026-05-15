//
//  AdScopeProgressHUD.h
//  AdScopeDemo
//
//  Created by Cookie on 2022/11/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class AdScopeBackgroundView;
@protocol AdScopeProgressHUDDelegate;

extern CGFloat const AdScopeProgressMaxOffset;

typedef NS_ENUM(NSInteger, AdScopeProgressHUDMode) {
    AdScopeProgressHUDModeIndeterminate,
    AdScopeProgressHUDModeDeterminate,
    AdScopeProgressHUDModeDeterminateHorizontalBar,
    AdScopeProgressHUDModeAnnularDeterminate,
    AdScopeProgressHUDModeCustomView,
    AdScopeProgressHUDModeText
};

typedef NS_ENUM(NSInteger, AdScopeProgressHUDAnimation) {
    AdScopeProgressHUDAnimationFade,
    AdScopeProgressHUDAnimationZoom,
    AdScopeProgressHUDAnimationZoomOut,
    AdScopeProgressHUDAnimationZoomIn
};

typedef NS_ENUM(NSInteger, AdScopeProgressHUDBackgroundStyle) {
    AdScopeProgressHUDBackgroundStyleSolidColor,
    AdScopeProgressHUDBackgroundStyleBlur
};

typedef void (^AdScopeProgressHUDCompletionBlock)(void);


NS_ASSUME_NONNULL_BEGIN

@interface AdScopeProgressHUD : UIView

+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;
+ (nullable AdScopeProgressHUD *)HUDForView:(UIView *)view NS_SWIFT_NAME(forView(_:));
- (instancetype)initWithView:(UIView *)view;
- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;
@property (weak, nonatomic) id<AdScopeProgressHUDDelegate> delegate;
@property (copy, nullable) AdScopeProgressHUDCompletionBlock completionBlock;
@property (assign, nonatomic) NSTimeInterval graceTime;
@property (assign, nonatomic) NSTimeInterval minShowTime;
@property (assign, nonatomic) BOOL removeFromSuperViewOnHide;
@property (assign, nonatomic) AdScopeProgressHUDMode mode;
@property (strong, nonatomic, nullable) UIColor *contentColor UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) AdScopeProgressHUDAnimation animationType UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) CGPoint offset UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) CGFloat margin UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) CGSize minSize UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic, getter = isSquare) BOOL square UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic, getter=areDefaultMotionEffectsEnabled) BOOL defaultMotionEffectsEnabled UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) float progress;
@property (strong, nonatomic, nullable) NSProgress *progressObject;
@property (strong, nonatomic, readonly) AdScopeBackgroundView *bezelView;
@property (strong, nonatomic, readonly) AdScopeBackgroundView *backgroundView;
@property (strong, nonatomic, nullable) UIView *customView;
@property (strong, nonatomic, readonly) UILabel *label;
@property (strong, nonatomic, readonly) UILabel *detailsLabel;
@property (strong, nonatomic, readonly) UIButton *button;

@end


@protocol AdScopeProgressHUDDelegate <NSObject>

@optional

- (void)hudWasHidden:(AdScopeProgressHUD *)hud;

@end

@interface AdScopeRoundProgressView : UIView

@property (nonatomic, assign) float progress;
@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, strong) UIColor *backgroundTintColor;
@property (nonatomic, assign, getter = isAnnular) BOOL annular;

@end

@interface AdScopeBarProgressView : UIView

@property (nonatomic, assign) float progress;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *progressRemainingColor;
@property (nonatomic, strong) UIColor *progressColor;

@end


@interface AdScopeBackgroundView : UIView

@property (nonatomic) AdScopeProgressHUDBackgroundStyle style;
@property (nonatomic) UIBlurEffectStyle blurEffectStyle;
@property (nonatomic, strong, nullable) UIColor *color;

@end

NS_ASSUME_NONNULL_END

