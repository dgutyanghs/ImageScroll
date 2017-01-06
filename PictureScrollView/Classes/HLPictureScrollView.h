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
@property (assign, nonatomic) id <HLPictureScrollViewDelegte> delegate;
@property (copy,   nonatomic) actionBlock callBackBlock;

+(instancetype)viewWithImagesUrl:(NSArray *)imagesUrl viewDisplayMode:(UIViewContentMode)contentMode;
-(void)refreshWithImagesURLStr:(NSArray *)imagesUrl;
@end
