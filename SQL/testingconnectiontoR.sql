USE [Cricket]
GO

/****** Object:  StoredProcedure [dbo].[INSERT_into_Temporarytables]    Script Date: 17-11-2016 12:21:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[testing2] @umpirename varchar(50)
AS
Insert into cricket..umpires values(@umpirename,60)
Print('Suucessfully executed the stored procedure')

GO

exec Cricket..testing2 @umpirename = 'Aravind'




