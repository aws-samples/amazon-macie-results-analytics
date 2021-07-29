--Macie category and type summary by bucket

select resourcesaffected.s3bucket.name as bucket_name, 
       sensitive_data.category, 
       detections_data.type, 
       sum(cast(detections_data.count as INT)) total_detections
from <table name>, 
   unnest(classificationdetails.result.sensitiveData) as t(sensitive_data),
   unnest(sensitive_data.detections) as t(detections_data)
where classificationdetails.result.sensitiveData is not null
and resourcesaffected.s3object.embeddedfiledetails is null
group by resourcesaffected.s3bucket.name, sensitive_data.category, detections_data.type
order by total_detections desc