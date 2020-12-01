//
//  CSKeyBoardView.m
//  UPOC_Teacher
//
//  Created by a on 2020/3/2.
//  Copyright © 星梦. All rights reserved.
//

#import "CSKeyBoardView.h"
#import "PublicConfig.h"
#import "UIView+LX_Frame.h"
#import <Masonry.h>
#import <ReactiveObjC.h>
#import "CSTextView.h"

#define kLeftWidth 15
#define kBackBtnWidth 70
#define kSendWidth 60
#define ToolBarHeight 40

@interface CSKeyBoardView()<UITextViewDelegate,CSToolBarViewDelegate>
@property(nonatomic,strong)CSTextView *textView;
@property(nonatomic,strong)UIButton *sendBtn;
@property(nonatomic,strong)UIView * btnBackView;
@property(nonatomic,assign)CGFloat btnH;
@property(nonatomic,strong)CSToolBarView * toolBarView;
@property(nonatomic,strong) NSString * textContent;
@end
@implementation CSKeyBoardView
{
    CGFloat keyboardY;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self setDefaultInfo];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
        [self setDefaultInfo];
    }
    return self;
}
//初始化方法
-(void)setDefaultInfo{
    self.layer.borderWidth = 1;
    self.layer.borderColor = kUIColorFromRGB(0xA5A5A5, 1.0).CGColor;
    //监听键盘事件
    [self addObserverForKeyboard];
    //设置默认属性
    self.topOrBottomEdge = 8;
    self.font = [UIFont systemFontOfSize:14.0];
    self.maxLine = 3;
    self.keyBoardType = StopBottomType;
}
-(void)addObserveTextOfTextView{
    @weakify(self)
    [[RACObserve(self,textContent)distinctUntilChanged] subscribeNext:^(NSString * text) {
        @strongify(self)
        if (text.length>0) {
            self.sendBtn.enabled = YES;
            self.sendBtn.backgroundColor = kUIColorFromRGB(0x00ba97, 1.0);
        }else{
            self.sendBtn.enabled = NO;
            self.sendBtn.backgroundColor = kUIColorFromRGB(0x00ba97, 0.3);
        }
    }];
}
-(void)beginUpdateUI{
    //初始化高度 textView的lineHeight + 2 * 上下间距
    CGFloat orignTextH  = ceil (self.font.lineHeight) + 2 * self.topOrBottomEdge+ToolBarHeight;
    CGFloat selfY = self.keyBoardType == StopBottomType?SCREEN_HEIGHT - orignTextH:SCREEN_HEIGHT;
    
    self.frame =  CGRectMake(0, selfY, SCREEN_WIDTH, orignTextH);
    self.btnH = self.lx_height - ToolBarHeight;
    [self setup];
    //默认处于 可编辑状态
    [self.textView becomeFirstResponder];
}
-(void)setup{
    [self addSubview:self.textView];
    [self addSubview:self.btnBackView];
    [self.btnBackView addSubview:self.sendBtn];
    [self addSubview:self.toolBarView];
    [_toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(_textView.mas_bottom).offset(self.topOrBottomEdge);
    }];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_btnBackView);
        make.centerY.equalTo(_btnBackView);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    @weakify(self)
    [[_sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.sendBlock) {
            self.sendBlock(self.textView.text);
        }
    }];
    //检测输入框，内容变化
    [self addObserveTextOfTextView];
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _textView.placeholder = placeholder;
}
-(void)setKeyBoardType:(KeyBoardType)keyBoardType{
    _keyBoardType = keyBoardType;
}
-(void)beginEditorTextView{
    [_textView becomeFirstResponder];
}
-(void)endEditorTextView{
    [_textView resignFirstResponder];
}
-(void)setIsEnterEditting:(BOOL)isEnterEditting{
    _isEnterEditting = isEnterEditting;
    isEnterEditting ? [_textView becomeFirstResponder]:[_textView resignFirstResponder];
}
#pragma mark-------------- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    self.textContent = textView.text;
    CGFloat contentSizeH = _textView.contentSize.height;
    CGFloat lineH = _textView.font.lineHeight;
    
    CGFloat maxHeight = ceil(lineH * self.maxLine + textView.textContainerInset.top + textView.textContainerInset.bottom);
    if (contentSizeH <= maxHeight) {
        _textView.lx_height = contentSizeH;
    }else{
        _textView.lx_height = maxHeight;
    }
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
    
    CGFloat totalH = ceil(_textView.lx_height) + 2 * self.topOrBottomEdge+ToolBarHeight;
    self.frame = CGRectMake(0, keyboardY - totalH, self.lx_width, totalH);
    self.btnBackView.lx_height = ceil(_textView.lx_height) + 2 * self.topOrBottomEdge;
}
//键盘监听
-(void)addObserverForKeyboard{
    //即将改变Frame
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //已经改变Frame
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    //展示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    //收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDimssKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
}
//展示
-(void)didShowKeyboardNotification:(NSNotification *)notifation{
    CGRect keyBoardRect=[notifation.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    [UIView animateWithDuration:[notifation.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        CGFloat keyBoardHeight = deltaY + self.lx_height;
        self.lx_y = SCREEN_HEIGHT- keyBoardHeight;
    }];
}
//收起
-(void)didDimssKeyboardNotification:(NSNotification *)notifation{
    [UIView animateWithDuration:[notifation.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.lx_y = self.keyBoardType == StopBottomType?SCREEN_HEIGHT - self.lx_height:SCREEN_HEIGHT;
    }];
}
-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    //动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardY = keyboardF.origin.y;
    if (!_isDisappear) {
        [self dealKeyBoardWithKeyboardF:keyboardY duration:duration];
    }
}
-(void)keyboardDidChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //  NSLog(@"%@",NSStringFromCGRect(keyboardF));
    
    keyboardY = keyboardF.origin.y;
    // 工具条的Y值 == 键盘的Y值 - 工具条的高度
    if (_isDisappear) {
        [self dealKeyBoardWithKeyboardF:keyboardY duration:duration];
    }
}
#pragma mark---处理高度---
-(void)dealKeyBoardWithKeyboardF:(CGFloat)keyboardY duration:(CGFloat)duration {
    
    if (!_isDisappear) {
        [UIView animateWithDuration:duration animations:^{
            // 工具条的Y值 == 键盘的Y值 - 工具条的高度
            if (keyboardY > SCREEN_HEIGHT) {
                self.lx_y = SCREEN_HEIGHT- self.lx_height;
            }else
            {
                self.lx_y = keyboardY - self.lx_height;
            }
        }];
    }else{
        if (keyboardY > SCREEN_HEIGHT) {
            self.lx_y = SCREEN_HEIGHT- self.lx_height;
        }else
        {
            self.lx_y = keyboardY - self.lx_height;
        }
    }
}

#pragma mark------
-(void)didClickResponseWithInputType:(InputType)inputType{
    //点击的类型
    if (self.keyBoardViewDelegate && [self.keyBoardViewDelegate respondsToSelector:@selector(didClickToolBarWithInputType:)]) {
        [self.keyBoardViewDelegate didClickToolBarWithInputType:inputType];
    }
}
#pragma mark---setter---
-(void)setTopOrBottomEdge:(CGFloat)topOrBottomEdge{
    _topOrBottomEdge  = topOrBottomEdge;
    if (!_topOrBottomEdge) {
        topOrBottomEdge = 10;
    }
}
-(void)setMaxLine:(int)maxLine{
    _maxLine = maxLine;
    if (!_maxLine || _maxLine <=0) {
        _maxLine = 3;
    }
}
-(void)setFont:(UIFont *)font{
    _font = font;
    if (!font) {
        _font = [UIFont systemFontOfSize:14.0];
    }
}
-(void)setIsDisappear:(BOOL)isDisappear{
    _isDisappear = isDisappear;
}
#pragma mark---getter---
-(CSTextView *)textView{
    if (!_textView) {
        _textView =[[CSTextView alloc]initWithFrame:CGRectMake(kLeftWidth, self.topOrBottomEdge, self.lx_width - kBackBtnWidth - kLeftWidth, ceil(self.font.lineHeight))];
        _textView.font = self.font;
        _textView.delegate = self;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.scrollsToTop = NO;
        _textView.tintColor = kUIColorFromRGB(0x00ba97, 1.0);
        _textView.textContainerInset = UIEdgeInsetsZero; //关闭textview的默认间距属性
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.placeholder = @"给你一个神评的机会";
    }
    return _textView;
}
-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn =[[UIButton alloc]initWithFrame:CGRectZero];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.backgroundColor = kUIColorFromRGB(0x00ba97, 1.0);
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 3.0;
    }
    return _sendBtn;
}
-(UIView *)btnBackView{
    if (!_btnBackView) {
        _btnBackView = [[UIView alloc]initWithFrame:CGRectMake(self.lx_width - kBackBtnWidth, 0, kBackBtnWidth,self.btnH)];
    }
    return _btnBackView;
}

#pragma mark--------- 懒加载 -------
-(CSToolBarView *)toolBarView{
    if (!_toolBarView) {
        NSArray * actionInfos = @[
            @{@"AddImg":@(ImageType)},
            @{@"camera":@(CameraType)},
            @{@"Emoji":@(EmojiType)},
        ];
        _toolBarView = [[CSToolBarView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,ToolBarHeight) itemArray:actionInfos];
        _toolBarView.showNormalImage = @"";
        _toolBarView.toolBarViewDelegate = self;
    }
    return _toolBarView;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"%@",self.class);
}
@end
