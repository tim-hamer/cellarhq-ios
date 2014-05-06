#import <Foundation/Foundation.h>

@interface Beer : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *brewery;
@property (nonatomic) NSString *year;
@property (nonatomic) int quantity;
@property (nonatomic) NSString *bottleDate;
@property (nonatomic) NSString *size;
@property (nonatomic) NSString *notes;


@property (nonatomic) NSString *uniqueId;
@property (nonatomic) NSString *beerId;
@property (nonatomic) NSString *breweryId;

@end
