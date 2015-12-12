//
//  FiboTableViewController.swift
//  FibonacciSwift
//
//  Created by Joffrey Mann on 12/11/15.
//  Copyright © 2015 Joffrey Mann. All rights reserved.
//

import UIKit

class FiboTableViewController: UITableViewController {
    var fiboQueue:dispatch_queue_t?
    var maxNum:NSInteger!
    var fibNumbers = [] as NSMutableArray
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxNum = 9999
        
        fiboQueue = dispatch_queue_create("fiboQueue", nil)
        
        fibNumbers = [1, 2]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return maxNum
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        var fibo:Int
        
        
        if indexPath.row < fibNumbers.count{
            fibo = fibNumbers[indexPath.row].integerValue
            if fibo > 0{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    (cell.textLabel?.text = NSString(format: "%ld with index %lu", Int64 (fibo), indexPath.row) as String)!
                })
            }
        }
        
        else{
            fibo = fibonacci(indexPath.row)
            dispatch_async(fiboQueue!, { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if fibo > 0 {
                        cell.textLabel?.text = NSString(format: "%ld with index %lu", Int64 (fibo), indexPath.row) as String
                    }
                    else {
                        self.tableView.reloadData()
                    }
                });
            });
        }
        // Configure the cell...

        return cell
    }
    

    //F(n) = F(n-1) + F(n-2)
    func fibonacci(index: Int) -> Int
    {
        var f:Int = 0
        
        if index < fibNumbers.count{
            f = fibNumbers[index].integerValue
        }
        
        else{
            f = (fibonacci((index-2))) + (fibonacci((index-1)))
            
            if f < NSIntegerMax{
                if f > 0{
                    fibNumbers.addObject(f)
                }
            }
            
            else{
                f = 0
                maxNum = index - 1
            }
        }
        
        return f
    }


}
