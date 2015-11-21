//
//  KTZ_ManagerTableViewController.m
//  KitappApplication
//
//  Created by Bakytzhan Baizhikenov on 11/19/15.
//  Copyright © 2015 Olga Khvan. All rights reserved.
//

#import "KTZ_ManagerTableViewController.h"
#import <Parse/Parse.h>
#import "ReviewBookViewController.h"

@interface KTZ_ManagerTableViewController ()

@property (nonatomic) NSArray *orders;

@end

@implementation KTZ_ManagerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getOrdersFromParse];
    
    [PFPush subscribeToChannelInBackground:@"manager" block:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"manager subscribed to channel: manager");
        }
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) getOrdersFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Order"];
    [query includeKey:@"book"];
    [query includeKey:@"book.owner"];
    [query includeKey:@"book.genre"];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.orders = objects;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *order = self.orders[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Заказ на книгу %@", order[@"book"][@"title"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Вагон %@, место %@", order[@"trainNumber"], order[@"seatNumber"]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"toReviewBookVC" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ReviewBookViewController class]]) {
        ReviewBookViewController *nextVC = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        PFObject *order = self.orders[indexPath.row];
        nextVC.book = order[@"book"];
        nextVC.isManagerViewing = YES;
        nextVC.trainNumber = [order[@"trainNumber"] intValue];
        nextVC.seatNumber = [order[@"seatNumber"] intValue];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
