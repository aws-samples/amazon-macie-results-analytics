--Macie sensitive data location for an object for a spectific job
--Replace table name and jobid values before running

select resourcesaffected.s3object.key object,
       resourcesaffected.s3object.embeddedfiledetails.filepath embedded_file,
       sensitive_data.category,
       detections_data.type,
       line_ranges sensitive_data_line_location,
       null sensitive_data_page_location,
       null sensitive_data_record_location,
       null sensitive_data_cells_location
from <table_name>,
     unnest(classificationdetails.result.sensitiveData) as t(sensitive_data),
     unnest(sensitive_data.detections) as t(detections_data),
     unnest(detections_data.occurrences.lineranges) as t(line_ranges)
where classificationdetails.jobid = '<jobid>'
UNION
select resourcesaffected.s3object.key object,
       resourcesaffected.s3object.embeddedfiledetails.filepath embedded_file,
       sensitive_data.category,
       detections_data.type,
       null,
       detection_pages sensitive_data_page_location,
       null sensitive_data_record_location,
       null sensitive_data_cells_location
from <table_name>,
     unnest(classificationdetails.result.sensitiveData) as t(sensitive_data),
     unnest(sensitive_data.detections) as t(detections_data),
     unnest(detections_data.occurrences.pages) as t(detection_pages)
where classificationdetails.jobid = '<jobid>'
UNION
select resourcesaffected.s3object.key object,
       resourcesaffected.s3object.embeddedfiledetails.filepath embedded_file,
       sensitive_data.category,
       detections_data.type,
       null sensitive_data_line_location,
       null sensitive_data_page_location,
       detection_records sensitive_data_record_location,
       null sensitive_data_cells_location
from <table_name>,
     unnest(classificationdetails.result.sensitiveData) as t(sensitive_data),
     unnest(sensitive_data.detections) as t(detections_data),
     unnest(detections_data.occurrences.records) as t(detection_records)
where classificationdetails.jobid = '<jobid>'
UNION
select resourcesaffected.s3object.key object,
       resourcesaffected.s3object.embeddedfiledetails.filepath embedded_file,
       sensitive_data.category,
       detections_data.type,
       null sensitive_data_line_location,
       null sensitive_data_page_location,
       null sensitive_data_record_location,
       detection_cells sensitive_data_cells_location
from <table_name>,
     unnest(classificationdetails.result.sensitiveData) as t(sensitive_data),
     unnest(sensitive_data.detections) as t(detections_data),
     unnest(detections_data.occurrences.cells) as t(detection_cells)
where classificationdetails.jobid = '<jobid>'