/* 
|
| Query that summarizes macie finding information by account, category, and type.
| Replace table_name before running
|
| UNION statement exists to account for how findings related to custom identifiers are reported.
| Running the query as is, will not impact the results, if you don't use custom identifiers.
| If you do not use custom identifiers to find sensitive data in Macie you may remove everything between the UNION and group by.
*/

select accountid, 
       sensitive_data.category, 
       detections_data.type, 
       sum(cast(detections_data.count as INT)) total_detections
from <table_name>,
   unnest(classificationdetails.result.sensitiveData) as t(sensitive_data),
   unnest(sensitive_data.detections) as t(detections_data)
where resourcesaffected.s3object.embeddedfiledetails is null
group by accountid, 
         sensitive_data.category, 
         detections_data.type
UNION
select accountid, 
      'CustomIdentifier',
        custom_detections_data.name,
        sum(cast(custom_detections_data.count as INT)) total_detections
from <table_name>,
    unnest(classificationdetails.result.customDataIdentifiers.detections) as t(custom_detections_data)
where resourcesaffected.s3object.embeddedfiledetails is null
group by accountid, 
        'CustomIdentifier',
         custom_detections_data.name
order by total_detections desc