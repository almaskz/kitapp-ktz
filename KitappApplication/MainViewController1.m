//
//  MainViewController1.m
//  KitappApplication
//
//  Created by Olga Khvan on 06.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "MainViewController1.h"
#import <Parse/Parse.h>

@interface MainViewController1 ()


@property (nonatomic) UIImageView *logoImage;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *tutorialImage;
@property (nonatomic) UILabel *descriptionLabel;
@end

@implementation MainViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Colors
    UIColor *beigeLightColor = [UIColor colorWithRed:1.0 green:249/255.0 blue:243/255.0 alpha:1.0];
    UIColor *beigeDarkColor = [UIColor colorWithRed:238/255.0 green:225/255.0 blue:208/255.0 alpha:1.0];
    UIColor *darkBrownColor = [UIColor colorWithRed:117/255.0 green:91/255.0 blue:78/255.0 alpha:1];
    self.view.backgroundColor = beigeLightColor;
    
    
    //bg1
    _tutorialImage = [UIImageView new];
    _tutorialImage.image = [UIImage imageNamed:self.imageFile];
    _tutorialImage.backgroundColor = beigeLightColor;
    [self.view addSubview:_tutorialImage];
    NSString *platform = [UIDevice currentDevice].model;
    if ([platform isEqualToString:@"iPhone3,1"] || [platform isEqualToString:@"iPhone3,3"] || [platform isEqualToString:@"iPhone4,1"]){
            _tutorialImage.frame = CGRectMake(self.view.frame.size.width*0.2, self.view.frame.size.width*0.05, self.view.frame.size.width-2*self.view.frame.size.width*0.2, self.view.frame.size.width-2*self.view.frame.size.width*0.2);
    }
    else{
            _tutorialImage.frame = CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.width*0.2, self.view.frame.size.width-2*self.view.frame.size.width*0.1, self.view.frame.size.width-2*self.view.frame.size.width*0.1);
        NSLog(@"here");
    }

    
    
    //_tutorialImage.translatesAutoresizingMaskIntoConstraints = NO;
    /*[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_tutorialImage]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tutorialImage)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_tutorialImage(230)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tutorialImage)]];*/
    // title text
    _titleLabel = [UILabel new];
    self.titleLabel.text = self.pageTitle;
    self.titleLabel.textColor = darkBrownColor;
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.numberOfLines = 3;
    [self.view addSubview:_titleLabel];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_titleLabel]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_titleLabel)]];

    // description label
    _descriptionLabel = [UILabel new];
    self.descriptionLabel.text = self.pageDescription;
    self.descriptionLabel.textColor = darkBrownColor;
    _descriptionLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    _descriptionLabel.numberOfLines = 4;
    [self.view addSubview:_descriptionLabel];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_descriptionLabel]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_descriptionLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-5-[_descriptionLabel]-110-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_titleLabel, _descriptionLabel)]];

    
    
    //kitapp logo
    _logoImage = [UIImageView new];
    _logoImage.image = [UIImage imageNamed:@"logo.png"];
    _logoImage.translatesAutoresizingMaskIntoConstraints = NO;
    /*[self.view addSubview:_logoImage];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-117-[_logoImage(110)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_logoImage)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-180-[_logoImage(102)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_logoImage)]];*/
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.delegate viewIsShown:self.pageIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
