--Macie job status and job reason by account
--Replace table_name before running

select accountid, 
      classificationdetails.result.status.code, 
      classificationdetails.result.status.reason, 
      count(*) as total_count
from <table_name>
group by accountid, 
         classificationdetails.result.status.code, 
         classificationdetails.result.status.reason;