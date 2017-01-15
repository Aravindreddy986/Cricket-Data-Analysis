USE cricket

SELECT * 
INTO matches2
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=A:\ADBMS\Project\Datafiles\csv\T20\matchestest.xlsx;HDR=YES', 'SELECT * FROM [Sheet1$]')
 
 
 Insert INTO matchestestt2 select * from matches3

 
insert into Matchestest values('match211028.xlsx' , 1,	'2005-06-13',	'England vs Australia',	'T20',	'male',	'England',	'KP Pietersen',	'England',	'bat'  	,'NJ Llong vs JW Lloyds','Southampton	The Rose Bowl')

use cricket
select * from cricket..batsmendetails

select * from Cricket..batsmendetails

BULK INSERT test
    FROM 'A:\National_Statistics_Postcode_Lookup_UK.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    ERRORFILE = 'A:\SchoolsErrorRows.csv',
    TABLOCK
    )

	DECLARE @test varchar(max);
set @test = 'Peter/Parker/Spiderman/Marvel';
set @test = Replace(@test, '/', '.');
Select @test
SELECT ParseName(@test, 4) --returns Peter
SELECT ParseName(@test, 3) --returns Parker
SELECT ParseName(@test, 2) --returns Spiderman
SELECT ParseName(@test, 1) --returns Marvel