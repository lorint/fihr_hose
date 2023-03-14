# FIHR_hose

Essentially "ETL for FIHR" -- a Rails gem to migrate / transform / and queue FIHR change information.  You can:
* import full, partial, or changed data from a FIHR R4 compliant server,
* export full, partial, or changed data to a different destination FIHR R4 compliant server, and
* have the export operation be initiated based on changes being detected in the source data.
* migrate only changed records so long as either an "updated_at" datetime field is present, or a "high_watermark"
big integer field is present.
