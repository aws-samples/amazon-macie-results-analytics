--Macie Job info with result status code and reason

select classificationdetails.result.status.code, 
       classificationdetails.result.status.reason, 
       count(*) as total_count
from <table name>
where classificationdetails.jobId = <jobid>
group by classificationdetails.result.status.code, 
         classificationdetails.result.status.reason;