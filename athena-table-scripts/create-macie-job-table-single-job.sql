-- creates a table covering the macie output for a single macie job

CREATE EXTERNAL TABLE `maciedetail_job_REPLACE-JOB-ID`(
  `accountid` string COMMENT 'from deserializer', 
  `category` string COMMENT 'from deserializer', 
  `classificationdetails` struct<jobarn:string,result:struct<status:struct<code:string,reason:string>,sizeclassified:string,mimetype:string,sensitivedata:array<struct<category:string,totalcount:string,detections:array<struct<type:string,count:string,occurrences:struct<lineranges:array<struct<start:string,`end`:string,`startcolumn`:string>>,pages:array<struct<pagenumber:string>>,records:array<struct<recordindex:string,jsonpath:string>>,cells:array<struct<row:string,`column`:string,`columnname`:string,cellreference:string>>>>>>>,customdataidentifiers:struct<totalcount:string,detections:array<struct<arn:string,name:string,count:string,occurrences:struct<lineranges:array<struct<start:string,`end`:string,`startcolumn`:string>>,pages:array<string>,records:array<string>,cells:array<string>>>>>>,detailedresultslocation:string,jobid:string> COMMENT 'from deserializer', 
  `createdat` string COMMENT 'from deserializer', 
  `description` string COMMENT 'from deserializer', 
  `id` string COMMENT 'from deserializer', 
  `partition` string COMMENT 'from deserializer', 
  `region` string COMMENT 'from deserializer', 
  `resourcesaffected` struct<s3bucket:struct<arn:string,name:string,createdat:string,owner:struct<displayname:string,id:string>,tags:array<string>,defaultserversideencryption:struct<encryptiontype:string,kmsmasterkeyid:string>,publicaccess:struct<permissionconfiguration:struct<bucketlevelpermissions:struct<accesscontrollist:struct<allowspublicreadaccess:boolean,allowspublicwriteaccess:boolean>,bucketpolicy:struct<allowspublicreadaccess:boolean,allowspublicwriteaccess:boolean>,blockpublicaccess:struct<ignorepublicacls:boolean,restrictpublicbuckets:boolean,blockpublicacls:boolean,blockpublicpolicy:boolean>>,accountlevelpermissions:struct<blockpublicaccess:struct<ignorepublicacls:boolean,restrictpublicbuckets:boolean,blockpublicacls:boolean,blockpublicpolicy:boolean>>>,effectivepermission:string>>,s3object:struct<bucketarn:string,key:string,path:string,extension:string,lastmodified:string,etag:string,serversideencryption:struct<encryptiontype:string,kmsmasterkeyid:string>,size:string,storageclass:string,tags:array<string>,embeddedfiledetails:struct<filepath:string,fileextension:string,filesize:string,filelastmodified:string>,publicaccess:boolean>> COMMENT 'from deserializer', 
  `schemaversion` string COMMENT 'from deserializer', 
  `severity` struct<description:string,score:int> COMMENT 'from deserializer', 
  `title` string COMMENT 'from deserializer', 
  `type` string COMMENT 'from deserializer', 
  `updatedat` string COMMENT 'from deserializer')
ROW FORMAT SERDE 
  'org.openx.data.jsonserde.JsonSerDe' 
WITH SERDEPROPERTIES ( 
  'paths'='accountId,category,classificationDetails,createdAt,description,id,partition,region,resourcesAffected,schemaVersion,severity,title,type,updatedAt') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://REPLACE-RESULTS-BUCKET-NAME/AWSLogs/REPLACE-ACCOUNT-ID/Macie/REPLACE-REGION/REPLACE-JOB-ID'
TBLPROPERTIES (
  'transient_lastDdlTime'='1625695494')