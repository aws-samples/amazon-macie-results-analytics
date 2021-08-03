--Macie  job info showing size of files processed
--Replace table_name before running

select classificationdetails.jobId, 
       sum(cast(classificationdetails.result.sizeClassified as INT)) as Bytes_classified, 
       sum((cast(classificationdetails.result.sizeClassified as DECIMAL(20,8))/1073741824)) as GB_classified
from <table_name>
where resourcesaffected.s3object.embeddedfiledetails is null
group by classificationdetails.jobId;