USE CRICKET

create table PlayerStats
(
Playerid int Not NULL Primary key,
Playername varchar(255) 
)

create table Users
(userid int IDENTITY(1,1),
username varchar(255),
userpassword varchar(255)
)



CREATE TABLE Matchessummary
(
matchfilename varchar(50) Not NULL ,
Match_Id int NOT NULL PRIMARY KEY,
matchdate varchar(100) NOT NULL,
marchbetween varchar(100),
matchtype varchar(10),
matchgender varchar(10),
matchwinner varchar(255),
playerofmatch varchar(255),
tosswonby varchar(255),
tosswinnerdecision varchar(255),
umpiresformatch varchar(255),
matchlocation varchar(255),
matchvenue varchar(255)
)

CREATE TABLE temporaryMatchessummary
(
matchfilename varchar(50) Not NULL ,
Match_Id int NOT NULL PRIMARY KEY,
matchdate varchar(100) NOT NULL,
marchbetween varchar(100),
matchtype varchar(10),
matchgender varchar(10),
matchwinner varchar(255),
playerofmatch varchar(255),
tosswonby varchar(255),
tosswinnerdecision varchar(255),
umpiresformatch varchar(255),
matchlocation varchar(255),
matchvenue varchar(255)
)

Create TABLE umpires
(UmpireId int IDENTITY(1,1),
Umpirename varchar(50),
Noofmatches int
)

Create TABLE umpirestest
 ( Umpirename varchar(50) )

Create TABLE venuedetails
(venueid int IDENTITY(1,1),
venuename varchar(255),
matchlocation varchar(255),
matchtype varchar(100),
matchgender varchar(100),
Noofmatchesplayed int,
Noofmatchesgotnoresult int,
Noofmatcheswonbybattingfirst int,
Noofmatcheswonbybattingsecond int
)

CREATE Table playerdetails
(
playerID int IDENTITY(1,1) Primary key,
playername varchar(255),
Country varchar(255),
noofmatchesplayed int
)
 
CREATE TABLE cricketplayingnations
(countryid int IDENTITY(1,1),
countryname varchar(255),
noofmatcheswon int,
noofmatcheslost int,
nooftosswon int,
Noresultmatches int
)

CREATE TABLE CRICKET..batsmendetails
(
Match_Id int NOT NULL,
innings varchar(50) NOT NULL,
country varchar(255),
playername varchar(255) NOT NULL,
runscored int,
ballsplayed int,
countof4s int,
countof6s int,
wicketdetails varchar(255)

PRIMARY KEY CLUSTERED ( Match_Id , playername ),
  FOREIGN KEY ( Match_Id ) REFERENCES Matchessummary ( Match_Id )
)

CREATE TABLE CRICKET..temporarybatsmendetails
(
Match_Id int NOT NULL,
innings varchar(50) NOT NULL,
country varchar(255),
playername varchar(255) NOT NULL,
runscored int,
ballsplayed int,
countof4s int,
countof6s int,
wicketdetails varchar(255)

PRIMARY KEY CLUSTERED ( Match_Id , playername ),
  FOREIGN KEY ( Match_Id ) REFERENCES temporaryMatchessummary ( Match_Id )
)

CREATE table playerbattingdetails
(
batsmenid int,
batsmenname varchar(255),
country varchar(255),
noofinningsplayed int,
noofnotouts int,
noof4s int,
noof6s int,
totalnoofruns int,
totalballsplayed int,
highestscore int

FOREIGN KEY ( batsmenid ) REFERENCES playerdetails ( playerid )
)

CREATE TABLE bowlingsummary
(
Match_Id int NOT NULL,
country varchar(255),
innings varchar(10) NOT NULL,
bowlername varchar(150) NOT NULL,
totalballsbowled int,
oversbowled numeric,
runsgiven int,
wicketstaken int,
dotballsbowled int,
economyrate numeric,
widesbowled int,
noballsbowled int,
countof4sgiven int,
countof6sgiven int

PRIMARY KEY CLUSTERED ( Match_Id , bowlername ),
FOREIGN KEY ( Match_Id ) REFERENCES Matchessummary ( Match_Id )
)


CREATE TABLE temporarybowlingsummary
(
Match_Id int NOT NULL,
country varchar(255),
innings varchar(10) NOT NULL,
bowlername varchar(150) NOT NULL,
totalballsbowled int,
oversbowled numeric,
runsgiven int,
wicketstaken int,
dotballsbowled int,
economyrate numeric,
widesbowled int,
noballsbowled int,
countof4sgiven int,
countof6sgiven int

PRIMARY KEY CLUSTERED ( Match_Id , bowlername ),
  FOREIGN KEY ( Match_Id ) REFERENCES temporaryMatchessummary ( Match_Id )
)

CREATE TABLE  playerbowlingdetails
(Bowlerid INT,
bowlername varchar(255),
country varchar(255),
noofinningbowled int,
totalballsbowled int,
totalrunsgiven int,
totalwicketstaken int,
totaldotballsbowled int,
totalwidesbowled int,
totalnoballsbowled int,
totalcountof4sgiven int,
totalcountof6sgiven int

Foreign key(bowlerid ) references playerdetails(playerid)
)

CREATE TABLE fallofwickets
(
innings varchar(10),
wicket varchar(10),
playerout varchar(150),
outatball numeric,
runsscored int,
partnership varchar(100),
runrate numeric,
overplayed numeric,
Match_Id int NOT NULL


  FOREIGN KEY ( Match_Id ) REFERENCES Matchessummary ( Match_Id )
)

CREATE TABLE temporaryfallofwickets
(
innings varchar(10) ,
wicket varchar(10),
playerout varchar(150),
outatball numeric,
runsscored int,
partnership varchar(100),
runrate numeric,
overplayed numeric,
Match_Id int NOT NULL

  FOREIGN KEY ( Match_Id ) REFERENCES temporaryMatchessummary ( Match_Id )
)

CREATE TABLE matchanalysis
(
matchbetween varchar(255),
interestedteamname varchar(255),
opposition varchar(255),
match_winner varchar(255),
matchgender varchar(255),
matchvenue varchar(255),
tosswonby varchar(255),
tosswinnerdecision varchar(255),
interestedbattinginnings varchar(10),
playerofmatch varchar(255),
totalrunscored int,
Highest_score int,
totalwicketslost int,
toppartnershipwicket varchar(255),
toppartnershipruns int
)


