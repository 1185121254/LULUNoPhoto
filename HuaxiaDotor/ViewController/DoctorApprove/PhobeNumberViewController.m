//
//  PhobeNumberViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PhobeNumberViewController.h"

@interface PhobeNumberViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txt_telPhone;

@end

@implementation PhobeNumberViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)btnEnter:(UIBarButtonItem *)sender
{
    NSUserDefaults *userDeaults = [NSUserDefaults standardUserDefaults];
    [userDeaults setObject:_txt_telPhone.text forKey:@"telNum"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
