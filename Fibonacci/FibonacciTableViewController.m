//
//  FibonacciTableViewController.m
//  Fibonacci
//
//  Created by Joffrey Mann on 12/7/15.
//  Copyright © 2015 Joffrey Mann. All rights reserved.
//

#import "FibonacciTableViewController.h"

@interface FibonacciTableViewController ()
{
    dispatch_queue_t fiboQueue;
}

@property (nonatomic) NSInteger maxNum;
@property (strong, nonatomic) NSMutableArray *fibNumbers;

@end

@implementation FibonacciTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _maxNum = 10000;
    
    fiboQueue = dispatch_queue_create("fibo queue", nil);
    
    _fibNumbers = [NSMutableArray arrayWithObjects:@1, @2, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return _maxNum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    }
    
    __block NSInteger fibo;
    if ( indexPath.row < [_fibNumbers count] ) {
        fibo = [_fibNumbers[indexPath.row] integerValue];
        if (fibo > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)fibo];
            });
        }
    }
    else {
        dispatch_async(fiboQueue, ^{
            
            fibo = [self fibonacci:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (fibo > 0) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)fibo];
                }
                else {
                    [self.tableView reloadData];
                    //cell.textLabel.text = [NSString stringWithFormat:@"Max integer reached: %ld", NSIntegerMax];
                }
            });
            
        });
    }
    
    return cell;
}


//F(n) = F(n-1) + F(n-2)
- (NSInteger)fibonacci:(NSInteger)index
{
    NSInteger f;
    
    if ( index < [_fibNumbers count] ) {
        f = [_fibNumbers[index] integerValue];
    }
    else {
        [NSThread sleepForTimeInterval:0.1];
        
        f = [self fibonacci:(index-2)] + [self fibonacci:(index-1)];
        
        if ((f < NSIntegerMax)&&(f > 0)) {
            [_fibNumbers addObject:@(f)];
        }
        else {
            f = 0;
            _maxNum = index-1;
        }
    }
    
    return f;
}

@end
