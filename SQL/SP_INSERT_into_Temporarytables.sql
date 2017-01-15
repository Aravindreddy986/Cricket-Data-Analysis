USE Cricket
GO

CREATE PROCEDURE INSERT_into_Temporarytables
AS

DELETE FROM Cricket..temporarybatsmendetails
DELETE FROM Cricket..temporarybowlingsummary
DELETE FROM Cricket..temporaryfallofwickets
DELETE FROM Cricket..temporaryMatchessummary

INSERT INTO Cricket..temporaryMatchessummary select * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=A:\ADBMS\Project\Datafiles\csv\T20\Modified files\matches.xlsx;HDR=YES', 'SELECT * FROM [Sheet1$]');

INSERT INTO Cricket..temporarybatsmendetails select * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=A:\ADBMS\Project\Datafiles\csv\T20\Modified files\playerdetails.xlsx;HDR=YES', 'SELECT * FROM [Sheet1$]')

INSERT INTO Cricket..temporarybowlingsummary select * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=A:\ADBMS\Project\Datafiles\csv\T20\Modified files\bowlingsummary.xlsx;HDR=YES', 'SELECT * FROM [Sheet1$]')

INSERT INTO Cricket..temporaryfallofwickets select * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=A:\ADBMS\Project\Datafiles\csv\T20\Modified files\fallofwickets.xlsx;HDR=YES', 'SELECT * FROM [Sheet1$]')

GO


