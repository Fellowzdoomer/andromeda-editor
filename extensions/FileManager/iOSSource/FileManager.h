//
//  Gallery.h
//  CameraApp
//
//  Created by Kaguva Games on 8/5/17.
//  Copyright © 2017 Kaguva Games. All rights reserved.
//

#ifndef FileManager_h
#define FileManager_h


#endif /* FileManager_h */

#import <UIKit/UIKit.h>


@interface FileManager : NSObject
{

}

@property (nonatomic, retain) NSString* ImagePath;


-(NSString*)FileManager_getUserPath;
-(NSString*)FileManager_getTemporaryPath;
-(NSString*)FileManager_getParentPath:(NSString*)Path;
-(double)FileManager_DirectoryCreate:(NSString*)Path;
-(double)FileManager_FileCreate:(NSString*)Path;
-(double)FileManager_FileRemove:(NSString*)Path;
-(double)FileManager_DirectoryRemove:(NSString*)Path;
-(double)FileManager_FileCopy:(NSString*)Path PathTo: (NSString*)Path;
-(double)FileManager_FileMove:(NSString*)Path PathTo: (NSString*)Path;
-(double)FileManager_FileExists:(NSString*)Path;
-(double)FileManager_DirectoryExists:(NSString*)Path;
-(double)FileManager_FileReadable:(NSString*)Path;
-(double)FileManager_FileWritable:(NSString*)Path;
-(double)FileManager_FileExecutable:(NSString*)Path;
-(double)FileManager_FileDeletable:(NSString*)Path;
-(double)FileManager_isDirectory:(NSString*)Path;
-(NSString*)FileManager_getDirectoryContent:(NSString*)Path;


@end
