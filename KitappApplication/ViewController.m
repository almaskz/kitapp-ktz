//
//  ViewController.m
//  KitappApplication
//
//  Created by Olga Khvan on 30.06.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "MainViewController1.h"
#import "UIDeviceHardware.h"


@interface ViewController () <MainViewController1Delegate>

@property (nonatomic) UIButton *signupButton;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UIButton *nextButton;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    //[self.view addSubview:pageControl];
    _signupButton = [UIButton new];
    _loginButton = [UIButton new];
    _nextButton = [UIButton new];
    UIColor *beigeLightColor = [UIColor colorWithRed:1.0 green:249/255.0 blue:243/255.0 alpha:1.0];
    UIColor *beigeDarkColor = [UIColor colorWithRed:238/255.0 green:225/255.0 blue:208/255.0 alpha:1.0];
    UIColor *darkBrownColor = [UIColor colorWithRed:117/255.0 green:91/255.0 blue:78/255.0 alpha:1];
    UIColor *brownReddishColor = [UIColor colorWithRed:138/255.0 green:82/255.0 blue:51/255.0 alpha:1];
    
    self.view.backgroundColor = beigeLightColor;

    self.backgrounds = @[@"1screen.png", @"2screen.png", @"3screen.png"];
    self.pageTitles = @[@"Продавай старые книги", @"Покупай книги по доступным ценам", @"Знакомься с новыми людьми"];
    self.pageDescription = @[@"Выстави на продажу книгу всего за несколько касаний, и она моментально появится на главной странице", @"Теперь букинист помещается в твоем мобильном телефоне! Находи то, что давно искал и покупай книги без посредников.", @"Договаривайся о встречах и находи новых друзей!"];
    

    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageVC"];
    self.pageViewController.dataSource = self;
    
    MainViewController1 *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0,
                                                    [[self view] bounds].size.width, [[self view] bounds].size.height);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

    //signup button
    _signupButton.layer.masksToBounds = YES;
    _signupButton.layer.cornerRadius = 10.f;
    
    _signupButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    //[_signupButton setBackgroundColor:darkBrownColor];
    
    [_signupButton setBackgroundImage:[UIImage imageNamed:@"buttonNormalStateImage.png"] forState:UIControlStateNormal];
    [_signupButton setBackgroundImage:[UIImage imageNamed:@"buttonTouchDownStateImage.png"] forState:UIControlStateHighlighted];
    [_signupButton setTitle:@"Регистрация" forState:UIControlStateNormal];
    [_signupButton setTitleColor:beigeLightColor forState:UIControlStateNormal];
    [self.view addSubview:_signupButton];
    [_signupButton addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _signupButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[_signupButton]-70-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_signupButton)]];
    
    
    //login button
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setTitle:@"Уже зарегистрированы? Вход" forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12];
    //_loginButton.layer.backgroundColor = [UIColor colorWithRed:221/255.0 green:66/255.0 blue:66/255.0 alpha:1.0].CGColor;
    [_loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [_loginButton setTitleColor:darkBrownColor forState:UIControlStateNormal];
    [self.view addSubview:_loginButton];
    
    _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_loginButton]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_loginButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_signupButton(35)]-[_loginButton(30)]-15-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_signupButton,_loginButton)]];
    
    //next button
    _nextButton.layer.masksToBounds = YES;
    [_nextButton setTitle:@"дальше" forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    [_nextButton setTitleColor:darkBrownColor forState:UIControlStateNormal];
    _nextButton.layer.cornerRadius = 10.0;
    _nextButton.layer.borderColor = darkBrownColor.CGColor;
    _nextButton.layer.borderWidth = 1.0;
    [_nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_nextButton];
    
    _nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-80-[_nextButton]-80-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_nextButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_nextButton(35)]-15-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_nextButton)]];

    
    // initial visibility
    _loginButton.hidden = YES;
    _signupButton.hidden = YES;
    _nextButton.hidden = NO;
   
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"viewControllerToPopularBooks" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((MainViewController1 *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((MainViewController1 *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - Helper methods
- (MainViewController1 *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    MainViewController1 *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVC1"];
    pageContentViewController.imageFile = self.backgrounds[index];
    pageContentViewController.pageTitle = self.pageTitles[index];;
    pageContentViewController.pageDescription = self.pageDescription[index];
    pageContentViewController.pageIndex = index;
    pageContentViewController.delegate = self;
    
    return pageContentViewController;
}

#pragma mark - IBOutlet methods

-(void) signupButtonPressed:(UIButton *)button
{
    [self performSegueWithIdentifier:@"VCToSignUpVC" sender:self];
}

-(void) loginButtonPressed: (UIButton *) button{
    [self performSegueWithIdentifier:@"VCToLoginVC" sender:self];
}

-(void) nextButtonPressed: (UIButton *) button{
    MainViewController1 *viewController = (MainViewController1 *)[self.pageViewController.viewControllers objectAtIndex:0];
    NSLog(@"page index = %d", viewController.pageIndex);
    
    if (viewController.pageIndex+1 >= self.pageTitles.count) {
        return;
    }
    
    MainViewController1 *startingViewController = [self viewControllerAtIndex:viewController.pageIndex + 1];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    
}


-(void)viewIsShown:(NSUInteger)pageIndex
{
    if (pageIndex == self.pageTitles.count - 1) {
        //last page
        _nextButton.hidden = YES;
        _signupButton.hidden = NO;
        _loginButton.hidden = NO;
    } else {
        _nextButton.hidden = NO;
        _signupButton.hidden = YES;
        _loginButton.hidden = YES;

    }
}


//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return [self.pageTitles count];
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}


@end

























































