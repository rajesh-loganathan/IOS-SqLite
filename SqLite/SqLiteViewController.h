//
//  SqLiteViewController.h
//  SqLite
//
//  Created by Devarajan on 09/10/13.
//  Copyright (c) 2013 Devarajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface SqLiteViewController : UIViewController<UITextFieldDelegate>
{
     UITextField *empNoTxt;
     UITextField *empNameTxt;
     UITextField *empAgeTxt;
     UITextField *empAddressTxt;
     UILabel *status;
     sqlite3 *contactDB;
}

    @property (retain, nonatomic) IBOutlet UITextField *empNoTxt;
    @property (retain, nonatomic) IBOutlet UITextField *empNameTxt;
    @property (retain, nonatomic) IBOutlet UITextField *empAgeTxt;
    @property (retain, nonatomic) IBOutlet UITextField *empAddressTxt;
    @property (retain, nonatomic) IBOutlet UILabel *status;


-(IBAction)saveData;
-(IBAction)findData;
-(IBAction)update;


@end
