//
//  ViewController.m
//  DDStickerView
//
//  Created by mac on 16/8/18.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import "ViewController.h"
#import "DDStickerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet DDStickerView *stickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(id)sender {
    [self.stickerView addStickerView:[UIImage imageNamed:@"dd2333.jpg"]];
}
@end
