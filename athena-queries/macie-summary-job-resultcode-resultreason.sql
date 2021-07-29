--Macie Job info with result status code and reason

select classificationdetails.jobId, 
      classificationdetails.result.status.code, 
      classificationdetails.result.status.reason, 
      count(*) as total_count
from scotward_macie_data_discovery
group by classificationdetails.jobId, 
         classificationdetails.result.status.code, 
         classificationdetails.result.status.reason;