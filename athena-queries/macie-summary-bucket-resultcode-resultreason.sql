--Macie result status code and reason by bucket

select resourcesaffected.s3bucket.name as bucket_name, 
      classificationdetails.result.status.code, 
      classificationdetails.result.status.reason, 
      count(*) as total_count
from <table name>
group by resourcesaffected.s3bucket.name, 
         classificationdetails.result.status.code, 
         classificationdetails.result.status.reason;