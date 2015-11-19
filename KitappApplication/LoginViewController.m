//
//  LoginViewController.m
//  KitappApplication
//
//  Created by Olga Khvan on 30.06.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <AFViewShaker.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImage+Scale.h"
@interface LoginViewController ()

@property (nonatomic) UITextField *usernameTextField;
@property (nonatomic) UITextField *passwordTextField;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UIImageView *bgImage;
@property (nonatomic) UIView *usernameTextFieldSeperator;
@property (nonatomic) UIView *passwordTextFieldSeperator;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UILabel *errorLabel;
@property (nonatomic) AFViewShaker *shakeView;
@property (nonatomic) UIView *barBackgroundView;
@property (nonatomic) UILabel *windowTitle;
@property (nonatomic) UIScrollView *scrollView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    //colors
    UIColor *beigeLightColor = [UIColor colorWithRed:1.0 green:249/255.0 blue:243/255.0 alpha:1.0];
    UIColor *beigeDarkColor = [UIColor colorWithRed:215/255.0 green:201/255.0 blue:191/255.0 alpha:1.0];
    UIColor *darkBrownColor = [UIColor colorWithRed:117/255.0 green:91/255.0 blue:78/255.0 alpha:1];
    
    
    NSDictionary *placeholderAttributes = @{
                                            NSForegroundColorAttributeName : [UIColor colorWithRed:117/255.0 green:91/255.0 blue:78/255.0 alpha:0.5]
                                            };
    [super viewDidLoad];
    _scrollView = [UIScrollView new];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-100);
    _scrollView.frame = self.view.bounds;
    [self.view addSubview:_scrollView];
    
    self.view.backgroundColor = beigeLightColor;
    _barBackgroundView = [UIView new];
    _barBackgroundView.backgroundColor = beigeDarkColor;
    _barBackgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, 70);
    [self.view addSubview:_barBackgroundView];
    
    //cancel button
    _cancelButton = [UIButton new];
    UIImage *cancelButtonImage = [UIImage imageNamed:@"closeIcon.png"];
    cancelButtonImage = [cancelButtonImage scaledToSize:CGSizeMake(25, 25)];
    [_cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.frame = CGRectMake(20, 30, 25, 25);
    [self.view addSubview:_cancelButton];
    [_cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    //text fields
    _usernameTextField = [UITextField new];
    _usernameTextField.textAlignment = NSTextAlignmentCenter;
    _usernameTextField.textColor = darkBrownColor;
    [_usernameTextField setFont:[UIFont fontWithName:@"Helvetica-Light" size:18]];
    NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:@"Номер телефона" attributes:placeholderAttributes];
    _usernameTextField.attributedPlaceholder = placeholderString;
    _usernameTextField.keyboardType = UIKeyboardTypePhonePad;
    _usernameTextField.frame = CGRectMake(20, 200, self.view.frame.size.width-40, 40);
    [_scrollView addSubview:_usernameTextField];
    _usernameTextFieldSeperator = [UIView new];
    _usernameTextFieldSeperator.backgroundColor = darkBrownColor;
    _usernameTextFieldSeperator.alpha = 0.3;
    _usernameTextFieldSeperator.frame = CGRectMake(20, CGRectGetMaxY(_usernameTextField.frame)-5, self.view.frame.size.width-40, 1);
    [_scrollView addSubview:_usernameTextFieldSeperator];
    
    _passwordTextField = [UITextField new];
    _passwordTextField.textAlignment = NSTextAlignmentCenter;
    _passwordTextField.textColor = darkBrownColor;
    [_passwordTextField setFont:[UIFont fontWithName:@"Helvetica-Light" size:18]];
    NSAttributedString *passwordString = [[NSAttributedString alloc] initWithString:@"Пароль" attributes:placeholderAttributes];
    _passwordTextField.attributedPlaceholder = passwordString;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.frame = CGRectMake(20, CGRectGetMaxY(_usernameTextField.frame), self.view.frame.size.width-40, 40);
    [_scrollView addSubview:_passwordTextField];
    _passwordTextFieldSeperator = [UIView new];
    _passwordTextFieldSeperator.backgroundColor = darkBrownColor;
    _passwordTextFieldSeperator.alpha = 0.3;
    _passwordTextFieldSeperator.frame = CGRectMake(20, CGRectGetMaxY(_passwordTextField.frame)-5, self.view.frame.size.width-40, 1);
    [_scrollView addSubview:_passwordTextFieldSeperator];
    
    _errorLabel = [UILabel new];
    [self.view addSubview:_errorLabel];
    _errorLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.textColor = [UIColor redColor];
    _errorLabel.frame = CGRectMake(20, CGRectGetMaxY(_passwordTextField.frame), self.view.frame.size.width-40, 25);
    [_scrollView addSubview:_errorLabel];
    
    _loginButton = [UIButton new];
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 10.f;
    _loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loginButton.titleLabel.textColor = beigeLightColor;
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"buttonNormalStateImage.png"] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"buttonTouchDownStateImage.png"] forState:UIControlStateHighlighted];
    _loginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    [_loginButton setTitle:@"Войти" forState:UIControlStateNormal];
    _loginButton.frame = CGRectMake(85, CGRectGetMaxY(_errorLabel.frame)+10, self.view.frame.size.width-170, 42);
    [_scrollView addSubview:_loginButton];
    [_loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    _windowTitle = [UILabel new];
    [_windowTitle setTextColor:beigeLightColor];
    _windowTitle.textAlignment = NSTextAlignmentCenter;
    [_windowTitle setFont:[UIFont fontWithName:@"Helvetica-Regular" size:25]];
    [_windowTitle setText:@"ВХОД"];
    _windowTitle.frame = CGRectMake(80, 25, self.view.frame.size.width-160, 40);
    [self.view addSubview:_windowTitle];

    NSArray *allFields = @[_usernameTextField, _passwordTextField];
    _shakeView = [[AFViewShaker alloc] initWithViewsArray:allFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - IBOutlet Actions
-(void)loginButtonPressed{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Проверка данных";
    
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        
                                        if (user) {
                                            
                                            BOOL isManager = [user[@"isManager"] boolValue];
                                            if (!isManager) {
                                                [self performSegueWithIdentifier:@"loginMoveToPopularBooks" sender:self];
                                            } else {
                                                
                                            }
                                            
                                            NSLog(@"Logged in");
                                            [hud hide:YES];
                                        } else {
                                            [_shakeView shake];
                                            [_errorLabel setText:@"данные введены неправильно"];
                                            [hud hide:YES];
                                            //NSString *errorString = [error userInfo][@"error"];
                                            //NSLog(@"There is an error", errorString);
                                        }
                                    }];
}
-(void)cancelButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

#pragma mark - Keyboard actions
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - scrollView insets
- (void)keyboardWillShow:(NSNotification *)notification
{
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 400, 0);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
