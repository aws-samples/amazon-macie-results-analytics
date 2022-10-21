/* 
| Query for a specific Job.  Shows S3 object, data category, detection type, and number of occurances.
| Replace table_name and jobid values before running
|
| UNION statement exists to account for how findings related to custom identifiers are reported.
| Running the query as is, will not impact the results, if you don't use custom identifiers.
| If you do not use custom identifiers to find sensitive data in Macie you may remove everything between the UNION and group by.
|
*/


select resourcesaffected.s3object.key, 
       sensitive_data.category, 
       detections_data.type, 
       cast(detections_data.count as INT) total_detections
from <table_name>, 
     unnest(classificationdetails.result.sensitiveData) as t(sensitive_data),
     unnest(sensitive_data.detections) as t(detections_data)
where classificationdetails.jobid = '<jobid>'
and resourcesaffected.s3object.embeddedfiledetails is null
UNION
select resourcesaffected.s3object.key,
       'CustomIdentifier', 
       custom_detections_data.name,
       cast(custom_detections_data.count as INT) total_detections
from <table_name>, 
     unnest(classificationdetails.result.customDataIdentifiers.detections) as t(custom_detections_data)
where classificationdetails.jobid = '<jobid>'
and  resourcesaffected.s3object.embeddedfiledetails is null
order by total_detections desc
