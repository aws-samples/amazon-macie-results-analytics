--Macie job informatoin by account, category, and type

select accountid, 
       sensitive_data.category, 
       detections_data.type, 
       sum(cast(detections_data.count as INT)) total_detections
from <table name>,
   unnest(classificationdetails.result.sensitiveData) as t(sensitive_data),
   unnest(sensitive_data.detections) as t(detections_data)
where classificationdetails.result.sensitiveData is not null
and resourcesaffected.s3object.embeddedfiledetails is null
group by accountid, sensitive_data.category, detections_data.type
order by total_detections desc