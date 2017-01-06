//
//  ViewController.m
//  PictureScrollView
//
//  Created by AlexYang on 17/1/6.
//  Copyright © 2017年 AlexYang. All rights reserved.
//

#import "ViewController.h"
#import "HLPictureScrollView.h"
#import "UIView+Extension.h"
#import "PureLayout.h"

@interface ViewController () <HLPictureScrollViewDelegte>
@property (weak, nonatomic) IBOutlet UILabel *tapLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (nonatomic , strong) HLPictureScrollView *slideView;
@property (nonatomic, strong) NSMutableArray *imagesUrls;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray <NSURL *> *imageUrls = [NSMutableArray array];
    
    NSURL *url1 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/08/12/01.jpg"];
    NSURL *url2 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/08/12/02.jpg"];
    NSURL *url3 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/08/12/03.jpg"];
    NSURL *url4 = [NSURL URLWithString:@"http://mm.howkuai.com/wp-content/uploads/2016a/08/12/04.jpg"];
    
    [imageUrls addObject:url1];
    [imageUrls addObject:url2];
    [imageUrls addObject:url3];
    [imageUrls addObject:url4];
    
    [self loadPianosPictures:imageUrls];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadPianosPictures:(NSMutableArray *)imagesUrls  {
    
    CGRect slideFrame = CGRectMake(0, 0, self.containView.width, self.containView.height);
    _slideView = [HLPictureScrollView viewWithFrame:slideFrame andImagesUrl:imagesUrls viewDisplayMode: UIViewContentModeScaleToFill];
    _slideView.delegate = self;
    [self.containView addSubview:_slideView];
    [_slideView autoPinEdgesToSuperviewEdges];
    [self.slideView setNeedsDisplay];
    
}

#pragma mark - HLPictureScrollViewDelegate

-(void)sectionHeaderViewPageDidChanged:(NSNumber *)index {
    self.pageLabel.text = [NSString stringWithFormat:@"user did scroll to the page:%d ", index.intValue];
}

-(void)pictureScrollImageViewDidTap:(int)index {
    self.tapLabel.text = [NSString stringWithFormat:@"user did tap the picture:%d ", index];
}

@end
