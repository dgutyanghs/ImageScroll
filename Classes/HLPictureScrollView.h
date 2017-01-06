//
//  HLPictureScrollView
//  SmartCoach
//
//  Created by AlexYang on 15/7/8.
//  Copyright (c) 2015年 SmartCoach. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HLPictureScrollViewDelegte <NSObject>

@optional
-(void)sectionHeaderViewPageDidChanged:(NSNumber *)index;
-(void)pictureScrollImageViewDidTap:(int)index;
@end

typedef void(^actionBlock)(NSNumber *index);

@interface HLPictureScrollView : UIView <UIScrollViewDelegate>
@property (weak, nonatomic)  UIScrollView *scrollView;
@property (assign, nonatomic) id <HLPictureScrollViewDelegte> delegate;

@property (copy,   nonatomic) actionBlock callBackBlock;
@property (assign, nonatomic) NSInteger pageCount;

+(instancetype)viewWithFrame:(CGRect)frame andImages:(NSArray *)images;
//+(instancetype)viewWithImages:(NSArray *)images andHeight:(CGFloat)height;
//+(instancetype)viewWithTitles:(NSArray *)titles andHeight:(CGFloat)height callBack:(actionBlock) block;

+(instancetype)viewWithFrame:(CGRect)frame andImages:(NSArray *)images viewDisplayMode:(UIViewContentMode)contentMode;
-(void)refreshWithImagesURLStr:(NSArray *)imageAddress;
+(instancetype)viewWithFrame:(CGRect)frame andImagesUrl:(NSArray *)imagesUrl viewDisplayMode:(UIViewContentMode)contentMode;
@end
