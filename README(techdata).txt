IIHS CrashTest Data
===================

Each crash test type follows a similar folder structure; an example is provided below. The folder names describe their contents.  The DAS folder contains the raw data output from our data acquisition systems. The DIAdem folder contains post processed crash data from the vehicle and test dummies. The EDR folder contains data from the tested vehicle's event data recorder (IIHS does not attempt to download EDR data for all tests). The EXCEL folder contains various spreadsheet files that are mostly used to record coordinate measurement machine data for vehicle intrusion or dummy seating measurements.

.
+-- _DATA
|   +-- _DAS
|   +-- _DIAdem
|   +-- _EDR
|   +-- _EXCEL
+-- _PHOTOS
+-- _REPORTS
+-- _VIDEO
+-- info.txt

Test Data
---------

IIHS saves post processed data collected from the dummies in the ".tdms" format using DIAdem software from National Instruments.  For instructions on how to view the contents of these files using Microsoft Excel please visit the following address, "http://www.ni.com/white-paper/3727/en/#toc5".

Vehicle Intrusion and ATD Seating Data
--------------------------------------

Vehicle intrusion data can be found in the "CE***** [Vehicle Name] Intrustion.xlsm" files for frontal crashes or "CE***** [Vehicle Name] Side Contour.xlsm" for side crashes. UMTRI seating information can be found in the "CE***** [Vehicle Name] UMTRI.xlsm" files. The definition for the coordinate system can be found in each document on the "CMMData" sheet.
