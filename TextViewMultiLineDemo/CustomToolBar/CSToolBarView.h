//
//  CSToolBarView.h
//  UPOC_Teacher
//
//  Created by a on 2019/12/11.
//  Copyright © 星梦. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    ImageType,
    CameraType,
    FileType,
    PencilType,
    VoiceType,
    EmojiType,
    ShowKeyBoardType,
    OtherType,
}InputType;
NS_ASSUME_NONNULL_BEGIN
@protocol CSToolBarViewDelegate <NSObject>
-(void)didClickResponseWithInputType:(InputType)inputType;
@end
@interface CSToolBarView : UIView
@property(nonatomic,strong) NSString * showSelectedImage;
@property(nonatomic,strong) NSString * showNormalImage;
@property(nonatomic,strong) NSArray * actionTypeArray;
@property(nonatomic,assign)BOOL isBtnSelected;
@property(nonatomic,assign) id<CSToolBarViewDelegate> toolBarViewDelegate;
-(instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)itemArray;
@end

NS_ASSUME_NONNULL_END
