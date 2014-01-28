//
//  DBManager.h
//  SqLite
//
//  Created by Devarajan on 09/10/13.
//  Copyright (c) 2013 Devarajan. All rights reserved.
//

#ifndef SqLite_DBManager_h
#define SqLite_DBManager_h

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager: NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
//-(BOOL) saveData:(NSString*)empNo name:(NSString*)name age:(NSString*)age address:(NSString)address;

-(NSArray*) findByEmpNo:(NSString*)empNo;

@end


#endif
