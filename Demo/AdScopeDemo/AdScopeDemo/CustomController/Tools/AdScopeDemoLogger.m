//
//  AdScopeDemoLogger.m
//  AdScopeDemo
//
//  Created by Cookie on 2023/6/9.
//

#import "AdScopeDemoLogger.h"
#import "AdScopeDemoMacro.h"

@class AdScopeDemoLogModel;
@class AdScopeDemoLogView;

@interface AdScopeDemoLogger () {
    CGFloat _logWidth, _logHeight, _logX, _logY;
    CGFloat _btnWidth, _btnHeight, _btnX, _btnY;
    NSMutableArray *_logs;
}

@property (nonatomic, weak) AdScopeDemoLogView *logView;

@property (nonatomic, weak) UIButton *actionBtn;

@end

@implementation AdScopeDemoLogger

+ (instancetype)sharedInstance {
    static AdScopeDemoLogger *log = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        log = [AdScopeDemoLogger new];
    });
    return log;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _logs = [NSMutableArray array];
        _logsFont = [UIFont systemFontOfSize:10];
        _logsTextColor = [UIColor whiteColor];
        _logsTextColorHL = [UIColor yellowColor];
        _logsBgColor = [UIColor clearColor];
        _logsCountLimit = 10000;
        _logWidth = [[UIScreen mainScreen] bounds].size.width;
        _logHeight = 300;
        _logX = 0;
        _logY = [[UIScreen mainScreen] bounds].size.height-300;
        _btnWidth = 40;
        _btnHeight = 20;
        _btnX = [[UIScreen mainScreen] bounds].size.width-40;
        _btnY = [[UIScreen mainScreen] bounds].size.height-300;
    }
    return self;
}

- (void)setupContent {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect logFrame = CGRectMake(_logX, _logY, _logWidth, _logHeight);
    AdScopeDemoLogView *logView = [[AdScopeDemoLogView alloc]initWithFrame:logFrame];
    logView.font = _logsFont;
    [logView.layer setCornerRadius:10];
    logView.textColor = _logsTextColor;
    logView.textColorHL = _logsTextColorHL;
    logView.bgColor = _logsBgColor;
    [keyWindow addSubview:logView];
    self.logView = logView;
    
    CGRect actionBtnFrame = CGRectMake(_btnX, _btnY, _btnWidth, _btnHeight);
    UIButton *actionBtn = [self buttonWithFrame:actionBtnFrame
                                     titleColor:[UIColor whiteColor]
                                          title:@""];
    [actionBtn setTitle:@"Logs"
               forState:UIControlStateNormal];
    [actionBtn setTitleColor:[UIColor blackColor]
                    forState:UIControlStateNormal];
    [actionBtn setTitle:@"Close"
               forState:UIControlStateSelected];
    [actionBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateSelected];
    [actionBtn setSelected:NO];
    [actionBtn addTarget:self action:@selector(onCLickActionBtn:)
                    forControlEvents:UIControlEventTouchUpInside];
    [keyWindow addSubview:actionBtn];
    self.actionBtn = actionBtn;
    
    CGRect clearBtnFrame = CGRectMake(0, 0, _btnWidth, _btnHeight);
    UIColor *titleColor = [UIColor whiteColor];
    UIButton *clearBtn = [self buttonWithFrame:clearBtnFrame
                                    titleColor:titleColor
                                         title:@"Clear"];
    [clearBtn addTarget:self action:@selector(clear)
               forControlEvents:UIControlEventTouchUpInside];
    [logView addSubview:clearBtn];
    
    [self hide];
}

+ (void)show {
    if ([AdScopeDemoLogger sharedInstance].isOpenLog) {
        if (![AdScopeDemoLogger sharedInstance].isAdd) {
            [AdScopeDemoLogger sharedInstance].isAdd = YES;
            [[AdScopeDemoLogger sharedInstance] setupContent];
        }
        [[AdScopeDemoLogger sharedInstance] show];
    }
}

+ (void)hide {
    if ([AdScopeDemoLogger sharedInstance].isOpenLog) {
        [[AdScopeDemoLogger sharedInstance] hide];
    }
}

+ (void)log:(NSString*)format,... {
    if ([AdScopeDemoLogger sharedInstance].isOpenLog) {
        va_list argptr;
        va_start(argptr, format);
        NSString *text = [[NSString alloc]initWithFormat:format arguments:argptr];
        va_end(argptr);
        [[AdScopeDemoLogger sharedInstance] log:text];
    }
}

+ (void)clear {
    if ([AdScopeDemoLogger sharedInstance].isOpenLog) {
        [[AdScopeDemoLogger sharedInstance] clear];
    }
}

- (void)show {
    [self.logView setHidden:NO];
    [self.logView setUserInteractionEnabled:YES];
    
    [self.actionBtn setSelected:YES];
    [self.actionBtn setBackgroundColor:[UIColor clearColor]];
    [self.actionBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)hide {
    [self.logView setHidden:YES];
    [self.logView setUserInteractionEnabled:NO];
    
    [self.actionBtn setSelected:NO];
    [self.actionBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.7]];
    [self.actionBtn.layer setBorderColor:[UIColor blackColor].CGColor];
}

- (void)log:(NSString*)newLog {
    if (!newLog.length) {
        return;
    }
    
    @synchronized (self) {
        newLog = [NSString stringWithFormat:@">> %@ %@\n", [self localDate], newLog];
        AdScopeDemoLogModel *logModel = [AdScopeDemoLogModel logWithText:newLog];
        [_logs addObject:logModel];
        if (_logs.count > _logsCountLimit) {
            [_logs removeObjectAtIndex:0];
        }
        
        [self refreshLogDisplay];
    }
}

- (void)clear {
    self.logView.textView.text = @"";
    _logs = [NSMutableArray array];
}

#pragma mark - ClickEvent
- (void)onCLickActionBtn:(UIButton*)button {
    !button.selected ? [self show] : [self hide];
}

#pragma mark - Get/Set
- (void)setLogsFont:(UIFont *)logsFont {
    _logsFont = logsFont;
    self.logView.font = logsFont;
}

- (void)setLogsTextColor:(UIColor *)logsTextColor {
    _logsTextColor = logsTextColor;
    self.logView.textColor = logsTextColor;
}

- (void)setLogsTextColorHL:(UIColor *)logsTextColorHL {
    _logsTextColorHL = logsTextColorHL;
    self.logView.textColorHL = logsTextColorHL;
}

- (void)setLogsBgColor:(UIColor *)logsBgColor {
    _logsBgColor = logsBgColor;
    self.logView.bgColor = logsBgColor;
}

- (void)refreshLogDisplay {
    NSMutableAttributedString* attributedString = [NSMutableAttributedString new];
    
    double currentTimestamp = [[NSDate date] timeIntervalSince1970];
    for (AdScopeDemoLogModel* logModel in _logs) {
        if (!logModel.log.length) {
            return;
        }
        
        NSMutableAttributedString* logString = [[NSMutableAttributedString alloc] initWithString:logModel.log];
        UIColor* logColor = (currentTimestamp - logModel.timestamp) > 0.1 ? _logsTextColor : _logsTextColorHL;
        [logString addAttribute:NSForegroundColorAttributeName value:logColor range:NSMakeRange(0, logString.length)];
        
        [attributedString appendAttributedString:logString];
    }
    
    self.logView.textView.attributedText = attributedString;
    
    if(attributedString.length > 0) {
        NSRange bottom = NSMakeRange(attributedString.length - 1, 1);
        [self.logView.textView scrollRangeToVisible:bottom];
    }
}

- (UIButton*)buttonWithFrame:(CGRect)frame titleColor:(UIColor*)titleColor title:(NSString*)title {
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:frame.size.height/2];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor:titleColor.CGColor];
    return button;
}

- (NSString*)localDate {
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

@end


@implementation AdScopeDemoLogView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
        CGRect textViewFrame = self.bounds;
        textViewFrame.origin.y += 25;
        textViewFrame.size.height -= 25;
        
        UITextView *textView = [[UITextView alloc]initWithFrame:textViewFrame];
        [textView setBackgroundColor:self.bgColor];
        [textView setTextColor:self.textColor];
        [textView setFont:self.font];
        [textView setEditable:NO];
        [self addSubview:textView];
        self.textView = textView;
    }
    return self;
}

#pragma mark - Get/Set
- (void)setFont:(UIFont *)font {
    _font = font;
    self.textView.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textView.textColor = textColor;
}

- (void)setTextColorHL:(UIColor *)textColorHL {
    _textColorHL = textColorHL;
    self.textView.textColor = textColorHL;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.textView.backgroundColor = bgColor;
}

@end

@implementation AdScopeDemoLogModel

+ (instancetype)logWithText:(NSString*)logText {
    AdScopeDemoLogModel *logModel = [AdScopeDemoLogModel new];
    logModel.timestamp = [[NSDate date] timeIntervalSince1970];
    logModel.log = logText;
    return logModel;
}

@end
