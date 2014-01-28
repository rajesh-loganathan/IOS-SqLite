//
//  SqLiteViewController.m
//  SqLite
//
//  Created by Devarajan on 09/10/13.
//  Copyright (c) 2013 Devarajan. All rights reserved.
//

#import "SqLiteViewController.h"

@interface SqLiteViewController ()

@end

@implementation SqLiteViewController

@synthesize empNoTxt,empNameTxt, empAgeTxt, empAddressTxt, status;

NSString *databasePath;

NSString *empID;

NSInteger e_id;

- (void)viewDidLoad

    {
        NSString *docsDir;
        NSArray *dirPaths;
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        docsDir = [dirPaths objectAtIndex:0];
        
        // Build the path to the database file
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contacts.db"]];
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if ([filemgr fileExistsAtPath: databasePath ] == NO)
        {
            const char *dbpath = [databasePath UTF8String];
            
            if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
            {
                char *errMsg;
                const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, EMP_NO TEXT, EMP_NAME TEXT, EMP_AGE TEXT, EMP_ADDRESS TEXT)";
                
                               
                if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    status.text = @"Failed to create table";
                }
                
                sqlite3_close(contactDB);
                
            }
            
            else {
                status.text = @"Failed to open/create database";
            }
        }
        
        //[filemgr release];
        [super viewDidLoad];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //Iterate through your subviews, or some other custom array of views
    for (UIView *view in self.view.subviews)
        [view resignFirstResponder];
}



-(IBAction)saveData
{
    if(empNoTxt.text.length > 0 && empNameTxt.text.length > 0 && empAgeTxt.text.length > 0 && empAddressTxt.text.length > 0)
    {
    sqlite3_stmt *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO CONTACTS (emp_no, emp_name, emp_age, emp_address) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", empNoTxt.text, empNameTxt.text, empAgeTxt.text, empAddressTxt.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            status.text = @"Contact added";
            empNoTxt.text = @"";
            empNameTxt.text = @"";
            empAgeTxt.text = @"";
            empAddressTxt.text = @"";
        }
        
        //else {
           // status.text = @"Failed to add contact";
        //}
        
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    }
    
    else
    {
    status.text = @"Please enter all fields";
    }
}

-(IBAction)findData


{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT emp_no, emp_name, emp_age, emp_address, id FROM contacts WHERE emp_no=\"%@\"", empNoTxt.text];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                empID= [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                empNoTxt.text = empID;
                
                NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                empNameTxt.text = nameField;
                            
                NSString *ageField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                empAgeTxt.text = ageField;
                
                NSString *addrField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                empAddressTxt.text = addrField;
                
                
                e_id = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)] integerValue];
                
                status.text = @"Match found";
                
                //[addressField release];
                //[phoneField release];
            }
            
            else {
                status.text = @"Match not found";
                empNameTxt.text = @"";
                empAgeTxt.text = @"";
                empAddressTxt.text = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


-(IBAction)update
{
        sqlite3_stmt *statement;
        
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            

            NSString *updateSQL = [NSString stringWithFormat: @"UPDATE CONTACTS SET emp_no=\"%@\" emp_name=\"%@\" emp_age=\"%@\" emp_address=\"%@\" WHERE emp_no=\"%@\"", empNoTxt.text, empNameTxt.text, empAgeTxt.text, empAddressTxt.text, empNoTxt.text];
            
            const char *update_stmt = [updateSQL UTF8String];
            
            if(sqlite3_prepare_v2(contactDB, update_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
            
                status.text = @"Contact Updated";
                empNoTxt.text = @"";
                empNameTxt.text = @"";
                empAgeTxt.text = @"";
                empAddressTxt.text = @"";
                        
            //else {
            // status.text = @"Failed to add contact";
            //}
            }
            sqlite3_finalize(statement);
        }
    sqlite3_close(contactDB);
    
}   

@end

