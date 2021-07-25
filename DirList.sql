DROP JAVA SOURCE APPS."DirList";

CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED APPS."DirList"
as import java.io.*;
 import java.sql.*;

 public class DirList
 {

 static private String dateStr( java.util.Date x )
 {
 if ( x != null )
 return (x.getYear()+1900) + "/" + (x.getMonth()+1) + "/" + x.getDate() + " " +
 x.getHours() + ":" + x.getMinutes() + ":" + x.getSeconds();
 else return null;
 }

 public static void getList(String directory)
 throws SQLException
 {
 String element;


 File path = new File(directory);
 File[] FileList = path.listFiles();
 String TheFile;
 String ModiDate;
 #sql { DELETE FROM DIR_LIST};

 for(int i = 0; i < FileList.length; i++)
 {
 TheFile = FileList[i].getAbsolutePath();
 ModiDate = dateStr( new java.util.Date( FileList[i].lastModified() ) );

 #sql { INSERT INTO DIR_LIST (FILENAME,LASTMODIFIED)
 VALUES (:TheFile, to_date( :ModiDate, 'yyyy/mm/dd hh24:mi:ss') ) };
 }
 }
 }
/
