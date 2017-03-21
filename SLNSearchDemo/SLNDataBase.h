//
//  SLNDataBase.h
//  SLNSearchDemo
//
//  Created by 乔冬 on 17/3/17.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SLNHostory+CoreDataProperties.h"
#import "SLNHostory+CoreDataClass.h"
#define SLNTableName @"SLNHostory"

@interface SLNDataBase : NSObject

@property (readonly,nonatomic,strong)  NSManagedObjectContext *slnManagedObjectContext;

@property (readonly,nonatomic,strong)  NSManagedObjectModel *slnManagedObjectModel;

@property (readonly,nonatomic,strong)  NSPersistentStoreCoordinator * slnPersistentStoreCoordinator ;
//创建SLNHostory类
-(SLNHostory*)createSLNHostoryEntity;
//通过文字赋值创建SLNHostory类
-(SLNHostory *)createSLNHostoryEntityWithTitle:(NSString *)string;
//通过文字赋值创建SLNHostory类，并且插入到数据库中
-(void)insertAndCreateSLNHostoryEntityWithTitle:(NSString *)string;
//通过文字赋值创建SLNHostory类，并且插入到数据库中；然后从数据库读取所有的数据
-(NSArray *)readInsertAndCreateSLNHostoryEntityWithTitle:(NSString *)string;
//从数据库删除某一个对象，然后从数据库读取所有的数据
-(NSArray *)readDeletePerManagedObject:(NSManagedObject *)object;
//删除所有数据，并且重新读取
-(NSArray *)readDeleteAllCoreData;

- (void) slnSaveContext;
- (NSURL *)applicationDocumentsDirectory;
//插入数据
- (void)slnInsertCoreData:(NSMutableArray *)dataArray;
-(void)slnInsertPerCoreDataObject:(SLNHostory *)hostory;
//查询所有的数据
-(NSMutableArray *)slnSelectAllCoreData;

//删除所有的数据
-(void)slndeleteAllCoreData;
//删除一条对象
-(void)slndeletePerManagedObject:(NSManagedObject *)object;
@end
