//
//  AdScopeDemoLogger.h
//  AdScopeDemo
//
//  Created by Cookie on 2023/6/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdScopeDemoLogger : NSObject

/** 单例初始化:需在窗口初始化好之后调用 */
+ (instancetype)sharedInstance;
/** 输出log日志 */
+ (void)log:(NSString *)format,...;

@property (nonatomic, assign) BOOL isOpenLog;

@property (nonatomic, assign) BOOL isAdd;

/** Log输出窗口上限 */
@property (nonatomic, assign) int logsCountLimit;
/** Log输出窗口字体 */
@property (nonatomic, strong) UIFont *logsFont;
/** Log输出窗口文本颜色 */
@property (nonatomic, strong) UIColor *logsTextColor;
/** Log输出窗口文本颜色(高亮) */
@property (nonatomic, strong) UIColor *logsTextColorHL;
/** Log输出窗口背景颜色 */
@property (nonatomic, strong) UIColor *logsBgColor;

/** 清空日志 */
+ (void)clear;
/** 显示开关 */
+ (void)show;
+ (void)hide;

@end

@interface AdScopeDemoLogView : UIView

/** 输出窗口 */
@property (nonatomic, weak) UITextView *textView;
/** log字体 */
@property (nonatomic, strong) UIFont *font;
/** log颜色 */
@property (nonatomic, strong) UIColor *textColor;
/** log颜色(高亮) */
@property (nonatomic, strong) UIColor *textColorHL;
/** 背景颜色 */
@property (nonatomic, strong) UIColor *bgColor;

@end

@interface AdScopeDemoLogModel : NSObject
/** 时间戳 */
@property (nonatomic, assign) double timestamp;
/** log */
@property (nonatomic, copy) NSString *log;

+ (instancetype)logWithText:(NSString*)text;

@end

NS_ASSUME_NONNULL_END
