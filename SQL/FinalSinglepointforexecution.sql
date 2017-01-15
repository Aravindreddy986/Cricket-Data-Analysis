USE CRICKET 
GO

CREATE PROCEDURE FINAL_SINGLE_POINT_EXECUTION
AS

EXEC INSERT_into_Temporarytables

-- using cricket..temporaryMatchessummary
EXEC CRICKET..Insert_Umpires_table
EXEC Insert_OR_UPDATE_Venue__Cricketplaying_nations_table

-- Cricket..temporarybowlingsummary  and Cricket..temporarybatsmendetails
EXEC INSERT_PLAYER_DETAILS
EXEC INSERT_into_Finaltables