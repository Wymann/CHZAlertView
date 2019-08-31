//
//  CHZAlertView.m
//  TclIntelliCom
//
//  Created by Wymann Chan on 2019/8/24.
//  Copyright © 2019 tcl. All rights reserved.
//

#import "CHZAlertView.h"
#import "CHZTextTool.h"
#import "UITextView+Placeholder.h"
#import "CHZPickerModel.h"

#define KeyWindow [UIApplication sharedApplication].keyWindow
#define ALERT_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width //手机屏幕宽
#define ALERT_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height //手机屏幕高
#define BackStartColor [UIColor colorWithWhite:0.2 alpha:0]
#define BackFinalColor [UIColor colorWithWhite:0.2 alpha:0.7]
#define ButtonTitleColor [UIColor whiteColor]
#define ButtonBackColor [UIColor lightGrayColor]

static const CGFloat leftGap = 15.0;//左边间距
static const CGFloat rightGap = 15.0;//右边间距
static const CGFloat topGap = 15.0;//上边间距
static const CGFloat bottomGap = 15.0;//下边间距
static const CGFloat vGap = 10.0;//垂直视图之间的间距
static const CGFloat hGap = 10.0;//水平视图之间的间距
static const CGFloat iconViewWidth = 80.0;//顶部icon宽高
static const CGFloat titleFont = 16.0;//标题字体大小
static const CGFloat infoFont = 14.0;//描述文本字体大小
static const CGFloat buttonFont = 14.0;//按钮字体大小
static const CGFloat textFont = 14.0;//TextFiel和TextView字体大小
static const CGFloat textFieldHeight = 35.0;//TextField高度
static const CGFloat textViewHeight = 80.0;//TextView高度
static const CGFloat buttonHeight = 35.0;//按钮高度
static const CGFloat cornerRadius = 5.0;//圆角
static const NSInteger MaxButtonNum = 4;//最大按钮个数
static const CGFloat pickerCellHeight = 40.0;//选择器Cell高度
static const CGFloat maxTableViewHeight = 200.0;//pickerTableView 最大高度
static const CGFloat pickerFont = 14.0;//pickerCell字体大小

@interface CHZAlertView()<UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

/** 配置数据 */
@property (nonatomic, strong) CHZAlertSetup *setup;
/** 主内容视图 */
@property (nonatomic, strong) UIView *contentView;
/** 顶部icon */
@property (nonatomic, strong) UIView *topIcon;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 描述 */
@property (nonatomic, strong) UILabel *infoLabel;
/** textField */
@property (nonatomic, strong) UITextField *textField;
/** textView */
@property (nonatomic, strong) UITextView *textView;
/** imageView */
@property (nonatomic, strong) UIImageView *imageView;
/** pickerTableView */
@property (nonatomic, strong) UITableView *pickerTableView;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 计时器倒数 */
@property (assign, nonatomic) NSInteger timeCount;
/** 初始位置 */
@property (nonatomic) CGRect startRect;
/** 最后位置 */
@property (nonatomic) CGRect finalRect;
/** 主内容视图宽 */
@property (nonatomic) CGFloat contentViewWidth;
/** 主内容视图高 */
@property (nonatomic) CGFloat contentViewHeight;
/** 选择器数据源 */
@property (nonatomic, strong) NSMutableArray <CHZPickerModel *>*pickerModelArray;
/** UITextField 和 UITextView 输入的内容 */
@property (nonatomic, copy) NSString *inputText;
/** 选择器选择的字符串 */
@property (nonatomic, strong) NSMutableArray <NSString *>*pickedStringsArray;

@end

@implementation CHZAlertView

#pragma mark - Public
/** 初始化 */
-(instancetype)initWithAlertSetup:(CHZAlertSetup *)setup {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ALERT_SCREEN_WIDTH, ALERT_SCREEN_HEIGHT);
        [KeyWindow addSubview:self];
        _setup = setup;
        [self analyseAlertSetup];
        [self showAlertView];
        
        //tap
        UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapClick)];
        closeTap.delegate = self;
        [self addGestureRecognizer:closeTap];
        self.userInteractionEnabled = YES;
    }
    return self;
}

/** 点击空白处 */
- (void)closeTapClick {
    if (_textField.isFirstResponder) {
        [_textField resignFirstResponder];
        return;
    }
    
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
        return;
    }
    
    if (self.setup.sideTap) {
        [self closeAlertView];
    }
}

/** 弹出 */
- (void)showAlertView {
    [self addNotifications];
    
    [UIView animateWithDuration:0.3 animations:^{
        self. backgroundColor = BackFinalColor;
    }];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.contentView.frame = self.finalRect;
    }completion:^(BOOL finished) {
        if (self.setup.countDownTimer > 0) {
            self.timeCount = self.setup.countDownTimer;
            [self timer];
        }
        if (self.showBlock) {
            self.showBlock();
        }
    }];
}

/** 关闭 */
- (void)closeAlertView {
    [self removeNotifications];
    [self invalidateTimer];
    
    CGFloat time = 0.3;
    if (self.setup.animationType == ShowAnimationType_None) {
        time = 0.0;
    }
    [UIView animateWithDuration:time animations:^{
        self.backgroundColor = BackStartColor;
        self.contentView.frame = self.startRect;
        if (self.setup.animationType == ShowAnimationType_Fade) {
            self.contentView.alpha = 0.0;
        }
    }completion:^(BOOL finished) {
        while (self.contentView.subviews.count) {
            [self.contentView.subviews.lastObject removeFromSuperview];
        }
        while (self.subviews.count) {
            [self.subviews.lastObject removeFromSuperview];
        }
        [self removeFromSuperview];
        if (self.hideBlock) {
            self.hideBlock(self.inputText, self.pickedStringsArray);
        }
    }];
}

#pragma mark - Notifications
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideAction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardShowAction:(NSNotification*)sender{
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardHeight = [value CGRectValue].size.height;
    if (CGRectGetMaxY(self.finalRect) > (ALERT_SCREEN_HEIGHT - keyBoardHeight)) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect newRect = self.finalRect;
            newRect.origin.y = ALERT_SCREEN_HEIGHT - keyBoardHeight - CGRectGetHeight(self.finalRect);
            self.contentView.frame = newRect;
        }];
    }
}

- (void)keyboardHideAction:(NSNotification*)sender{
    if (_textView) {
        self.inputText = _textView.text;
    }
    if (_textField) {
        self.inputText = _textField.text;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = self.finalRect;
    }];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private
/** 解析配置数据 */
- (void)analyseAlertSetup {
    self.contentViewWidth = ALERT_SCREEN_WIDTH * 3.5 / 5;
    self.contentViewWidth = self.contentViewWidth > 270.0 ? 270.0 : self.contentViewWidth;
    CGFloat startY = [self createCommonSubviews];
     switch (self.setup.alertType) {
        case AlertViewType_Normal:{
            startY = [self createNormalSubviewsWithStartY:startY];
        }
            break;
        case AlertViewType_TextField:
            startY = [self createTextFieldSubviewsWithStartY:startY];
            break;
        case AlertViewType_TextView:
            startY = [self createTextViewSubviewsWithStartY:startY];
            break;
        case AlertViewType_Image:{
            startY = [self createImageSubviewsWithStartY:startY];
        }
            break;
        case AlertViewType_Picker:{
            [self changePickerStringToPickerModel];
            startY = [self createPickerSubviewsWithStartY:startY];
        }
            break;
        default:
            break;
    }
    
    //buttons
    if (self.setup.buttonItemArray.count > 0) {
        CGFloat allButtonsHeight = [self setupButtonsWithY:startY];
        startY += allButtonsHeight;
        startY += bottomGap;
    }
    self.contentViewHeight = startY;
    
    self.finalRect = CGRectMake((ALERT_SCREEN_WIDTH - self.contentViewWidth)/2, (ALERT_SCREEN_HEIGHT - self.contentViewHeight)/2, self.contentViewWidth, self.contentViewHeight);
    self.backgroundColor = BackStartColor;
    switch (self.setup.animationType) {
        case ShowAnimationType_None:{
            self.startRect = self.finalRect;
            self.backgroundColor = BackFinalColor;
        }
            break;
        case ShowAnimationType_FromTop:{
            self.startRect = CGRectMake(CGRectGetMinX(self.finalRect), -CGRectGetHeight(self.finalRect), self.contentViewWidth, self.contentViewHeight);
        }
            break;
        case ShowAnimationType_FromLeft:{
            self.startRect = CGRectMake(-CGRectGetWidth(self.finalRect), CGRectGetMinY(self.finalRect), self.contentViewWidth, self.contentViewHeight);
        }
            break;
        case ShowAnimationType_FromBottom:{
            CGFloat Y;
            if (self.setup.icon) {
                Y = ALERT_SCREEN_HEIGHT + CGRectGetHeight(self.topIcon.frame)/2;
            } else {
                Y = ALERT_SCREEN_HEIGHT;
            }
            self.startRect = CGRectMake(CGRectGetMinX(self.finalRect), Y, self.contentViewWidth, self.contentViewHeight);
        }
            break;
        case ShowAnimationType_FromRight:{
            self.startRect = CGRectMake(ALERT_SCREEN_WIDTH + CGRectGetWidth(self.finalRect), CGRectGetMinY(self.finalRect), self.contentViewWidth, self.contentViewHeight);
        }
            break;
        case ShowAnimationType_Fade:{
            self.startRect = self.finalRect;
        }
            break;
        default:
            break;
    }
    
    self.contentView.frame = self.startRect;
    [self addSubview:self.contentView];
}

#pragma mark - Data
- (void)changePickerStringToPickerModel {
    self.pickedStringsArray = [NSMutableArray arrayWithArray:self.setup.pickedStringsArray];
    self.pickerModelArray = [NSMutableArray array];
    for (NSString *string in self.setup.allStringsArray) {
        if (string) {
            CHZPickerModel *model = [[CHZPickerModel alloc] init];
            model.string = string;
            if ([self.setup.pickedStringsArray containsObject:string]) {
                model.picked = YES;
            }
            [self.pickerModelArray addObject:model];
        }
    }
}

#pragma mark - Main UI
/** 通用 UI */
- (CGFloat)createCommonSubviews {
    CGFloat startY = topGap;
    if (self.setup.icon) {
        [self setupTopIcon];
        startY = CGRectGetHeight(self.topIcon.frame)/2;
    }
    
    //titleLabel
    if (self.setup.title.length > 0) {
        [self setupTitleLabelWithY:startY];
        startY += CGRectGetHeight(self.titleLabel.frame);
        startY += vGap;
    }
    //informationLabel
    if (self.setup.information.length > 0) {
        [self setupInfoLabelWithY:startY];
        startY += CGRectGetHeight(self.infoLabel.frame);
        startY += vGap;
    }
    return startY;
}

/** AlertViewType_Normal 相关 UI */
- (CGFloat)createNormalSubviewsWithStartY:(CGFloat)startY {
    return startY;
}

/** AlertViewType_TextField 相关 UI */
- (CGFloat)createTextFieldSubviewsWithStartY:(CGFloat)startY {
    //textField
    self.textField.frame = CGRectMake(leftGap, startY, self.contentViewWidth - leftGap - rightGap, textFieldHeight);
    CGRect frame = _textField.frame;
    frame.size.width = 10.0;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = leftview;
    [self.contentView addSubview:self.textField];
    startY += textFieldHeight;
    startY += (vGap * 2);
    return startY;
}

/** AlertViewType_TextView 相关 UI */
- (CGFloat)createTextViewSubviewsWithStartY:(CGFloat)startY {
    //textView
    CGFloat height = textViewHeight;
    if (self.setup.textViewHeight > 0) {
        height = self.setup.textViewHeight;
    }
    self.textView.frame = CGRectMake(leftGap, startY, self.contentViewWidth - leftGap - rightGap, height);
    [self.contentView addSubview:self.textView];
    startY += height;
    startY += (vGap * 2);
    return startY;
}

/** AlertViewType_Image 相关 UI */
- (CGFloat)createImageSubviewsWithStartY:(CGFloat)startY {
    //imageView
    if (self.setup.image) {
        CGFloat imageViewWidth = self.contentViewWidth - leftGap - rightGap;
        CGFloat imageWidth = self.setup.image.size.width;
        CGFloat imageHeight = self.setup.image.size.height;
        CGFloat imageViewHeight = imageHeight * imageViewWidth / imageWidth;
        self.imageView.frame = CGRectMake(leftGap, startY, imageViewWidth, imageViewHeight);
        self.imageView.image = self.setup.image;
        [self.contentView addSubview:self.imageView];
        startY += imageViewHeight;
        startY += (vGap * 2);
    }
    return startY;
}

/** AlertViewType_Picker 相关 UI */
- (CGFloat)createPickerSubviewsWithStartY:(CGFloat)startY {
    //tableView
    if (self.pickerModelArray.count > 0) {
        CGFloat height;
        if (self.setup.pickerCellHeight > 0) {
            height = self.setup.pickerCellHeight * self.pickerModelArray.count;
        } else {
            height = pickerCellHeight * self.pickerModelArray.count;
        }
        height = height > maxTableViewHeight ? maxTableViewHeight : height;
        self.pickerTableView.frame = CGRectMake(leftGap, startY, self.contentViewWidth - leftGap - rightGap, height);
        [self.contentView addSubview:self.pickerTableView];
        startY += height;
        startY += (vGap * 2);
    }
    return startY;
}

#pragma mark - common UI
/** 设置topIcon 位置 */
- (void)setupTopIcon {
    CGFloat X = (self.contentViewWidth - iconViewWidth)/2;
    CGFloat Y = -iconViewWidth/2;
    self.topIcon.frame = CGRectMake(X, Y, iconViewWidth, iconViewWidth);
    self.topIcon.layer.cornerRadius = iconViewWidth/2;
    self.topIcon.clipsToBounds = YES;
    [self.contentView addSubview:self.topIcon];
    
    CGFloat roundGap = 4.0;
    CGFloat width = iconViewWidth - roundGap * 2;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(roundGap, roundGap, width, width)];
    iconImageView.image = self.setup.icon;
    iconImageView.layer.cornerRadius = width/2;
    iconImageView.clipsToBounds = YES;
    [self.topIcon addSubview:iconImageView];
}

/** 设置titleLabel 位置 */
- (void)setupTitleLabelWithY:(CGFloat)Y {
    CGFloat titleWidth = self.contentViewWidth - leftGap - rightGap;
    CGFloat titleHeight = [CHZTextTool getTextHeightWithText:self.setup.title width:titleWidth font:self.titleLabel.font] + 10.0;
    self.titleLabel.frame = CGRectMake(leftGap, Y, titleWidth, titleHeight);
    [self.contentView addSubview:self.titleLabel];
}

/** 设置infoLabel 位置 */
- (void)setupInfoLabelWithY:(CGFloat)Y {
    CGFloat infoWidth = self.contentViewWidth - leftGap - rightGap;
    CGFloat infoHeight = [CHZTextTool getTextHeightWithText:self.setup.information width:infoWidth font:self.infoLabel.font] + 10.0;
    self.infoLabel.frame = CGRectMake(leftGap, Y, infoWidth, infoHeight);
    [self.contentView addSubview:self.infoLabel];
}

/** 设置按钮数组 */
- (CGFloat)setupButtonsWithY:(CGFloat)Y {
    CGFloat height = 0;
    NSInteger buttonNum = self.setup.buttonItemArray.count > MaxButtonNum ? MaxButtonNum : self.setup.buttonItemArray.count;
    if (self.setup.buttonsShowType == ButtonsShowType_Horizontal) {
        height = buttonHeight;
        
        CGFloat buttonWidth = (self.contentViewWidth - leftGap - rightGap - hGap * (buttonNum - 1)) / (CGFloat )buttonNum;
        CGFloat startX = leftGap;
        for (NSInteger i = 0; i < buttonNum; i++) {
            CHZAlertButtonItem *item = self.setup.buttonItemArray[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.cornerRadius = cornerRadius;
            button.layer.masksToBounds = YES;
            [button setTitle:item.title forState:UIControlStateNormal];
            if (item.titleColor) {
                [button setTitleColor:item.titleColor forState:UIControlStateNormal];
            } else {
                [button setTitleColor:ButtonTitleColor forState:UIControlStateNormal];
            }
            if (item.backColor) {
                button.backgroundColor = item.backColor;
            } else {
                button.backgroundColor = ButtonBackColor;
            }
            if (item.image) {
                [button setImage:item.image forState:UIControlStateNormal];
            }
            button.titleLabel.font = [UIFont systemFontOfSize:buttonFont];
            button.frame = CGRectMake(startX, Y, buttonWidth, buttonHeight);
            button.tag = 999 + i;
            [button addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            startX += buttonWidth;
            startX += hGap;
        }
    } else {
        CGFloat buttonWidth = self.contentViewWidth - leftGap - rightGap;
        for (NSInteger i = 0; i < buttonNum; i++) {
            CHZAlertButtonItem *item = self.setup.buttonItemArray[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.cornerRadius = cornerRadius;
            button.layer.masksToBounds = YES;
            [button setTitle:item.title forState:UIControlStateNormal];
            if (item.titleColor) {
                [button setTitleColor:item.titleColor forState:UIControlStateNormal];
            } else {
                [button setTitleColor:ButtonTitleColor forState:UIControlStateNormal];
            }
            if (item.backColor) {
                button.backgroundColor = item.backColor;
            } else {
                button.backgroundColor = ButtonBackColor;
            }
            if (item.image) {
                [button setImage:item.image forState:UIControlStateNormal];
            }
            button.titleLabel.font = [UIFont systemFontOfSize:buttonFont];
            button.frame = CGRectMake(leftGap, Y, buttonWidth, buttonHeight);
            button.tag = 999 + i;
            [button addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            Y += buttonHeight;
            Y += vGap;
            height += buttonHeight;
            if (i != buttonNum - 1) {
                height += vGap;
            }
        }
    }
    return height;
}

#pragma mark - lazy load
/** 主内容视图 */
-(UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = cornerRadius;
//        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

/** 顶部图片icon */
-(UIView *)topIcon {
    if (!_topIcon) {
        _topIcon = [[UIView alloc] init];
        _topIcon.backgroundColor = self.contentView.backgroundColor;
    }
    return _topIcon;
}

/** 标题 */
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.setup.title;
        if (self.setup.titleFont) {
            _titleLabel.font = self.setup.titleFont;
        } else {
            _titleLabel.font = [UIFont boldSystemFontOfSize:titleFont];
        }
        if (self.setup.titleColor) {
            _titleLabel.textColor = self.setup.titleColor;
        } else {
            _titleLabel.textColor = [UIColor blackColor];
        }
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

/** 描述信息 */
-(UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.text = self.setup.information;
        if (self.setup.infoFont) {
            _infoLabel.font = self.setup.infoFont;
        } else {
            _infoLabel.font = [UIFont systemFontOfSize:infoFont];
        }
        if (self.setup.infoColor) {
            _infoLabel.textColor = self.setup.infoColor;
        } else {
            _infoLabel.textColor = [UIColor darkGrayColor];
        }
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}

/** textField */
-(UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:textFont];
        _textField.textColor = [UIColor darkGrayColor];
        _textField.tintColor = [UIColor darkGrayColor];
        _textField.layer.cornerRadius = cornerRadius;
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderWidth = 1.0;
        _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textField.placeholder = self.setup.placeholder;
    }
    return _textField;
}

-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:textFont];
        _textView.textColor = [UIColor darkGrayColor];
        _textView.tintColor = [UIColor darkGrayColor];
        _textView.layer.cornerRadius = cornerRadius;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderWidth = 1.0;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.placeholder = self.setup.placeholder;
        _textView.placeholderColor = [UIColor lightGrayColor];
    }
    return _textView;
}

/** 图片容器 */
-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

/** pickerTableView */
-(UITableView *)pickerTableView {
    if (!_pickerTableView) {
        _pickerTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _pickerTableView.backgroundColor = self.contentView.backgroundColor;
        _pickerTableView.tintColor = [UIColor darkGrayColor];
        _pickerTableView.delegate = self;
        _pickerTableView.dataSource = self;
    }
    return _pickerTableView;
}

/** 计时器 */
-(NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        //使用 NSRunLoopCommonModes 确保 RunLoop 切换模式时 NSTimer 能正常工作
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    return _timer;
}

#pragma mark - Actions
/** 按钮点击事件 */
- (void)clickOnButton:(UIButton *)sender {
    if (_textView) {
        self.inputText = _textView.text;
        [_textView resignFirstResponder];
    }
    if (_textField) {
        self.inputText = _textField.text;
        [_textField resignFirstResponder];
    }
    
    NSInteger buttonIndex = sender.tag - 999;
    if (self.buttonBlock) {
        BOOL needClose = self.buttonBlock(buttonIndex, self.inputText, self.pickedStringsArray);
        if (needClose) {
            [self closeAlertView];
        }
    }
}

/** 计时器方法 */
- (void)countDown {
    _timeCount --;
    if (self.countdownBlock) {
        self.countdownBlock(_timeCount);
    }
    if (_timeCount <= 0) {
        //倒计时完成
        [self invalidateTimer];
        [self closeAlertView];
    }
}

/** 置空计时器 */
- (void)invalidateTimer {
    if (_timer) {
        [_timer invalidate];
        [self setTimer:nil];
    }
}

#pragma mark - UITextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView {
    self.inputText = textView.text;
}

-(void)textViewDidChange:(UITextView *)textView {
    self.inputText = textView.text;
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.inputText = textField.text;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.inputText = textField.text;
    return YES;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pickerModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELLID = @"CHZPickerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CHZPickerModel *model = self.pickerModelArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:pickerFont];
    cell.textLabel.text = model.string;
    if (model.picked) {
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.setup.pickerCellHeight > 0) {
        return self.setup.pickerCellHeight;
    } else {
        return pickerCellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CHZPickerModel *model = self.pickerModelArray[indexPath.row];
    if (model.picked) {
        [self.pickedStringsArray removeObject:model.string];
    } else {
        [self.pickedStringsArray addObject:model.string];
    }
    model.picked = !model.picked;
    self.setup.pickedStringsArray = (NSArray <NSString *>*)self.pickedStringsArray;
    [self.pickerTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

@end
