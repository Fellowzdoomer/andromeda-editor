package ${YYAndroidPackageName};
import ${YYAndroidPackageName}.R;
import com.yoyogames.runner.RunnerJNILib;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

import android.util.Log;

import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import java.io.File;
import android.graphics.Bitmap;
import android.os.Bundle;
import java.io.ByteArrayOutputStream;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
//import android.support.v7.app.AppCompatActivity;
import android.content.pm.PackageManager;
import android.Manifest;
import android.os.Build;
import android.app.Activity;
import android.os.Environment;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class FileManager  extends RunnerSocial{

	int REQUEST_CODE_FILE=15;

    public String FileManager_getParentPath(String Path)
    {
        File mFile=new File(Path);
        return(mFile.getParent());
    }

    public double FileManager_DirectoryCreate(String Path)
    {
        File mFile=new File(Path);
        if(mFile.mkdirs())return 1; else return 0;
    }

    public double FileManager_FileCreate(String Path)
    {
        File mFile=new File(Path);
        try {
            if(mFile.createNewFile())return 1; else return 0;
        } catch (IOException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public double FileManager_FileRemove(String Path)
    {
        File mFile=new File(Path);
        if(mFile.delete())return 1; else return 0;
    }

    public double FileManager_DirectoryRemove(String Path)
    {
        File mFile=new File(Path);
        if(mFile.delete())return 1; else return 0;
    }

    public double FileManager_FileCopy(String Path, String Path2)
    {
         if(copyFile(Path,Path2))
            return 1; else return 0;
    }

    public double FileManager_FileMove(String Path, String Path2)
    {
          if(moveFile(Path,Path2))
            return 1; else return 0;
    }

    public double FileManager_FileExists(String Path)
    {
        File mFile=new File(Path);
        if(mFile.exists())return 1; else return 0;
    }

    public double FileManager_DirectoryExists(String Path)
    {
        File mFile=new File(Path);
        if(mFile.exists())return 1; else return 0;
    }

    public double FileManager_FileReadable(String Path)
    {
        File mFile=new File(Path);
        if(mFile.canRead())return 1; else return 0;
    }

    public double FileManager_FileWritable(String Path)
    {
        File mFile=new File(Path);
        if(mFile.canWrite())return 1; else return 0;
    }

    public double FileManager_FileExecutable(String Path)
    {
        File mFile=new File(Path);
        if(mFile.canExecute())return 1; else return 0;
    }

    public double FileManager_FileDeletable(String Path)
    {
        return 1;
    }

    public double FileManager_isDirectory(String Path)
    {
        File mFile=new File(Path);
        if(mFile.isDirectory())return 1; else return 0;
    }

    public String FileManager_getDirectoryContent(String Path)
    {
		
		
        File mFile=new File(Path);
        File[] mList = mFile.listFiles();
        
		
        if (mList == null) {
         return"{}";   
        }
        
		int size=mList.length;
		
		
        Map<String, String> mMap = new HashMap<String, String>();
        int fileCount=0,folderCount=0;
        for(int a=0;a<size;a++)
        {

            if (mList[a].exists())
            {
                if (mList[a].isDirectory())
                {
                    mMap.put("Folder"+String.valueOf(folderCount),mList[a].getName());
                    folderCount++;
                }
                else
                {
                    mMap.put("File"+String.valueOf(fileCount),mList[a].getName());
                    fileCount++;
                }
            }
        }

		mMap.put("FolderCount",String.valueOf(folderCount));
		mMap.put("FileCount",String.valueOf(fileCount));
        Gson gson = new GsonBuilder().disableHtmlEscaping().create();
        return( gson.toJson(mMap));
    }
	
	
	/////////////////////////////GALLERY
	
		static final int PICK_IMAGE_URI = 2;
	static final int REQUEST_CROP_ICON = 3;
	int EVENT_OTHER_SOCIAL = 70;
	int  MY_PERMISSIONS=9;
	
	  public void GalleryAndroid_Open()
    {
		
        Intent intent = new Intent(Intent.ACTION_PICK);
    	if (intent.resolveActivity(RunnerActivity.CurrentActivity.getPackageManager()) != null) {
		   intent.setType("image/*");
            RunnerActivity.CurrentActivity.startActivityForResult(intent,PICK_IMAGE_URI);
        }
    }
	
	 public void Gallery_Crop(String Path,double xscale,double yscale) {

            //call the standard crop action intent (the user device may not support it)
            Intent cropIntent = new Intent("com.android.camera.action.CROP");
            //indicate image type and Uri
            cropIntent.setDataAndType(Uri.fromFile(new File(Path)), "image/*");
            //set crop properties
            //cropIntent.putExtra("crop", "true");
            //indicate aspect of desired crop
            cropIntent.putExtra("aspectX", (int) xscale);
            cropIntent.putExtra("aspectY", (int) yscale);
            //indicate output X and Y
            //cropIntent.putExtra("outputX", 256);
            //cropIntent.putExtra("outputY", 256);
            //retrieve data on return
            //cropIntent.putExtra("return-data", true);
            //start the activity - we handle returning in onActivityResult
            RunnerActivity.CurrentActivity.startActivityForResult(cropIntent, REQUEST_CROP_ICON);
    
        
		}
	
	
	
	
		 @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
			   // Check which request we're responding to
       
            // Make sure the request was successful
            if (resultCode == Activity.RESULT_OK) {
               
			    if (requestCode == PICK_IMAGE_URI) {
				int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
				RunnerJNILib.DsMapAddString( dsMapIndex,"type","Gallery" );
				RunnerJNILib.DsMapAddString( dsMapIndex,"os","Android" );

				Uri selectedImageURI = data.getData();
				File imageFile = new File(getRealPathFromURI(selectedImageURI));

				RunnerJNILib.DsMapAddString( dsMapIndex,"path",String.valueOf(imageFile));
				RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);   
				}
				
				if (requestCode == REQUEST_CODE_FILE) {
            // Make sure the request was successful
               
				int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
				RunnerJNILib.DsMapAddString( dsMapIndex,"type","Files" );
				RunnerJNILib.DsMapAddString( dsMapIndex,"os","Android" );

				Uri selectedImageURI = data.getData();
				File imageFile = new File(getRealPathFromURI(selectedImageURI));

				RunnerJNILib.DsMapAddString( dsMapIndex,"path",String.valueOf(imageFile));
				RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);   
				
            }
            
        }
		
		 if (requestCode == REQUEST_CROP_ICON) {
            // Make sure the request was successful
            if (resultCode == Activity.RESULT_OK) {

                Bundle extras = data.getExtras();
                if (extras != null) {
                    Bitmap photo = extras.getParcelable("data");
                    ByteArrayOutputStream stream = new ByteArrayOutputStream();
                    photo.compress(Bitmap.CompressFormat.JPEG, 75, stream);
                    // The stream to write to a file or directly using the
					
					int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
				RunnerJNILib.DsMapAddString( dsMapIndex,"type","ExternalImage" );	
				RunnerJNILib.DsMapAddString( dsMapIndex,"format","CropSuccess" );		

				Uri selectedImageURI = data.getData();
				File imageFile = new File(getRealPathFromURI(selectedImageURI));
				RunnerJNILib.DsMapAddString( dsMapIndex,"path",String.valueOf(imageFile));

				RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);    
                }
            }
        }
	}
	

private String getRealPathFromURI(Uri contentURI) {
    String result;
    Cursor cursor = RunnerActivity.CurrentActivity.getContentResolver().query(contentURI, null, null, null, null);
    if (cursor == null) { // Source is Dropbox or other similar local file path
        result = contentURI.getPath();
    } else { 
        cursor.moveToFirst(); 
        int idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA); 
        result = cursor.getString(idx);
        cursor.close();
    }
    return result;
}



public void FileManager_getPermission()
	{
			if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){

                ActivityCompat.requestPermissions(RunnerActivity.CurrentActivity,
                        new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},
                        MY_PERMISSIONS);}	
	}
	
	public double FileManager_checkPermission()
	{
		 if(ContextCompat.checkSelfPermission(RunnerActivity.CurrentActivity,Manifest.permission.READ_EXTERNAL_STORAGE)==0)
		return(1);
		return(0);	
	}

	
	public void FilesAndroid_Open()
    {
		
        Intent intent = new Intent(Intent.ACTION_PICK);
    	if (intent.resolveActivity(RunnerActivity.CurrentActivity.getPackageManager()) != null) {
		   intent.setType("image/*");
            RunnerActivity.CurrentActivity.startActivityForResult(intent,REQUEST_CODE_FILE);
        }
    }

	public String Android_getExternalPath()
		{
		 return String.valueOf(Environment.getExternalStorageDirectory());
		}
		
		public String Android_getLocalAppPath()
		{
			
			return(RunnerActivity.CurrentActivity.getApplicationInfo().dataDir);
		}
		
		
		public String Android_getExternalStoragePublicPath(String type)
		{
			File mFile=Environment.getExternalStoragePublicDirectory(type);
			return(mFile.getAbsolutePath());
		}
		
		private boolean moveFile(String Path, String outputPath) {

        File mFile=new File(Path);
        String inputPath=mFile.getParent();
        String inputFile=mFile.getName();

        InputStream in = null;
        OutputStream out = null;
        try {

            //create output directory if it doesn't exist
            File dir = new File (outputPath);
            if (!dir.exists())
            {
                dir.createNewFile();
            }


            in = new FileInputStream(Path);
            out = new FileOutputStream(outputPath);

            byte[] buffer = new byte[1024];
            int read;
            while ((read = in.read(buffer)) != -1) {
                out.write(buffer, 0, read);
            }
			

            in.close();
            in = null;

            // write the output file
            out.flush();
            out.close();
            out = null;

            // delete the original file
			if(mFile.delete())
				return true;
			else
				return false;
			}

        catch (FileNotFoundException fnfe1) {
            //Log.e("tag", fnfe1.getMessage());
            return false;
        }
        catch (Exception e) {
            //Log.e("tag", e.getMessage());
            return false;
        }

    }



    private boolean copyFile(String Path, String outputPath) {

         File mFile=new File(Path);
        String inputPath=mFile.getParent();
        String inputFile=mFile.getName();

        InputStream in = null;
        OutputStream out = null;
        try {

            //create output directory if it doesn't exist
            File dir = new File (outputPath);
            if (!dir.exists())
            {
                dir.createNewFile();
            }


            in = new FileInputStream(Path);
            out = new FileOutputStream(outputPath);

            byte[] buffer = new byte[1024];
            int read;
            while ((read = in.read(buffer)) != -1) {
                out.write(buffer, 0, read);
            }
			

            in.close();
            in = null;

            // write the output file
            out.flush();
            out.close();
            out = null;

/*            // delete the original file
			if(mFile.delete())
				return true;
			else
				return false;*/
			
			return true;
		}
        catch (FileNotFoundException fnfe1) {
            //Log.e("tag", fnfe1.getMessage());
            return false;
        }
        catch (Exception e) {
            //Log.e("tag", e.getMessage());
            return false;
				
			}
		}
	
}
