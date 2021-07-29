--Macie job status and job reason by account

select accountid, 
      classificationdetails.result.status.code, 
      classificationdetails.result.status.reason, 
      count(*) as total_count
from <table name>
group by accountid, 
         classificationdetails.result.status.code, 
         classificationdetails.result.status.reason;