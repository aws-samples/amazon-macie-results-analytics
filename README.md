# Performing analytics on Amazon Macie classification job results
This project is focused on how to use Amazon Athena to perform analytics against the detailed results from an Amazon Macie classification job.


## Why is this needed?
With Macie customers can run classification jobs across one or many S3 buckets and each bucket can contain one or many objects.  When Macie finds sensitive data in an object it creates a finding.  This finding is available to view in the Macie console and can also be consumed through Amazon Event Bridge.  To understand the full picture of a large Macie classification job customers need a comprehensive view of the results of a job so they can understand what was found and help them determine the next steps to take with their data.  Looking at each sensitive data finding that Macie generates and displays in the console can be time consuming and does not provide details on the scope of what was found in the overall job.  

In addition to findings about discovered sensitive data, Macie also creates results files that cover the full scope of all objects scanned during a job.  With the results files from a job customers can learn: 
    
* Details about objects where sensitive data was found
* Details about objects that could not be scanned due to unsupported file type or not having permissions to access the object.
* Details about objects that were scanned and no sensitive data was found.   
 

With Amazon Athena queries can be run against the sensitive data discovery results of a Macie job.  Athena queries can be used to provide a summarized view of what types of sensitive data were discovered by a job.  From an initial summarized view customers can then create additional queries to get insight on which objects contain sensitive data and the location of that sensitive data.  This deeper insight into the results of a Macie job helps customers better understand what types of sensitive data they have in their S3 buckets and what type of action they should take around that sensitive data. 


## Setup

### Enable the job classification S3 bucket
To run Athena queries on the results of Macie classification jobs Macie must be configured to store sensitive data discovery results in an S3 bucket.  This configuration should be done in the AWS account that you are running classification jobs from.  Details on how to configure the S3 repository for Macie can be found at: <a href="https://docs.aws.amazon.com/macie/latest/user/discovery-results-repository-s3.html" target="_blank">https://docs.aws.amazon.com/macie/latest/user/discovery-results-repository-s3.html</a>.  Once the results location is configured Macie will write the output of all new jobs to this location.  If you ran Macie jobs before configuring the results bucket Macie will also write any results files that have been generated in the past 90 days.

### Permissions to read classification results with Athena
To successfully query Macie classification results data the user or role that will run the Athena queries needs to ensure two permissions are in place, specific to the Macie classification results S3 bucket.

#### Permissions to read data from the classifications results bucket
The user or role that is running the Athena query will need an IAM policy that includes permissions to get objects from the Macie results bucket.   Below is a sample policy that grants the necessary permissions.  Make sure to replace <Macie Results Bucket Name> with the actual name of the S3 bucket that you configured to store Macie results files.  

    
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "allowMacieResultsGet",
                "Effect": "Allow",
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::<Macie Results Bucket Name>/*"
            }
        ]
    }
   


#### Permissions to decrypt classification results files
Each file that Macie writes to the classification results bucket is server side encrypted with a KMS key, which is defined in the Macie results setup.  The policy for this key needs to grant permission to the user or role that will be running Athena queries against the classification results bucket.  Below is a sample policy that can be added to the key policy for the KMS key used to protect your Macie results data:

    {
        "Sid": "Allow access for athena user",
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::<account ID>:role/<role name>"
        },
        "Action": "kms:Decrypt",
        "Resource": "*"
    }

Details on how to update a KMS key policy can be found at: <a href="https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-modifying.html" target="_blank"> https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-modifying.html</a>.

### Athena Table Creation
The below options cover creating an Athena table that covers the full schema for a Macie results file.  Since the schema covers all possible options for how data is represented in the results files you may see blank columns if your results files do not contain those fields.


#### Option 1 - Define a table for a specific job
This option covers creating an Athena table that comprises the output for a single Macie job.  This approach is a great starting point to get specific data about a particular job.  If you have a scheduled Macie job this table will enable you to query any new sensitive data that is discovered through each scheduled run of a job.  

Use the following steps to create the table:
1. Navigate to the Amazon Athena console in the account and region that you are running Macie jobs in.
2. In the Athena query editor copy and run the contents of the [create-macie-job-table-single-job.sql](athena-table-scripts/create-macie-job-table-single-job.sql) script.  Replace the placeholders in the create table script with the following information:

placeholder|replace with
-----|-----
REPLACE-JOBID|ID of the Macie job that you want to perform analytics on.  There are two places where this needs replacement in the create table script|
REPLACE-RESULTS-BUCKET-NAME|Name of the S3 bucket that you created to hold your macie classification details|
REPLACE-ACCOUNT-ID|ID of the account that you are running Macie jobs from|
REPLACE-REGION|Region that you are running Macie jobs in



#### Option 2 - Define a table for all jobs
This option covers creating an Athena table that comprises the output for ALL Macie jobs.  This approach is useful if you are trying to get analytics across multiple jobs.  If you have a scheduled Macie job this table will enable you to query any new sensitive data that is discovered through each scheduled run of a job. 

This approach should be used when trying to get summarized information across multiple job IDs.  When running a query for a specific job ID, using this table, Athena will scan all S3 results data for all jobs in order to retrieve your information, which will result in Athena charges for scanning all S3 data.  This full scan happens because this table does not have any partitions to guide Athena on where to find more specific information.  When looking to run analytics against a specific job the table in option 1 is recommended. 

Use the following steps to create the table:
1. Navigate to the Amazon Athena console in the account and region that you are running Macie jobs in.
2. In the Athena query editor copy and run the contents of the [create-macie-job-table-all-jobs.sql](athena-table-scripts/create-macie-job-table-all-jobs.sql) script.  Replace the placeholders in the create table script with the following information:

placeholder|replace with
-----|-----
REPLACE-RESULTS-BUCKET-NAME|Name of the S3 bucket that you created to hold your Macie classification details|
REPLACE-ACCOUNT-ID|ID of the account that you are running Macie jobs from|
REPLACE-REGION|Region that you are running Macie jobs in

## Run queries
Now that you have a table definition you can query the data related to your classification job.  A starting collection of queries is located in the queries folder of this repository.  These queries are intended to provide you a starting point and help answer common questions about the information related to a Macie job.  Feel fee to write your own queries that help address your specific needs or modify the ones that are provided in this repository.

Here is a summary of the queries that exist within this repository

Query|Description
-----|-----
[macie-specific-job-summary-category-type.sql](athena-queries/macie-specific-job-summary-category-type.sql)|Provides a count of the number of detections for a specific Job ID, grouped by sensitive data category, and sensitive data type.  This query is helpful in getting a summarized view of what types of sensitive data were found by a job.|
[macie-specific-job-summary-object-category-type.sql](athena-queries/macie-specific-job-summary-object-category-type.sql)|Provides a count for a specific JOB ID grouped by S3 object, sensitive data category and sensitive data type.  This query is helpful in finding which S3 objects, within a job, have sensitive data.|
[macie-specific-job-summary-resultcode-resultreason.sql](athena-queries/macie-specific-job-summary-resultcode-resultreason.sql)|Provides a grouped count for a specific job ID, by classification result code, and result reason for all objects scanned by a Macie job.  This query can be helpful in finding cases where Macie was not able to scan certain objects due to un-supported file types or not having access to certain encrypted objects.|
[macie-specific-job-summary-sizeclassified.sql](athena-queries/macie-specific-job-summary-sizeclassified.sql)|Provides the total bytes classified for a specific Job ID.  This query is helpful in understanding the amount of data classified so that estimates of Macie spend can be made.|
[macie-summary-job-category-type.sql](athena-queries/macie-summary-job-category-type.sql)|Provides a count of the number of detections grouped by Job ID, sensitive data category, and sensitive data type.  This query is helpful in getting a summarized view of what types of sensitive data were found across all Job IDs.|
[macie-summary-job-object-category-type.sql](athena-queries/macie-summary-job-object-category-type.sql)|Provides a count of the number of detections grouped by Job ID, S3 Object, sensitive data category, and sensitive data type.  This query is helpful in getting a summarized view of what types of sensitive data were found across all jobs and the objects in the buckets scanned by that job.|
[macie-summary-job-resultcode-resultreason.sql](athena-queries/macie-summary-job-resultcode-resultreason.sql)|Provides a grouped count of job ID, classification result code, and result reason for all objects scanned by a Macie job.  This query can be helpful in finding cases where Macie was not able to scan certain objects due to un-supported file types or not having access to certain encrypted objects.|
[macie-summary-jo-sizeclassified.sql](athena-queries/macie-summary-job-sizeclassified.sql)|Provides the total bytes classified for each Job ID.  This query is helpful in understanding the amount of data classified so that estimates of Macie spend can be made.|
[macie-summary-account-category-type.sql](athena-queries/macie-summary-account-category-type.sql)|Provides a count of the number of detections grouped by account ID, sensitive data category, and sensitive data type.  This query is helpful in getting a summarized view of what types of sensitive data were found across all accounts where a job was run.|
[macie-summary-account-resultcode-resultreason.sql](athena-queries/macie-summary-account-resultcode-resultreason.sql)|Provides a grouped count of account ID, classification result code, and result reason for all objects scanned by a Macie job.  This query can be helpful in finding cases where Macie was not able to scan certain objects due to un-supported file types or not having access to certain encrypted objects.|
[macie-summary-bucket-category-type.sql](athena-queries/macie-summary-bucket-category-type.sql)|Provides a count of the number of detections grouped by S3 bucket, sensitive data category, and sensitive data type.  This query is helpful in getting a summarized view of what types of sensitive data were found across all buckets where a job was run.|
[macie-summary-bucket-resultcode-resultreason.sql](athena-queries/macie-summary-bucket-resultcode-resultreason.sql)|Provides a grouped count of S3 bucket, classification result code, and result reason for all objects scanned by a Macie job.  This query can be helpful in finding cases where Macie was not able to scan certain objects due to un-supported file types or not having access to certain encrypted objects.|
[macie-object-sensitive-data-location-details-MDI.sql](athena-queries/macie-object-sensitive-data-location-details-MDI.sql)|Provides the location of sensitive data in an object, discovered by Macie MANAGED identifiers.  This query is helpful in determining the sensitive data location for multiple objects with findings in a Macie job.  Query is written to cover the various locations that Macie can report on depending on the type of file where the sensitive data was discovered.|
[macie-object-sensitive-data-location-details-CDI.sql](athena-queries/macie-object-sensitive-data-location-details-CDI.sql)|Provides the location of sensitive data in an object, discovered by Macie CUSTOM identifiers.  This query is helpful in determining the sensitive data location for multiple objects with findings in a Macie job.  Query is written to cover the various locations that Macie can report on depending on the type of file where the sensitive data was discovered.|
[macie-object-detail-listing.sql](athena-queries/macie-object-detail-listing.sql)|Provides a list of objects that had sensitive data identified by a classification job.  Query is written to also list out the contents of compressed files (zip, gzip, tar) which had sensitive data.


## Feedback
Have some input on additional queries that you find helpful, questions on how to set things up, or information that is missing please feel free to open an issue so we can help.  

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

