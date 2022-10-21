/*
|
| Query that gives sum of bytes and GB classified by job id
| Replace table_name value before running
|
*/


select classificationdetails.jobId, 
       sum(cast(classificationdetails.result.sizeClassified as INT)) as Bytes_classified, 
       sum((cast(classificationdetails.result.sizeClassified as DECIMAL(20,8))/1073741824)) as GB_classified
from <table_name>
where resourcesaffected.s3object.embeddedfiledetails is null
group by classificationdetails.jobId;