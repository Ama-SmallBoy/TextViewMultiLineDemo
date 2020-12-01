//
//  ViewController.m
//  TextViewMultiLineDemo
//
//  Created by a on 2020/3/3.
//  Copyright © 2020 TeenageBeaconFireGroup. All rights reserved.
//

#import "ViewController.h"
#import "KeyBoardViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)pushNextViewControllerAction:(UIButton *)sender {
    KeyBoardViewController * keyBoardViewController = [[KeyBoardViewController alloc] init];
    keyBoardViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:keyBoardViewController animated:YES completion:nil];
}


@end
