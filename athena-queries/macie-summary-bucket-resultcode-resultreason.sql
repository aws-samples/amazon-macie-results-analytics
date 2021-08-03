--Macie result status code and reason by bucket
--Replace table_name before running

select resourcesaffected.s3bucket.name as bucket_name, 
      classificationdetails.result.status.code, 
      classificationdetails.result.status.reason, 
      count(*) as total_count
from <table_name>
group by resourcesaffected.s3bucket.name, 
         classificationdetails.result.status.code, 
         classificationdetails.result.status.reason;