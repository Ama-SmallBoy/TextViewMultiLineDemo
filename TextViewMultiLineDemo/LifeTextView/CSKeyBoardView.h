//
//  CSKeyBoardView.h
//  UPOC_Teacher
//
//  Created by a on 2020/3/2.
//  Copyright © 星梦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSToolBarView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^SendBlock) (NSString *text);

typedef enum : NSUInteger {
    StopBottomType,//停留在底部
    HiddenSelfType,//完全隐藏
} KeyBoardType;

@protocol CSKeyBoardViewDelegate <NSObject>
#pragma mark-----------------ToolBarView 的点击事件处理---
-(void)didClickToolBarWithInputType:(InputType)inputType;
@end

@interface CSKeyBoardView : UIView
/**
 需要配置的属性（也可不传）
 */
@property(nonatomic,assign)BOOL isDisappear;//是否即将消失。
@property(nonatomic,assign)int maxLine;//设置最大行数
@property(nonatomic,assign)CGFloat topOrBottomEdge;//上下间距
@property(nonatomic,strong)UIFont *font;//设置字体大小(决定输入框的初始高度)
@property(nonatomic,assign)KeyBoardType keyBoardType;//键盘类型 默认 StopBottomType
@property(nonatomic,assign) BOOL isEnterEditting;//是否 处于编辑状态
@property(nonatomic,assign) id<CSKeyBoardViewDelegate>keyBoardViewDelegate;
@property(nonatomic,strong) NSString * placeholder;//更改占位文字
//设置好属性之后开始布局
-(void)beginUpdateUI;
//开始编辑
-(void)beginEditorTextView;
//结束编辑
-(void)endEditorTextView;
//回调
@property(nonatomic,copy)SendBlock sendBlock;
@end

NS_ASSUME_NONNULL_END
