//
//  ViewController.m
//  PictureScrollView
//
//  Created by AlexYang on 17/1/6.
//  Copyright © 2017年 AlexYang. All rights reserved.
//

#import "ViewController.h"
#import "HLHttpClient.h"
#import "HLPictureScrollView.h"
#import "UIView+Extension.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (nonatomic , strong) HLPictureScrollView *slideView;
@property (nonatomic, strong) NSMutableArray *imagesUrls;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadPianosPictures];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadPianosPictures  {
    HLHttpClient *httpClient = [HLHttpClient sharedInstance];
    
    __weak __typeof(self) weakSelf = self;
    [httpClient post:@"/hotnews" parameters:nil success:^(NSDictionary * responseObject) {
        NSLog(@"response:%@", responseObject.debugDescription);
        NSArray *datas = responseObject[@"data"];
        
        NSMutableArray *imagesUrl = [NSMutableArray array];
        for (NSDictionary *dict in datas) {
            NSString *urlStr = dict[@"icon"];
            [imagesUrl addObject:urlStr];
        }
        self.imagesUrls = [imagesUrl mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.slideView removeFromSuperview];
            CGRect slideFrame = CGRectMake(0, 0, self.containView.width, self.containView.height);
            _slideView = [HLPictureScrollView viewWithFrame:slideFrame andImagesUrl:imagesUrl viewDisplayMode: UIViewContentModeScaleToFill];
            _slideView.delegate = weakSelf;
            [weakSelf.containView addSubview:_slideView];
            [_slideView autoPinEdgesToSuperviewEdges];
            [weakSelf.slideView setNeedsDisplay];
        });
    } fail:^(NSString *error) {
        NSLog(@"err:%@", error);
    }];
    
}

@end
