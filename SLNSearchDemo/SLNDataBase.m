//
//  SLNDataBase.m
//  SLNSearchDemo
//
//  Created by 乔冬 on 17/3/17.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "SLNDataBase.h"

@implementation SLNDataBase
@synthesize slnManagedObjectContext = _slnManagedObjectContext,
                 slnManagedObjectModel = _slnManagedObjectModel,
                 slnPersistentStoreCoordinator = _slnPersistentStoreCoordinator;

#pragma mark - Core Data Saving support
- (void)slnSaveContext{
    NSError *error = nil;
    NSManagedObjectContext  *slnManagedObjectContext = self.slnManagedObjectContext;
    if ([slnManagedObjectContext hasChanges] && ![slnManagedObjectContext save:&error]) {
        abort();
    }
}
#pragma mark - Core Data stack
/*
    返回应用程序的管理对象上下文。
    如果不存在,就创建并绑定到应用程序的持久性存储协调员。
 */
-(NSManagedObjectContext *)slnManagedObjectContext{
    if (_slnManagedObjectContext != nil) {
        return _slnManagedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self slnPersistentStoreCoordinator];
    if (coordinator != nil) {
        _slnManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [_slnManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _slnManagedObjectContext;
}
//返回应用程序的托管对象模型。
//如果模型不存在,它从应用程序的创建模型。
-(NSManagedObjectModel *)slnManagedObjectModel{
    if (_slnManagedObjectModel != nil) {
        return _slnManagedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SLNModel" withExtension:@"momd"];
    _slnManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _slnManagedObjectModel;
}
/*
   返回应用程序的持久性存储协调员。
 如果协调不存在,it is created and the application's store added to it.
 */
-(NSPersistentStoreCoordinator *)slnPersistentStoreCoordinator{

    if (_slnPersistentStoreCoordinator != nil) {
        return _slnPersistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SLNModel.sqlite"];
    
    NSError *error = nil;
    _slnPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self slnManagedObjectModel]];
    if (![_slnPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _slnPersistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// 将URL返回给应用程序的文档目录。
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)slnInsertCoreData:(NSMutableArray *)dataArray{

    for (SLNHostory *hostory in dataArray) {
        [self slnInsertPerCoreDataObject:hostory];
    }
}
-(BOOL )isRepeatInsertOneDataObject:(SLNHostory *)hostory{
    BOOL isRepeat = NO;
    for (SLNHostory *sy in [self slnSelectAllCoreData].copy) {
        NSLog(@"%@",sy.title);
        if ([sy.title isEqualToString: hostory.title]){
            isRepeat = YES;  break;
        }else{
//             isRepeat = NO;
        }
    }
     return isRepeat;
}
-(void)slnInsertPerCoreDataObject:(SLNHostory *)hostory{
    if ([self isRepeatInsertOneDataObject:hostory]) {
        return;
    }
    //获得上下文
    NSManagedObjectContext *context = [self slnManagedObjectContext];
    //循环插入数据
    SLNHostory *newHostory = [NSEntityDescription insertNewObjectForEntityForName:SLNTableName inManagedObjectContext:context];
    //设置属性
    newHostory.title = hostory.title;
    // 利用上下文对象，将数据同步到持久化存储库
    NSError *error = nil;
    BOOL success = [context save:&error];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 如果是想做更新操作：只要在更改了实体对象的属性后调用[context save:&error]，就能将更改的数据同步到数据库

}
-(NSMutableArray *)slnSelectAllCoreData{
        //获得上下文
        NSManagedObjectContext *context = [self slnManagedObjectContext];
        //初始化查询请求对象
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        //限定查询结果的数量
    //    [request setFetchLimit:10];
        // 比如：正常返回：1，2，3，4，5     setFetchOffset为1 返回的值：2，3，4 .如果是5，返回为空。
    //    [request setFetchOffset:5];
        //设置查询的实体
        request.entity = [NSEntityDescription entityForName:SLNTableName inManagedObjectContext:context];
        
        // 设置排序（按照age降序）
//            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
        //    request.sortDescriptors = [NSArray arrayWithObject:sort];
            // 设置条件过滤(搜索name中包含字符串"it-1"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%it-1%应该写成*it-1*)
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*it-1*"];
        //    request.predicate = predicate;
        NSError *error = nil;
        NSArray *fetchedArray = [context executeFetchRequest:request error:&error];
        if (error) {
            [NSException raise:@"查询出错" format:@"%@", [error localizedDescription]];
        }
      return [[fetchedArray.mutableCopy reverseObjectEnumerator] allObjects].mutableCopy;
}

-(void)slndeleteAllCoreData{
    NSMutableArray *array = [self slnSelectAllCoreData];

    for (NSManagedObject *object in array) {
        [self slndeletePerManagedObject:object];
    }
}

-(void)slndeletePerManagedObject:(NSManagedObject *)object{
    [self.slnManagedObjectContext deleteObject:object];
        NSError *error;
    [self.slnManagedObjectContext save:&error];
    if (error) {
        [NSException raise:@"查询出错" format:@"%@", [error localizedDescription]];
    }
}

-(SLNHostory*)createSLNHostoryEntity{
  SLNHostory *hostory = (SLNHostory *) [[NSManagedObject alloc]initWithEntity:[NSEntityDescription entityForName:@"SLNHostory" inManagedObjectContext:self.slnManagedObjectContext] insertIntoManagedObjectContext:nil] ;
    return hostory;
}
-(SLNHostory *)createSLNHostoryEntityWithTitle:(NSString *)string{
    SLNHostory *hostory  = [self createSLNHostoryEntity ];
    hostory.title = string;
  return   hostory;
}
-(void)insertAndCreateSLNHostoryEntityWithTitle:(NSString *)string{
    [self slnInsertPerCoreDataObject: [self createSLNHostoryEntityWithTitle:string] ];
}
-(NSArray *)readInsertAndCreateSLNHostoryEntityWithTitle:(NSString *)string{
    [self slnInsertPerCoreDataObject: [self createSLNHostoryEntityWithTitle:string] ];
    return [self slnSelectAllCoreData].copy;
}
-(NSArray *)readDeletePerManagedObject:(NSManagedObject *)object{
     [self slndeletePerManagedObject:object ];
    return [self slnSelectAllCoreData].copy;
}
-(NSArray *)readDeleteAllCoreData{
    [self slndeleteAllCoreData ];
    return [self slnSelectAllCoreData].copy;
}
@end
