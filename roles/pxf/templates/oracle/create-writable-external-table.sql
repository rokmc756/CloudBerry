CREATE WRITABLE EXTERNAL TABLE countries_write (country_id int, country_name varchar, population float)
LOCATION('pxf://countries?PROFILE=jdbc&SERVER=default')
FORMAT 'CUSTOM' (formatter='pxfwritable_export');
