//
//  ReviewBookViewController.h
//  KitappApplication
//
//  Created by Olga Khvan on 03.07.15.
//  Copyright (c) 2015 Olga Khvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface ReviewBookViewController : UIViewController

@property (nonatomic) Book *book;
-(void)call:(NSString *) phoneNumber;
@property (nonatomic) BOOL isManagerViewing;

@property (nonatomic) int trainNumber;
@property (nonatomic) int seatNumber;

@end
