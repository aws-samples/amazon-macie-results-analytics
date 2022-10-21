/*
|
| Query that will show the location of sensitive data for Macie findings.
| This query works for findings that were created by Macie's custom data identifiers.
| If you are using managed data identifiers the macie-object-sensitive-data-location-details-MDI.sql
| script will report on locations for findings tied to managed data identifers.
| Replace table name and jobid values before running.
|
| UNION is used in this query to account for different ways that data location is reported
| for different file types.
|
*/

select resourcesaffected.s3object.key object,
       resourcesaffected.s3object.embeddedfiledetails.filepath embedded_file,
       'CustomIdentifier',
       custom_detections_data.name,
       line_ranges sensitive_data_line_location,
       null sensitive_data_page_location,
       null sensitive_data_record_location,
       null sensitive_data_cells_location
from <table_name>,
     unnest(classificationdetails.result.customDataIdentifiers.detections) as t(custom_detections_data),
     unnest(custom_detections_data.occurrences.lineranges) as t(line_ranges)
where classificationdetails.jobid = '<jobid>'
UNION
select resourcesaffected.s3object.key object,
       resourcesaffected.s3object.embeddedfiledetails.filepath embedded_file,
       'CustomIdentifier',
       custom_detections_data.name,
       null,
       detection_pages sensitive_data_page_location,
       null sensitive_data_record_location,
       null sensitive_data_cells_location
from <table_name>,
     unnest(classificationdetails.result.customDataIdentifiers.detections) as t(custom_detections_data),
     unnest(custom_detections_data.occurrences.pages) as t(detection_pages)
where classificationdetails.jobid = '<jobid>'
UNION
select resourcesaffected.s3object.key object,
       resourcesaffected.s3object.embeddedfiledetails.filepath embedded_file,
       'CustomIdentifier',
       custom_detections_data.name,
       null sensitive_data_line_location,
       null sensitive_data_page_location,
       detection_records sensitive_data_record_location,
       null sensitive_data_cells_location
from <table_name>,
     unnest(classificationdetails.result.customDataIdentifiers.detections) as t(custom_detections_data),
     unnest(custom_detections_data.occurrences.records) as t(detection_records)
where classificationdetails.jobid = '<jobid>'
UNION
select resourcesaffected.s3object.key object,
       resourcesaffected.s3object.embeddedfiledetails.filepath embedded_file,
       'CustomIdentifier',
       custom_detections_data.name,
       null sensitive_data_line_location,
       null sensitive_data_page_location,
       null sensitive_data_record_location,
       detection_cells sensitive_data_cells_location
from <table_name>,
     unnest(classificationdetails.result.customDataIdentifiers.detections) as t(custom_detections_data),
     unnest(custom_detections_data.occurrences.cells) as t(detection_cells)
where classificationdetails.jobid = '<jobid>'