//
//  HLPictureScrollView
//  SmartCoach
//
//  Created by AlexYang on 15/7/8.
//  Copyright (c) 2015年 SmartCoach. All rights reserved.
//

#import "HLPictureScrollView.h"
#import "UIImageView+WebCache.h"
#import "PureLayout.h"
#import "UIView+Extension.h"


typedef NS_ENUM(NSInteger, SectionButtonIndex) {
    leftArrowButtonTag,
    rightArrowButtonTag,
};

@interface HLPictureScrollView ()
@property (assign, nonatomic) NSInteger pageCount;
@property (weak, nonatomic)  UIScrollView *scrollView;

@property (nonatomic , weak) UIPageControl *pageControl;
@property (nonatomic , assign) int currentPageIndex;
@property (nonatomic, weak) UIView *containView;
@property (nonatomic , strong) NSLayoutConstraint *contentWidthConstraint;

@property (nonatomic, assign) int imageViewContentModel;
@end

@implementation HLPictureScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIScrollView *scrollView = [UIScrollView newAutoLayoutView];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIView *containView = [UIView newAutoLayoutView];
        containView.backgroundColor = [UIColor greenColor];
        [scrollView addSubview:containView];
        self.containView = containView;
        
        UIPageControl *pageControl = [UIPageControl newAutoLayoutView];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

-(void)refreshWithImagesURLStr:(NSArray *)imagesUrl
{
    
    if (imagesUrl.count <= 0) {
        NSLog(@"emtpy imagesUrl.count");
        return;
    }
    
    NSArray *subviews = self.containView.subviews;
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
    
    self.pageCount = imagesUrl.count;
    if (imagesUrl.count) {
        // set containView size to scrollview.contentsize
        [self.contentWidthConstraint autoRemove];
        self.contentWidthConstraint = [self.containView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView withMultiplier:imagesUrl.count];
        UIImageView *preImageView = nil;
        for (int i = 0; i < imagesUrl.count; i++) {
            UIImageView *imageView = [UIImageView newAutoLayoutView];
            [imageView sd_setImageWithURL:imagesUrl[i] placeholderImage:[UIImage imageNamed:@"piano1"] options:SDWebImageAllowInvalidSSLCertificates];
            imageView.contentMode = self.imageViewContentModel;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTaped:)];
            [imageView addGestureRecognizer:tap];
            [self.containView addSubview:imageView];
            [imageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView];
            [imageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollView];
            [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            if (!preImageView) {
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            }else {
                [imageView autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeTrailing ofView:preImageView];
            }
            
            preImageView = imageView;
        }
        
        [self.containView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.scrollView];
        [self.containView autoPinEdge:ALEdgeTop  toEdge:ALEdgeTop  ofView:self.scrollView];
        [self.containView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.scrollView];
        [self.containView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.scrollView];
        [self.containView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollView];
    }
    
    self.pageControl.numberOfPages = imagesUrl.count;
    self.pageControl.hidesForSinglePage = YES;
    CGSize pagesSize = [self.pageControl sizeForNumberOfPages:imagesUrl.count];
    [self.pageControl autoSetDimensionsToSize:pagesSize];
    [self.pageControl autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
    [self.pageControl autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:10];
    
    
    [self.scrollView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self];
    [self.scrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [self.scrollView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self];
    [self.scrollView autoSetDimension:ALDimensionHeight toSize:self.containView.height];
}


+(instancetype)viewWithFrame:(CGRect)frame andImagesUrl:(NSArray *)imagesUrl viewDisplayMode:(UIViewContentMode)contentMode
{
    
    NSAssert(imagesUrl.count, @"empty imagesUrls");
    
    CGFloat viewH = frame.size.height;
//    CGFloat viewW = frame.size.width;
    
    HLPictureScrollView *pictureSV  = [[HLPictureScrollView alloc] initWithFrame:frame];
    [pictureSV configureForAutoLayout];
    
    pictureSV.pageCount = imagesUrl.count;
    pictureSV.scrollView.userInteractionEnabled = YES;
    pictureSV.scrollView.delegate = pictureSV;
    pictureSV.scrollView.pagingEnabled = YES;
    pictureSV.scrollView.showsHorizontalScrollIndicator = NO;
    pictureSV.imageViewContentModel = contentMode;
    
    if (imagesUrl.count) {
        // set containView size to scrollview.contentsize
        [pictureSV.contentWidthConstraint autoRemove];
        pictureSV.contentWidthConstraint = [pictureSV.containView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:pictureSV.scrollView withMultiplier:imagesUrl.count];
        UIImageView *preImageView = nil;
        for (int i = 0; i < imagesUrl.count; i++) {
            UIImageView *imageView = [UIImageView newAutoLayoutView];
            [imageView sd_setImageWithURL:imagesUrl[i] placeholderImage:[UIImage imageNamed:@"piano1"] options:SDWebImageAllowInvalidSSLCertificates];
            imageView.contentMode = contentMode;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:pictureSV action:@selector(imageViewDidTaped:)];
            [imageView addGestureRecognizer:tap];
            [pictureSV.containView addSubview:imageView];
            [imageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:pictureSV.scrollView];
            [imageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:pictureSV.scrollView];
            [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            if (!preImageView) {
                [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            }else {
                [imageView autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeTrailing ofView:preImageView];
            }
            
            preImageView = imageView;
        }
        
        [pictureSV.containView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:pictureSV.scrollView];
        [pictureSV.containView autoPinEdge:ALEdgeTop  toEdge:ALEdgeTop  ofView:pictureSV.scrollView];
        [pictureSV.containView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:pictureSV.scrollView];
        [pictureSV.containView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:pictureSV.scrollView];
        [pictureSV.containView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:pictureSV.scrollView];
    }
    
    pictureSV.pageControl.numberOfPages = imagesUrl.count;
    pictureSV.pageControl.hidesForSinglePage = YES;
    CGSize pagesSize = [pictureSV.pageControl sizeForNumberOfPages:imagesUrl.count];
    [pictureSV.pageControl autoSetDimensionsToSize:pagesSize];
    [pictureSV.pageControl autoAlignAxis:ALAxisVertical toSameAxisOfView:pictureSV];
    [pictureSV.pageControl autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:pictureSV withOffset:10];
    
    
    [pictureSV.scrollView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:pictureSV];
    [pictureSV.scrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:pictureSV];
    [pictureSV.scrollView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:pictureSV];
    [pictureSV.scrollView autoSetDimension:ALDimensionHeight toSize:viewH];
    
    return pictureSV;
}

#pragma mark - UIScrollView delegate

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat pageWidth = scrollView.frame.size.width;
//    int userPanOffset = ((int)scrollView.contentOffset.x) % ((int)pageWidth/2);
//    CGFloat alpha = userPanOffset / (CGFloat)(pageWidth/2);
//    HLLog(@" userPanOffset %d", userPanOffset);
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    static int oldPage = 0;
    
    if (decelerate == NO) {
        // 得到每页宽度
        int pageWidth = scrollView.frame.size.width;
        // 根据当前的x坐标和页宽度计算出当前页数
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        
        int currentPage = floor((contentOffsetX - pageWidth / 2) / pageWidth) + 1;
        if (currentPage != oldPage) {
            //通知代理
            if ([self.delegate respondsToSelector:@selector(sectionHeaderViewPageDidChanged:)]) {
                [self.delegate sectionHeaderViewPageDidChanged:[NSNumber numberWithInt:currentPage]];
            }
        
            oldPage = currentPage;
            self.pageControl.currentPage = currentPage;
        }
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    static int oldPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentPageIndex = currentPage;
    
    if (currentPage != oldPage) {
        if ([self.delegate respondsToSelector:@selector(sectionHeaderViewPageDidChanged:)]) {
            [self.delegate sectionHeaderViewPageDidChanged:[NSNumber numberWithInt:currentPage]];
        }
        self.pageControl.currentPage = currentPage;
       oldPage = currentPage;
    }
}

-(void)imageViewDidTaped:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(pictureScrollImageViewDidTap:)]) {
        [self.delegate pictureScrollImageViewDidTap:self.currentPageIndex];
    }
}

@end
