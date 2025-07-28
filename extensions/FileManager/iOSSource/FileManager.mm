//
//  Gallery.m
//  CameraApp
//
//  Created by Kaguva Games on 8/5/17.
//  Copyright © 2017 Kaguva Games. All rights reserved.
//

#import<Foundation/Foundation.h>

#import "FileManager.h"

const int EVENT_OTHER_SOCIAL = 70;
extern int CreateDsMap( int _num, ... );
extern void CreateAsynEventWithDSMap(int dsmapindex, int event_index);
	extern UIViewController *g_controller;
	extern UIView *g_glView;
	extern int g_DeviceWidth;
	extern int g_DeviceHeight;


@implementation FileManager{
	
	NSFileManager *files;
	
}    
	

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialize self
        files=[NSFileManager new];
    }
    return self;
}

-(NSString*)FileManager_getUserPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0]; // Get documents folder
}

-(NSString*)FileManager_getTemporaryPath
{
	NSURL *url=[files temporaryDirectory];
        return [url path];
}

-(NSString*)FileManager_getParentPath:(NSString*)Path
{
    return [Path stringByDeletingLastPathComponent];
}

-(double)FileManager_DirectoryCreate:(NSString*)Path
{
        if([files createDirectoryAtPath:Path withIntermediateDirectories:true attributes:NULL error:NULL])
            return 1;
        else
            return 0;	
}

-(double)FileManager_FileCreate:(NSString*)Path
{        
        if([files createFileAtPath:Path contents:NULL attributes:NULL])
            return 1;
        else
            return 0;
}

-(double)FileManager_FileRemove:(NSString*)Path
{        
        if([files removeItemAtPath:Path error:NULL])
            return 1;
        else
            return 0;
}

-(double)FileManager_DirectoryRemove:(NSString*)Path
{
        if([files removeItemAtPath:Path error:NULL])
            return 1;
        else
            return 0;
}

-(double)FileManager_FileCopy:(NSString*)Path PathTo: (NSString*)Path2
{        
        if([files copyItemAtPath:Path toPath:Path2 error:NULL])
            return 1;
        else
            return 0;
}

-(double)FileManager_FileMove:(NSString*)Path PathTo: (NSString*)Path2
{

        
        if([files moveItemAtPath:Path toPath:Path2 error:NULL])
            return 1;
        else
            return 0;	
}

-(double)FileManager_FileExists:(NSString*)Path
{        
        if([files fileExistsAtPath:Path])
            return(1);
        else
            return(0);
}

-(double)FileManager_DirectoryExists:(NSString*)Path
{
        if([files fileExistsAtPath:Path])
            return(1);
        else
            return(0);	
}

-(double)FileManager_FileReadable:(NSString*)Path
{       
        if([files isReadableFileAtPath:Path])
            return(1);
        else
            return(0);
	
}

-(double)FileManager_FileWritable:(NSString*)Path
{
        
        if([files isWritableFileAtPath:Path])
            return(1);
        else
            return(0);	
}

-(double)FileManager_FileExecutable:(NSString*)Path
{       
        if([files isExecutableFileAtPath:Path])
            return(1);
        else
            return(0);
}

-(double)FileManager_FileDeletable:(NSString*)Path
{
if([files isDeletableFileAtPath:Path])
            return(1);
        else
            return(0);	
}

-(double)FileManager_isDirectory:(NSString*)Path
{
BOOL isDirectory;
            BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:Path isDirectory:&isDirectory];
            if (fileExistsAtPath)
                if (isDirectory)
                    return 1;
        return 0;	
}

-(NSString*)FileManager_getDirectoryContent:(NSString*)Path
{
	 NSFileManager *files=[NSFileManager new];
        NSArray *FilesArray=[files contentsOfDirectoryAtPath:Path error:NULL];
        
        NSUInteger size=[FilesArray count];
        
        NSDictionary *dictionary = [[NSMutableDictionary alloc] init];
        //[dictionary setValue:@"size" forKey:[NSString stringWithFormat:@"%d", (int)size]];

        int fileCount=0,folderCount=0;
        for(int a=0;a<size;a++)
        {
            
            BOOL isDirectory;
            BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:[[Path stringByAppendingString:@"/"] stringByAppendingString:FilesArray[a]] isDirectory:&isDirectory];
            if (fileExistsAtPath)
            {
                if (isDirectory)
                {
                    [dictionary setValue:FilesArray[a] forKey:[NSString stringWithFormat:@"Folder%d", folderCount]];
                    folderCount++;
                }
                else
                {
                    [dictionary setValue:FilesArray[a] forKey:[NSString stringWithFormat:@"File%d", fileCount]];
                    fileCount++;
                }
            }
        }
        
        [dictionary setValue:[NSString stringWithFormat:@"%d",folderCount] forKey:@"FolderCount"];
        [dictionary setValue:[NSString stringWithFormat:@"%d", fileCount] forKey:@"FileCount"];
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}

@end



