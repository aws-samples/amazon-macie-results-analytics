--Macie  job info showing size of files processed

select sum(cast(classificationdetails.result.sizeClassified as INT)) as Bytes_classified, 
       sum((cast(classificationdetails.result.sizeClassified as DECIMAL(20,8))/1073741824)) as GB_classified
from scotward_macie_data_discovery
where classificationdetails.jobId = <jobid>
and resourcesaffected.s3object.embeddedfiledetails is null;