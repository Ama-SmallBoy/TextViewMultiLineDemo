//
//  KeyBoardViewController.m
//  UPOC_Teacher
//
//  Created by a on 2020/3/3.
//  Copyright © 星梦. All rights reserved.
//

#import "KeyBoardViewController.h"
#import <Masonry.h>
#import "CSKeyBoardView.h"
#import <ReactiveObjC.h>
#import <IQKeyboardManager.h>
@interface KeyBoardViewController ()<CSKeyBoardViewDelegate>
@property(nonatomic,strong)UIButton * reStartEditBtn;
@property(nonatomic,strong)CSKeyBoardView *keyBoardView;//
@end

@implementation KeyBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.reStartEditBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:self.reStartEditBtn];
    [self.reStartEditBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.reStartEditBtn setTitle:@"开始编辑" forState:UIControlStateNormal];
    [[self.reStartEditBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.keyBoardView beginEditorTextView];
    }];
    self.title = @"控制多行输入键盘";
    [self setup];
    if (@available(iOS 11.0, *)) {
        
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        // 这部分使用到的过期api
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
}

#pragma mark------系统方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    self.keyBoardView.isDisappear = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.keyBoardView.isDisappear = YES;
}
-(void)setup{
    [self.view addSubview:self.keyBoardView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark---------------CSKeyBoardViewDelegate 点击方法
-(void)didClickToolBarWithInputType:(InputType)inputType{
    switch (inputType) {
        case ImageType:
        {
            //从本地获取图片
            NSLog(@"=======从本地获取图片");
        }
            break;
        case CameraType:
        {
            //从相机获取图片
            NSLog(@"=======从相机获取图片");
        }
            break;
        case EmojiType:
        {
            //表情包
            NSLog(@"=======表情包");
        }
            break;
        default:
            break;
    }
}
-(CSKeyBoardView *)keyBoardView{
    if (!_keyBoardView) {
        _keyBoardView =[[CSKeyBoardView alloc]initWithFrame:CGRectZero];
        _keyBoardView.backgroundColor =[UIColor whiteColor];
        _keyBoardView.maxLine = 3;
        _keyBoardView.font = [UIFont systemFontOfSize:18.0];
        _keyBoardView.topOrBottomEdge = 10;
        [_keyBoardView beginUpdateUI];
        _keyBoardView.keyBoardViewDelegate = self;
        //不设置 则取默认
        _keyBoardView.placeholder = @"我的故事很长...";
        _keyBoardView.keyBoardType = HiddenSelfType;//默认 是 停留在底部
        _keyBoardView.sendBlock = ^(NSString *text) {
            NSLog(@"================%@",text);
        };
    }
    return _keyBoardView;
}
@end
