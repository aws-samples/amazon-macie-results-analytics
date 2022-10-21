/*
|
| Query that gives a summary by status code and reason
| Replace table_name value before running
|
*/

select accountid, 
      classificationdetails.result.status.code, 
      classificationdetails.result.status.reason, 
      count(*) as total_count
from <table_name>
group by accountid, 
         classificationdetails.result.status.code, 
         classificationdetails.result.status.reason;