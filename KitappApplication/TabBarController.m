//
//  TabBarController.m
//  KitappApplication
//
//  Created by Olga Khvan on 09.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import "TabBarController.h"
#import "UIImage+Scale.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    tabBar.tintColor = [UIColor brownColor];
    
    //tabBar.backgroundImage = [UIImage imageNamed:@"tabBarBackgroundImage.png"];
    //tabBar.alpha = 1.0;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor grayColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
    UIColor *titleHighlightedColor = [UIColor brownColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor,
                                                       NSForegroundColorAttributeName,
                                                       nil]
                                             forState:UIControlStateSelected];
    UIImage *item0Image = [UIImage imageNamed:@"allBooksIcon.png"];
    item0Image = [item0Image scaledToSize:CGSizeMake(27, 27)];
    item0.image = item0Image;
    
//    UIImage *item1Image = [UIImage imageNamed:@"addBookIcon.png"];
//    item1Image = [item1Image scaledToSize:CGSizeMake(27, 27)];
//    item1.image = item1Image;
    
    UIImage *item2Image = [UIImage imageNamed:@"myProfileIcon.png"];
    item2Image = [item2Image scaledToSize:CGSizeMake(27, 27)];
    item2.image = item2Image;

    item0.title = @"Все книги";
//    item1.title = @"Добавить книгу";
    item2.title = @"Профиль";
    tabBar.tintColor =  [UIColor brownColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}



@end
