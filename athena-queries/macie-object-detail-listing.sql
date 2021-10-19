--Query that lists out the details about each object where sensitive data was discovered.
--This query is intended to help understand the full location of each file where sensitive data was found within a job.
--This query will list out the contents of an embedded file (zip, gzip, tar).
--Macie reports details about each file it examined, if the file was an embedded file the
--embedded file will be listed as well as each file found in the embedded file.
--The sensitive data counts listed for an embedded file are a summary for all the files within 
--the embedded file where senstivie data was found.

select resourcesaffected.s3bucket.name as bucket_name,
       resourcesaffected.s3object.key object_key,
       resourcesaffected.s3object.embeddedfiledetails.filepath embedded_file_path,
       sensitive_data.category, 
       detections_data.type,
       detections_data.count
from <table_name>, 
     unnest(classificationdetails.result.sensitiveData) as t(sensitive_data),
     unnest(sensitive_data.detections) as t(detections_data)