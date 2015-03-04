//
//  ViewController.m
//  ImagePicker
//
//  Created by DingXiao on 15/3/3.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "ViewController.h"
#import "DNImagePickerController.h"
@interface ViewController () <DNImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray *assetsArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage  *img = [UIImage imageNamed:@"compose_pic_add"];
    UIButton   *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 100, img.size.width, img.size.height);
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"compose_pic_add_highlighted"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(composePicAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)composePicAdd
{
    DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
    imagePicker.imagePickerDelegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - DNImagePickerControllerDelegate

- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
    self.assetsArray = [NSMutableArray arrayWithArray:imageAssets];
    
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
