USE Cricket
GO

CREATE PROCEDURE INSERT_into_finaltables
AS

INSERT INTO Cricket..Matchessummary select * FROM Cricket..temporaryMatchessummary

INSERT INTO Cricket..batsmendetails select * FROM Cricket..temporarybatsmendetails

INSERT INTO Cricket..bowlingsummary select * FROM Cricket..temporarybowlingsummary

INSERT INTO Cricket..fallofwickets select * FROM  Cricket..temporaryfallofwickets

GO


