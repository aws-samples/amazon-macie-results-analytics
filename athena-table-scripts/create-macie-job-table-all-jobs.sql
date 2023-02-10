-- creates a table covering the macie output for all macie jobs.  Delete this comment line before running in athena console.


CREATE EXTERNAL TABLE maciedetail_all_jobs(
  accountid string,
  category string,
  classificationdetails struct<jobArn:string,result:struct<status:struct<code:string,reason:string>,sizeClassified:string,mimeType:string,sensitiveData:array<struct<category:string,totalCount:string,detections:array<struct<type:string,count:string,occurrences:struct<lineRanges:array<struct<start:string,`end`:string,`startColumn`:string>>,pages:array<struct<pageNumber:string>>,records:array<struct<recordIndex:string,jsonPath:string>>,cells:array<struct<row:string,`column`:string,`columnName`:string,cellReference:string>>>>>>>,customDataIdentifiers:struct<totalCount:string,detections:array<struct<arn:string,name:string,count:string,occurrences:struct<lineRanges:array<struct<start:string,`end`:string,`startColumn`:string>>,pages:array<string>,records:array<string>,cells:array<string>>>>>>,detailedResultsLocation:string,jobId:string,originType:string>,
  createdat string,
  description string,
  id string,
  partition string,
  region string,
  resourcesaffected struct<s3Bucket:struct<arn:string,name:string,createdAt:string,owner:struct<displayName:string,id:string>,tags:array<string>,defaultServerSideEncryption:struct<encryptionType:string,kmsMasterKeyId:string>,publicAccess:struct<permissionConfiguration:struct<bucketLevelPermissions:struct<accessControlList:struct<allowsPublicReadAccess:boolean,allowsPublicWriteAccess:boolean>,bucketPolicy:struct<allowsPublicReadAccess:boolean,allowsPublicWriteAccess:boolean>,blockPublicAccess:struct<ignorePublicAcls:boolean,restrictPublicBuckets:boolean,blockPublicAcls:boolean,blockPublicPolicy:boolean>>,accountLevelPermissions:struct<blockPublicAccess:struct<ignorePublicAcls:boolean,restrictPublicBuckets:boolean,blockPublicAcls:boolean,blockPublicPolicy:boolean>>>,effectivePermission:string>>,s3Object:struct<bucketArn:string,key:string,path:string,extension:string,lastModified:string,eTag:string,serverSideEncryption:struct<encryptionType:string,kmsMasterKeyId:string>,size:string,storageClass:string,tags:array<string>,embeddedFileDetails:struct<filePath:string,fileExtension:string,fileSize:string,fileLastModified:string>,publicAccess:boolean>>,
  schemaversion string,
  severity struct<description:string,score:int>,
  title string,
  type string,
  updatedat string)
ROW FORMAT SERDE
  'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES (
  'paths'='accountId,category,classificationDetails,createdAt,description,id,partition,region,resourcesAffected,schemaVersion,severity,title,type,updatedAt')
STORED AS INPUTFORMAT
  'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://REPLACE-RESULTS-BUCKET-NAME/AWSLogs/REPLACE-ACCOUNT-ID/Macie/REPLACE-REGION/'

