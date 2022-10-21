/* 
| Query that lists out the details about each object where sensitive data was discovered.
|
| This query is intended to help understand the full location of each file where sensitive data was found within a job.
| If the file was an archive file (zip, gzip, tar) the archive file will be listed as well as each file found in the archive file
|
| The sensitive data counts listed for an archive file are a summary for all the files within the embedded file where senstivie data was found.
| 
| UNION statement exists to account for how findings related to custom identifiers are reported.
| Running the query as is, will not impact the results, if you don't use custom identifiers.
| If you do not use custom identifiers to find sensitive data in Macie you may remove everything between the UNION and group by.
|
*/

select resourcesaffected.s3bucket.name as bucket_name,
       resourcesaffected.s3object.key object_key,
       resourcesaffected.s3object.embeddedfiledetails.filepath embedded_file_path,
       sensitive_data.category, 
       detections_data.type,
       cast(detections_data.count as INT)
from <table_name>, 
     unnest(classificationdetails.result.sensitiveData) as t(sensitive_data),
     unnest(sensitive_data.detections) as t(detections_data)
UNION
select resourcesaffected.s3bucket.name as bucket_name,
       resourcesaffected.s3object.key object_key,
       resourcesaffected.s3object.embeddedfiledetails.filepath embedded_file_path,
       'CustomIdentifier', 
       custom_detections_data.name,
       cast(custom_detections_data.count as INT)
from <table_name>, 
     unnest(classificationdetails.result.customDataIdentifiers.detections) as t(custom_detections_data)