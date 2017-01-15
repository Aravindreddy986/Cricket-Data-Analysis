USE Cricket

EXEC INSERT_into_Temporarytables
EXEC INSERT_into_Finaltables

EXEC CRICKET..Insert_Umpires_table
EXEC Insert_OR_UPDATE_Venue__Cricketplaying_nations_table

EXEC INSERT_PLAYER_DETAILS

INSERT INTO Cricket..temporaryMatchessummary select * FROM Cricket..Matchessummary
INSERT INTO Cricket..temporarybatsmendetails select * FROM Cricket..batsmendetails
INSERT INTO Cricket..temporarybowlingsummary select * FROM Cricket..bowlingsummary 
INSERT INTO cricket..temporaryfallofwickets select * FROM cricket..fallofwickets



