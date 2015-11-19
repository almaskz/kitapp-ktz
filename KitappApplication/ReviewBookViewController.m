//
//  ReviewBookViewController.m
//  KitappApplication
//
//  Created by Olga Khvan on 03.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "ReviewBookViewController.h"
#import "Book.h"
#import "UIImage+Scale.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ReviewBookViewController () <UIAlertViewDelegate>
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) UIButton *bkmrkButton;
@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIButton *deleteButton;
@property (nonatomic) UIButton *callButton;

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *authorLabel;
@property (nonatomic) UILabel *sellerLabel;
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UILabel *genreLabel;
@property (nonatomic) UILabel *telephoneLabel;

@property (nonatomic) BOOL isLiked;

@end

@implementation ReviewBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //colors
    UIColor *brownColor = [UIColor colorWithRed:118/255.0 green:92/255.0 blue:79/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:240/255.0 alpha:1.0];
    _scrollView = [UIScrollView new];
    _scrollView.frame = self.view.bounds;
    [self.view addSubview:_scrollView];

    _imageView = [UIImageView new];
    [self.view addSubview:_imageView];
    PFFile *imageFile = self.book.image;
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        UIImage *image = [UIImage imageWithData:data];
        image = [image scaledToSize:CGSizeMake(self.view.frame.size.width-140, self.view.frame.size.height*0.45)];
        self.imageView.image = image;
    }];
    [_scrollView addSubview:_imageView];
    _imageView.frame = CGRectMake(70, 60, self.view.frame.size.width-140, self.view.frame.size.height*0.45);
    //initialization
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont fontWithName:@"IowanOldStyle-Bold" size:23];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = brownColor;
    _titleLabel.text = self.book.title;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 3;
    [_scrollView addSubview:_titleLabel];
    _titleLabel.frame = CGRectMake(30, _imageView.frame.size.height+60, _scrollView.frame.size.width-60, 100);
    //NSLog(@"title label frame %f %f", (_imageView.frame.size.height+60), (_scrollView.frame.size.width-60));
    
    //author label
    _authorLabel = [UILabel new];
    _authorLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:18];
    _authorLabel.textColor = brownColor;
    _authorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _authorLabel.text = [NSString stringWithFormat:@"Автор: %@", self.book.author ];
    _authorLabel.textAlignment = NSTextAlignmentCenter;
    _authorLabel.numberOfLines = 3;
    [_scrollView addSubview:_authorLabel];
   _authorLabel.frame = CGRectMake(25, CGRectGetMaxY(_titleLabel.frame), self.view.frame.size.width-50, 50);
    //[_authorLabel sizeToFit];

    //seperator1
    UIButton *seperator1 = [UIButton new];
    [seperator1 setBackgroundColor:brownColor];
    [_scrollView addSubview:seperator1];
    seperator1.alpha = 0.5;
    seperator1.frame = CGRectMake(100, CGRectGetMaxY(_authorLabel.frame)+15, self.view.frame.size.width-200, 1);
    
    //seller label
    _sellerLabel = [UILabel new];
    _sellerLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:14];
    _sellerLabel.textColor = brownColor;
    _sellerLabel.adjustsFontSizeToFitWidth = YES;
    
    PFUser *user = _book[@"owner"];
    
    _sellerLabel.text = [NSString stringWithFormat:@"Продавец: %@", user.username];
    _sellerLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_sellerLabel];
    _sellerLabel.frame = CGRectMake(30, CGRectGetMaxY(seperator1.frame)+10, self.view.frame.size.width-60, 40);

    //call button
    _callButton = [UIButton new];
    [_callButton setTitle:@"Заказать" forState:UIControlStateNormal];
    [_callButton setTitleColor:[UIColor colorWithRed:255/255.0 green:247/255.0 blue:240/255.0 alpha:1.0] forState:UIControlStateNormal];
    //_callButton.layer.borderColor = [UIColor brownColor].CGColor;
    //_callButton.layer.borderWidth = 1.0;
    _callButton.layer.cornerRadius = 7.0;
    _callButton.backgroundColor = brownColor;
    _callButton.titleLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:16];
    _callButton.frame = CGRectMake(100, CGRectGetMaxY(_sellerLabel.frame)+5, self.view.frame.size.width-200, 32);
    [_scrollView addSubview:_callButton];
    [_callButton addTarget:self action:@selector(callButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isManagerViewing) {
        [_callButton setTitle:[NSString stringWithFormat:@"Вагон %d, место %d", self.trainNumber, self.seatNumber] forState:UIControlStateNormal];
    }
    
    
    //genre label
    _genreLabel = [UILabel new];
    _genreLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:18];
    _genreLabel.textColor = brownColor;
    _genreLabel.adjustsFontSizeToFitWidth = YES;
    _genreLabel.text = [NSString stringWithFormat:@"Жанр: %@", self.book.genre[@"title"]];
    _genreLabel.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:_genreLabel];
    _genreLabel.frame = CGRectMake(30, CGRectGetMaxY(_callButton.frame)+20, 200, 40);
    
    //price label
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:16];
    _priceLabel.textColor = brownColor;
    _priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _priceLabel.numberOfLines = 2;
    _priceLabel.backgroundColor = [UIColor whiteColor];
    _priceLabel.alpha = 0.7;
    _priceLabel.text = [NSString stringWithFormat:@"KZT: %@", self.book.price ];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_priceLabel];
    _priceLabel.frame = CGRectMake(70, _imageView.frame.size.height+40, _imageView.frame.size.width, 20);

    //description
    _descriptionLabel = [UILabel new];
    _descriptionLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:18];
    _descriptionLabel.textColor = brownColor;
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.text = _book.descr;
    _descriptionLabel.textAlignment = NSTextAlignmentJustified;
    [_scrollView addSubview:_descriptionLabel];
    _descriptionLabel.frame = CGRectMake(30, CGRectGetMaxY(_genreLabel.frame)+10, self.view.frame.size.width-60, 100);
    [_descriptionLabel sizeToFit];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(_descriptionLabel.frame)+20);
    
//    //back button
//    _backButton = [UIButton new];
//    _backButton.layer.masksToBounds = YES;
//    _backButton.frame = CGRectMake(75, 140, 35, 35);
//    /*_backButton.titleLabel.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:16];
//    [_backButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
//    [_backButton setTitle:@"назад" forState:UIControlStateNormal];*/
//    UIImage *backImage = [UIImage new];
//    backImage = [UIImage imageNamed:@"backIcon.png"];
//    backImage = [backImage scaledToSize:CGSizeMake(35, 35)];
//    [_backButton setImage:backImage forState:UIControlStateNormal];
//    [_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [_scrollView addSubview:_backButton];
//    _backButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_backButton]"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:NSDictionaryOfVariableBindings(_backButton)]];
//    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_backButton]"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:NSDictionaryOfVariableBindings(_backButton)]];
//    
//    //bookmark button
//    _bkmrkButton = [UIButton new];
//    _bkmrkButton.layer.masksToBounds = YES;
//    UIImage *bkmrkImage = [UIImage new];
////    [self getBookmarkState];
//    bkmrkImage = [bkmrkImage scaledToSize:CGSizeMake(30, 30)];
//    [_bkmrkButton setImage:bkmrkImage forState:UIControlStateNormal];
//    [_bkmrkButton addTarget:self action:@selector(bookmarkButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [_scrollView addSubview:_bkmrkButton];
//    
//    _bkmrkButton.frame = CGRectMake(self.view.frame.size.width-45, 25, 30, 30);
    

   
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object,  NSError *error){
        if(!error){
            _sellerLabel.text = [NSString stringWithFormat:@"Владелец: %@", object[@"name"]];
            _telephoneLabel.text = [NSString stringWithFormat:@"Телефон: %@", user[@"telephone"]];
        }
        else{
            NSLog(@"error in data fetch");
        }
    }];
    NSLog(@"telephone number %@ ", user[@"telephone"]);
    

    //[self.titleLabel sizeToFit];
    //[self.descriptionLabel sizeToFit];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button pressed functions
-(void)backButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) getBookmarkState
{
    PFQuery *query = [PFQuery queryWithClassName:@"Bookmark"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query whereKey:@"book" equalTo:self.book];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            if ([objects count] == 0) {
                // not liked
                _isLiked = NO;
                UIImage *image = [UIImage imageNamed:@"heartIcon.png"];
                [_bkmrkButton setImage:image forState:UIControlStateNormal];
            } else {
                // liked
                _isLiked = YES;
                NSLog(@"the book is liked");
                UIImage *image = [UIImage imageNamed:@"heartIconFilled.png"];
                [_bkmrkButton setImage:image forState:UIControlStateNormal];
            }
        }
    }];
    
}

-(void)bookmarkButtonPressed{

    if (!_isLiked){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        PFObject *object = [PFObject objectWithClassName:@"Bookmark"];
        PFUser *user = [PFUser currentUser];
        object[@"user"] = user;
        object[@"book"] = self.book;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded){
                NSLog(@"Bookmarked!");
                [self getBookmarkState];
                hud.hidden = YES;
            }
            else{
                NSLog(@"Some error");
                hud.hidden = YES;
            }
        }];
    }
    else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        PFQuery *query = [PFQuery queryWithClassName:@"Bookmark"];
        PFUser *user = [PFUser currentUser];
        [query whereKey:@"user" equalTo:user];
        [query whereKey:@"book" equalTo:self.book];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error){
                for (PFObject *object in objects){
                    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (!error)
                        {
                            hud.hidden = YES;
                            [self getBookmarkState];
                        }
                        else{
                            hud.hidden = YES;
                            NSLog(@"Error in object delete");
                        }
                    }];
                }
            }
            else{
                NSLog(@"Error in finding an object");
            }
        }];
    }

}

-(void)deleteButtonPressed{

}

-(void)call:(NSString *) phoneNumber{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNumber]]];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Не удалось совершить звонок" message:@"Попробуйте позднее" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}
-(void)callButtonPressed {
    
    if (self.isManagerViewing) {
        return;
    }
    
    PFObject *object = [PFObject objectWithClassName:@"Order"];
    object[@"trainNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"trainNumber"];
    object[@"seatNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"seatNumber"];
    object[@"book"] = self.book;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Оформление заказа";
    hud.hidden = NO;
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        hud.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Поздравляем" message:@"Ваш заказ отправлен проводнику" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
        
        // Send push notification to query
        [PFPush sendPushMessageToQueryInBackground:pushQuery
                                       withMessage:[NSString stringWithFormat:@"Новый заказ в %d вагон", [[[NSUserDefaults standardUserDefaults] objectForKey:@"trainNumber"] intValue]]];
        
    }];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end





