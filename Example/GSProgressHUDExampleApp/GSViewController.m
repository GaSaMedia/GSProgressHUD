//
//  GSViewController.m
//  GSProgressHUDExampleApp
//
//  Created by Gard Sandholt on 14/02/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "GSViewController.h"
#import "GSProgressHUD.h"

@interface GSViewController ()

@property (strong, nonatomic) IBOutlet UIButton *showButton;
@property (strong, nonatomic) IBOutlet UIButton *popButton;

@end

@implementation GSViewController


- (IBAction)showButtonPressed:(id)sender {
    
    UIButton *showBtn = (UIButton *) sender;
    
    if ([GSProgressHUD isVisible]) {
        [GSProgressHUD dismiss];
        [showBtn setTitle:@"Show" forState:UIControlStateNormal];
        return;
    }
    
    [GSProgressHUD showImage:[UIImage imageNamed:@"check"] withStatus:@"Working..."];
    [showBtn setTitle:@"Hide" forState:UIControlStateNormal];
}

- (IBAction)popButtonPressed:(id)sender {
    [GSProgressHUD popImage:[UIImage imageNamed:@"check"] withStatus:@"Working..."];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
