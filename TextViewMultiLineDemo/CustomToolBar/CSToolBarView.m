//
//  CSToolBarView.m
//  UPOC_Teacher
//
//  Created by a on 2019/12/11.
//  Copyright © 星梦. All rights reserved.
//

#import "CSToolBarView.h"
#import <Masonry.h>
#import "CSToolBarCell.h"
#import "PublicConfig.h"

#define kLineHeight 1.0

@interface CSToolBarView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//左侧按钮组件
@property(nonatomic,strong) UICollectionView * collectionView;
//最右侧尖头按钮
@property(nonatomic,strong) UIButton * showKeyBoard;
//分割线
@property(nonatomic,strong) UIView * lineView;

@end

static NSString * resuIdentifierId = @"CSToolBarCell";
@implementation CSToolBarView
-(instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)itemArray{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseUI];
        self.actionTypeArray = itemArray;
    }
    return self;
}

-(void)setIsBtnSelected:(BOOL)isBtnSelected{
    _isBtnSelected = isBtnSelected;
    [UIView animateWithDuration:0.3 animations:^{
      //正的表示逆时针，负的表示顺时针
        self.showKeyBoard.transform = CGAffineTransformRotate(self.showKeyBoard.transform,isBtnSelected?-M_PI:M_PI);
    }];
    self.showKeyBoard.selected = isBtnSelected;
}
-(instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self initBaseUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseUI];
    }
    return self;
}
-(void)initBaseUI{
    [self addSubview:self.lineView];
    [self addSubview:self.showKeyBoard];
    [self addSubview:self.collectionView];
    self.backgroundColor = [UIColor whiteColor];
    
    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@(kLineHeight));
        make.left.equalTo(self);
    }];
    
    [_showKeyBoard mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(_lineView.mas_bottom);
        make.bottom.equalTo(self);
        make.width.equalTo(self.mas_height).offset(kLineHeight);
    }];
    
    [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(_lineView.mas_bottom);
        make.bottom.equalTo(self);
        make.right.equalTo(_showKeyBoard.mas_left).offset(-15);
    }];
}
-(void)setShowNormalImage:(NSString *)showNormalImage{
    _showNormalImage = showNormalImage;
   [self.showKeyBoard setImage:[UIImage imageNamed:showNormalImage] forState:UIControlStateNormal];
}

-(void)setShowSelectedImage:(NSString *)showSelectedImage{
    _showSelectedImage = showSelectedImage;
   [self.showKeyBoard setImage:[UIImage imageNamed:showSelectedImage] forState:UIControlStateSelected];
}


-(void)setActionTypeDic:(NSArray *)actionTypeDic{
    _actionTypeArray = actionTypeDic;
    [self.collectionView reloadData];
}
#pragma mark---------UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1.0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.actionTypeArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CSToolBarCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuIdentifierId forIndexPath:indexPath];
    NSDictionary * actionInfoDic = self.actionTypeArray[indexPath.row];
    [cell bindObject:actionInfoDic.allKeys.firstObject];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(CGRectGetHeight(self.frame)-kLineHeight, CGRectGetHeight(self.frame)-kLineHeight);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self reposeClickWithIndexpath:indexPath];
}
#pragma mark-------点击按钮的操作：
-(void)reposeClickWithIndexpath:(NSIndexPath *)didIndexPath{
    NSDictionary * actionInfos = self.actionTypeArray[didIndexPath.row];
    NSNumber * values = (NSNumber *)actionInfos.allValues.firstObject;
    InputType inputType = (InputType)[values integerValue];
    if (self.toolBarViewDelegate && [self.toolBarViewDelegate respondsToSelector:@selector(didClickResponseWithInputType:)]) {
        [self.toolBarViewDelegate didClickResponseWithInputType:inputType];
    }
}

#pragma mark---------懒加载---

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = kUIColorFromRGB(0xD2D2D2, 1.0);
    }
    return _lineView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 33.0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:resuIdentifierId bundle:nil] forCellWithReuseIdentifier:resuIdentifierId];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

-(UIButton *)showKeyBoard{
    if (!_showKeyBoard) {
        _showKeyBoard = [[UIButton alloc]initWithFrame:CGRectZero];
        [_showKeyBoard setImage:[UIImage imageNamed:@"ShowKeyBoard"] forState:UIControlStateNormal];
        [_showKeyBoard addTarget:self action:@selector(didShowKeyBoardAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _showKeyBoard.backgroundColor = [UIColor whiteColor];
    }
    return _showKeyBoard;
}
-(void)didShowKeyBoardAction:(UIButton *)showKeyBoardAction{
    //收回键盘
    if (self.toolBarViewDelegate && [self.toolBarViewDelegate respondsToSelector:@selector(didClickResponseWithInputType:)]) {
        [self.toolBarViewDelegate didClickResponseWithInputType:ShowKeyBoardType];
    }
}
@end
