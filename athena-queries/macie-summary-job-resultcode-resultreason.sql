--Macie Job info with result status code and reason
--Replace table_name before running

select classificationdetails.jobId, 
      classificationdetails.result.status.code, 
      classificationdetails.result.status.reason, 
      count(*) as total_count
from <table_name>
group by classificationdetails.jobId, 
         classificationdetails.result.status.code, 
         classificationdetails.result.status.reason;