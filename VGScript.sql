USE master
IF (SELECT COUNT(*) FROM sys.databases WHERE name = 'VGDatabase') > 0
BEGIN
DROP DATABASE VGDatabase
END

CREATE DATABASE VGDatabase

GO
USE VGDatabase

CREATE TABLE Companies
(CompanyID INT IDENTITY(1,1),
 CompanyName VARCHAR(150) NOT NULL,
 HQStreetAddress VARCHAR(150) NULL,
 HQCity VARCHAR(150) NULL,
 HQRegion VARCHAR(150) NULL,
 HQCountry VARCHAR(150) NULL,
 Notes VARCHAR(MAX) NULL

CONSTRAINT PK_CompanyID PRIMARY KEY (CompanyID)

)

CREATE NONCLUSTERED INDEX  ind_CompanyName  ON Companies (CompanyName)
CREATE NONCLUSTERED INDEX  ind_CompanyStAddress  ON Companies (HQStreetAddress)
CREATE NONCLUSTERED INDEX  ind_CompanyCity  ON Companies (HQCity)
CREATE NONCLUSTERED INDEX  ind_CompanyCountry  ON Companies (HQCountry)

CREATE TABLE Platforms
(PlatformID INT IDENTITY(1,1),
[Platform] VARCHAR(35) NOT NULL,
Manufacturer VARCHAR(35) NOT NULL,
ReleaseDate DATE NULL,
Generation TINYINT NULL,
UnitsSold INT NULL,
Price MONEY NULL,
Discontinued BIT NULL,
DisconDate DATE NULL,
Notes VARCHAR(MAX) NULL

CONSTRAINT PK_PlatformID PRIMARY KEY (PlatformID)
)

CREATE TABLE Series
(SeriesID INT IDENTITY(1,1),
SeriesName VARCHAR(100) NOT NULL,
DebutDate DATE NULL,

Notes VARCHAR(MAX) NULL

CONSTRAINT PK_SeriesID PRIMARY KEY (SeriesID)

)

CREATE TABLE Titles
(TitleID INT IDENTITY(1,1),
SeriesID INT NOT NULL,
Title VARCHAR(100) NOT NULL,
SeriesPlacement VARCHAR(20),
ReleaseDate DATE NULL,
PCSpecs VARCHAR(MAX) NULL,
Notes VARCHAR(MAX) NULL


CONSTRAINT PK_TitleID PRIMARY KEY (TitleID)
CONSTRAINT FK_Titles_Series FOREIGN KEY (SeriesID) REFERENCES Series (SeriesID)
)

CREATE TABLE PlatformTitle
(TitleID INT NOT NULL,
PlatformID INT NOT NULL,


CONSTRAINT PK_PlatformID_TitleID PRIMARY KEY (PlatformID, TitleID),
CONSTRAINT FK_PlatformTitle_Titles FOREIGN KEY (TitleID) REFERENCES Titles(TitleID),
CONSTRAINT FK_PlatformTitle_Platforms FOREIGN KEY (PlatformID) REFERENCES Platforms(PlatformID)

)



CREATE TABLE CharacterRoles
(RoleID INT IDENTITY(1,1),
CharacterRole VARCHAR(100) NOT NULL,
RoleDescription VARCHAR(MAX) NULL

CONSTRAINT PK_RoleID PRIMARY KEY (RoleID)
)

CREATE TABLE Characters
(CharacterID INT IDENTITY(1,1),
CharTitle VARCHAR(50) NULL,
CharFirstName VARCHAR(50) NULL,
CharMidName VARCHAR(50) NULL,
CharLastName VARCHAR(50) NULL,
Suffix VARCHAR(10) NULL,
SeriesID INT NOT NULL,
TitleID INT NULL,
RoleID INT NOT NULL,
Age SMALLINT NULL,
Notes VARCHAR(MAX) NULL,

CONSTRAINT PK_CharacterID PRIMARY KEY (CharacterID),
CONSTRAINT FK_Characters_Series FOREIGN KEY (SeriesID) REFERENCES Series (SeriesID),
CONSTRAINT FK_Characters_Titles FOREIGN KEY (TitleID) REFERENCES Titles (TitleID),
CONSTRAINT FK_Characters_CharacterRoles FOREIGN KEY (RoleID) REFERENCES CharacterRoles (RoleID),
CONSTRAINT CK_NoNullName CHECK (CharTitle is not NULL OR CharFirstName is not NULL OR CharMidName is not NULL OR CharLastName is not NULL)
)


CREATE TABLE Worlds
(WorldID INT IDENTITY(1,1),
WorldName VARCHAR(100) NOT NULL,
[Population] BIGINT NULL,
SeriesID INT NOT NULL,
TitleID INT NULL


CONSTRAINT PK_WorldID PRIMARY KEY (WorldID),
CONSTRAINT FK_Worlds_Series FOREIGN KEY (SeriesID) REFERENCES Series (SeriesID),
CONSTRAINT FK_Worlds_Titles FOREIGN KEY (TitleID) REFERENCES Titles(TitleID)
)

CREATE TABLE Environments
(
EnvironmentID INT IDENTITY(1,1),
Environment VARCHAR(50) NOT NULL
CONSTRAINT PK_EnvironmentID PRIMARY KEY (EnvironmentID)
)

CREATE TABLE Locations
(LocationID INT IDENTITY(1,1),
LocationName VARCHAR(200) NOT NULL,
SeriesID INT NOT NULL,
TitleID INT NULL,
WorldID INT NULL,
[Population] INT NULL,
Notes VARCHAR(MAX) NULL




CONSTRAINT PK_LocationID PRIMARY KEY (LocationID),
CONSTRAINT FK_Locations_Series FOREIGN KEY (SeriesID) REFERENCES Series(SeriesID),
CONSTRAINT FK_Locations_Titles FOREIGN KEY (TitleID) REFERENCES Titles(TitleID),
CONSTRAINT FK_Locations_Worlds FOREIGN KEY (WorldID) REFERENCES Worlds(WorldID),

)

CREATE TABLE LocationEnvironments
(
LocationID INT NOT NULL,
EnvironmentID INT NOT NULL
CONSTRAINT PK_LocationEnvironmentID PRIMARY KEY (LocationID, EnvironmentID),
CONSTRAINT FK_LE_Locations FOREIGN KEY (LocationID) REFERENCES Locations(LocationID),
CONSTRAINT FK_LE_Environments FOREIGN KEY (EnvironmentID) REFERENCES Environments(EnvironmentID)
)

CREATE TABLE Races
(RaceID INT IDENTITY(1,1),
RaceName VARCHAR(50) NOT NULL,
SeriesID INT NOT NULL,
TitleID INT NULL,
WorldID INT NULL,
LocationID INT NULL

CONSTRAINT PK_RaceID PRIMARY KEY (RaceID),
CONSTRAINT FK_Races_Series FOREIGN KEY (SeriesID) REFERENCES Series(SeriesID),
CONSTRAINT FK_Races_Titles FOREIGN KEY (TitleID) REFERENCES Titles(TitleID),
CONSTRAINT FK_Races_Worlds FOREIGN KEY (WorldID) REFERENCES Worlds(WorldID),
CONSTRAINT FK_Races_Locations FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
)

CREATE TABLE ItemPurpose(
PurposeID INT IDENTITY(1,1),
ItemPurpose VARCHAR(100) NOT NULL

CONSTRAINT PK_ItemPurpose PRIMARY KEY (PurposeID)
)


CREATE TABLE Items
(ItemID INT IDENTITY(1,1),
ItemName VARCHAR(100) NOT NULL,
PrimaryPurpose INT NULL,
SecondaryPurpose INT NULL,
TertiaryPurpose INT NULL,
BaseDamage VARCHAR(15) NULL,
ObtainMethod VARCHAR(35) NULL


CONSTRAINT PK_ItemID PRIMARY KEY (ItemID),
CONSTRAINT FK_Item_Purpose1 FOREIGN KEY (PrimaryPurpose) REFERENCES ItemPurpose(PurposeID),
CONSTRAINT FK_Item_Purpose2 FOREIGN KEY (SecondaryPurpose) REFERENCES ItemPurpose(PurposeID),
CONSTRAINT FK_Item_Purpose3 FOREIGN KEY (TertiaryPurpose) REFERENCES ItemPurpose(PurposeID) ,
CONSTRAINT CK_Obtain CHECK (ObtainMethod IN ('Default', 'Unlock', 'Purchase', 'Punishment', 'Random Drop'))
)






---------------------------------POPULATION START-----------------------------------------------------------------------------------------------






INSERT Platforms ([Platform], Manufacturer, ReleaseDate, Generation, UnitsSold, Price, Discontinued, DisconDate)
VALUES ('Windows PC', 'Microsoft', NULL, NULL, NULL, NULL, 0, NULL)

INSERT Platforms ([Platform], Manufacturer, ReleaseDate, Generation, UnitsSold, Price, Discontinued, DisconDate)
VALUES ('Magnavox Odyssey', 'Magnavox', '09-01-1972', 1, 350000, '99.00', 1, '1975')

INSERT Platforms ([Platform],Manufacturer, ReleaseDate, Generation, UnitsSold, Price, Discontinued, DisconDate)
VALUES ('Ping-O-Tronic', 'Zanussi', '09-01-1972', 1, 1000000, NULL, 1, NULL)

INSERT Platforms ([Platform], Manufacturer, ReleaseDate, Generation, UnitsSold, Price, Discontinued, DisconDate)
VALUES ('Playstation', 'Sony', '09-09-1995', 5, 102490000, '299.00', 1, '03-23-2006')

INSERT Platforms ([Platform], Manufacturer, ReleaseDate, Generation, UnitsSold, Price, Discontinued, DisconDate)
VALUES ('Nintendo 64', 'Nintendo', '09-29-1996', 5, 32930000, '199.99', 1, '03-23-2006')

INSERT Platforms ([Platform], Manufacturer, ReleaseDate, Generation, UnitsSold, Price, Discontinued, DisconDate)
VALUES ('Xbox 360', 'Microsoft', '11-22-2005', 7, 83700000, '399.99', 1, '04-20-2016')

INSERT Platforms ([Platform], Manufacturer, ReleaseDate, Generation, UnitsSold, Price, Discontinued, DisconDate)
VALUES ('Playstation 2', 'Sony', '10-26-2000', 6, 155000000, '299.00', 1, '01-14-2013')

INSERT Platforms ([Platform], Manufacturer, ReleaseDate, Generation, UnitsSold, Price, Discontinued, DisconDate)
VALUES ('Playstation 3', 'Sony', '11-11-2006', 7, 80000000, '599.00', 1, '05-29-2017')





INSERT CharacterRoles (CharacterRole, RoleDescription)
VALUES ('Primary Protagonist', 'The good guy, the Chosen One, the big kahuna, the underdog; whatever they are, it probably is what you are playing as. To put it simply, it is the main "good" character.'), 
('Secondary Protagonist', 'Your best friend, your partner-in-crime, the peanut butter to your jelly; this character '), 
('Primary Antagonist', 'The big baddie, the Cursed King of Darkness and Evil and the Common Cold, your jerk neighbor, Ted; whatever this is, it is your primary enemy. If the end goal (or at least primary goal) of the game is to defeat, overthrow, thwart, convert, or just kick the butt of whoever this is, then they probably fall in this category.'), 
('Secondary Antagonist', 'Maybe they are second-in-command to the Primary Antagonist, or maybe they are completely unrelated to them; this category of enemy, while not as imperative to the player, is still (probably) a gigantic threat. They tend to appear as a boss right before the Primary Antagonist, or a bit before them.'), 
('Boss Enemy', 'Terror. Frustration. Awe. These big baddies will probably inspire these in the player, or at least in the player character.'),
('Sub-Boss Enemy', 'These are enemies that are stronger than the average enemy. They might move faster, or take more hits, or have some mindblowing ability that separates them from the rest of the fodder. "Mini-bosses" would fall in this category.'),
	('Generic Enemy', 'Maybe it is just something you would consider fodder, or maybe it is nothing to scoff at, but something that falls in this category is a threat to you; however, it is not relevant enough to the plot of the game or powerful enough (or grandiose enough) to fall into the other enemy categories.'),
		('Generic NPC', 'Another face in the crowd, these are characters that you cannot play as, and either have very little character to them, or are incredibly inconsequential to the story. However, they still do have a set name or title.'), 
		('Shopkeeper', 'So many wares! This role encompasses those that sell you different types of item'), ('Character Class', ''), ('Primary Grey Character', ''), ('Secondary Grey Character', '')







INSERT Series (SeriesName, DebutDate)
VALUES ('Team Fortress', '04-07-1999')







INSERT Titles (SeriesID, Title, SeriesPlacement, ReleaseDate, PCSpecs)
VALUES (1, 'Team Fortress 2', 'Second Installment', '10-10-2007', 'OS: Windows® 7 (32/64-bit)/Vista/XP . 
Processor: 1.7 GHz Processor or better . Memory: 512 MB RAM . DirectX: Version 8.1 . 
Network: Broadband Internet connection . Storage: 15 GB available space')





INSERT PlatformTitle (TitleID, PlatformID)
VALUES (1, 1), (1, 6), (1, 8)







INSERT Characters ( CharTitle, CharFirstName, SeriesID, TitleID, RoleID, Age, Notes)
VALUES ('Scout', 'Jeremy', 1, 1, 7, 23, 'One of the Offensive classes of Team Fortress 2, the Scout is a whizzing little annoyance, with a mouth to match it. Hailing from southern Boston, the Scout sprints around the battlefield, jumping and shooting his opponents at high speeds.')

INSERT Characters ( CharTitle, CharFirstName, CharLastName, SeriesID, TitleID, RoleID, Age, Notes)
VALUES ('Soldier' , 'Jane', 'Doe', 1, 1, 7, 45, 'One of the Offensive classes of Team Fortress 2, the Soldier is a jingoistic American with the intelligence and mental fortitude of a brick wall. He blasts around the battlefield by shooting rockets at his feet and shoots freedom directly into the skulls of his enemies.')

INSERT Characters ( CharTitle, SeriesID, TitleID, RoleID, Notes)
VALUES ('Pyro', 1, 1, 7, 'One of the Offensive classes of Team Fortress 2, not much is known about the Pyro. All that is known is that they REALLY like burning things... sort of. They think they are playing with the other mercenaries in their severe delusion, but that is about all that is known. Their name? Unknown. Their sex? Unknown. Their motivation? Unknown.')

INSERT Characters ( CharTitle, CharFirstName, CharMidName, CharLastName, SeriesID, TitleID, RoleID, Age, Notes)
VALUES ('Demoman', 'Tavish', 'Finnegan', 'DeGroot', 1, 1, 7, 41, 'One of the Defensive classes of Team Fortress 2, Tavish is a master of explosives hailing from the Scottish Highlands. He has described himself as a black, Scottish cyclops, due to having lost his eye as a child... and being black... and from Scotland.')

INSERT Characters ( CharTitle, CharFirstName, SeriesID, TitleID, RoleID, Age, Notes)
VALUES ('Heavy', 'Mikhael', 1, 1, 7, 57, 'One of the Defensive classes of Team Fortress 2, Mikhael (or "Misha" by his family, and "Heavy" by... everyone else) is a tank of a man from the coldest regions of Russia. His massive minigun, Sasha, mows down his enemies as he holds the objective, laughing at their puny attempts to capture it.')

INSERT Characters ( CharTitle, CharFirstName, CharLastName, SeriesID, TitleID, RoleID, Age, Notes)
VALUES ('Engineer', 'Dell', 'Conagher', 1, 1, 7, 35, 'One of the Defensive classes of Team Fortress 2, Dell is a soft-spoken boy from good ol Texas. He can create an array of buildings to assist his team with their battles, or to mow down any enemy foolish enough to walk in its sights.')

INSERT Characters ( CharTitle, CharLastName, SeriesID, TitleID, RoleID, Age, Notes)
VALUES ('Medic', 'Ludwig', 1, 1, 7, 50, 'One of the Support classes of Team Fortress 2, Dr. Ludwig (who is really just known as the Medic) is an interesting man; it seems that he wants to keep his team alive and well, but with how he acts, you could say the Hippocratic Oath is really more of a Hippocratic Suggestion. He has a morbid fascination with the limits of the insides of humans, and his ingenuity knows no bounds.')

INSERT Characters ( CharTitle, CharLastName, SeriesID, TitleID, RoleID, Age, Notes)
VALUES ('Sniper', 'Mundy', 1, 1, 7, 42,'One of the Support classes of Team Fortress 2, Mr. Mundy, while initially seemingly Australian, is actually from New Zealand. Much to his adoptive parents disapproval, he snipes down his targets with impeccable accuracy and a firm set of standards.')

INSERT Characters ( CharTitle, SeriesID, TitleID, RoleID, Notes)
VALUES ('Spy', 1, 1, 7, 'One of the Support classes of Team Fortress 2, the Spy is mystery-incarnate. No one knows exactly where he is from or who he is. He sneaks around like a specter, and just when you least expect it, you might find a knife lodged into your spinal column.')







INSERT Worlds (WorldName, SeriesID)
VALUES ('Earth', 1)




INSERT Environments (Environment)
VALUES ('Tropical'),('Jungle'),('Industrial'),('Ruins'),('Farmland'),('Alpine'),('Desert'),('Snowy'),('Halloween'),
('Construction'),('Egyptian'),('Spytech'),('City'),('Maritime City'),('Brewery'),('Tundra'), ('Volcanic'), ('Metropolis'),
('Village')



INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Banana Bay', 1, 1, 1, NULL, 'A community-created Payload Race map introduced in the October 20, 2017 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Brazil', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the October 20, 2017 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID,   [Population], Notes)
VALUES ('Enclosure', 1, 1, 1,   NULL, 'A community-created Payload map introduced in the October 20, 2017 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID,   [Population], Notes)
VALUES ('Lazarus', 1, 1, 1,   NULL, 'A community-created King of the Hill map introduced in the October 20, 2017 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Mercenary Park', 1, 1, 1, NULL, 'An official Attack/Defend map created by Valve. It was introduced in the October 20, 2017 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Mossrock', 1, 1, 1, NULL, 'A community-created Attack/Defend map introduced in the October 20, 2017 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('2Fort', 1, 1, 1, NULL, 'An official Capture the Flag map that was shipped with the release of Team Fortress 2.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('2Fort Invasion', 1, 1, 1, NULL, 'A variant of the Capture the Flag map, 2Fort, introduced in the October 6, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID,   [Population], Notes)
VALUES ('Double Cross', 1, 1, 1,   NULL, 'An official Capture the Flag map created by Valve, introduced in the December 17, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Landfall', 1, 1, 1, NULL, 'A community-created Capture the Flag map introduced in the December 17, 2015 patch..')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Sawmill', 1, 1, 1, NULL, 'An official Capture the Flag / King of the Hill / Arena map created by Valve. The former two modes were introduced in the August 13, 2009 patch, while the latter mode was introduced in the May 21, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Turbine', 1, 1, 1, NULL, 'A community-created Capture the Flag map introduced in the June 19, 2008 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Well', 1, 1, 1, NULL, 'An official Control Point / Capture the Flag / Arena map created by Valve. The former mode was released with Team Fortress 2, while CTF was released in the January 25, 2008 patch, and the latter was released in the August 19, 2008 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('5Gorge', 1, 1, 1, NULL, 'An official Control Point map created by Valve in the January 19, 2011 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Badlands', 1, 1, 1, NULL, 'An official Control Point / King of the Hill / Arena map created by Valve. The Control point variant was released in the February 14, 2008 patch, the Arena variant was released in the August 19, 2008 patch, and the King of the Hill variant was released in the April 14, 2011 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID,   [Population], Notes)
VALUES ('Coldfront', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the July 8, 2010 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Fastlane', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the June 19, 2008 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Foundry', 1, 1, 1, NULL, 'An official Control Point / Mannpower map created by Valve. The Control Point variant was introduced in the December 15, 2011 patch, while the Mannpower variant was introduced in the December 22, 2014 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Freight', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the April 28, 2010 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Granary', 1, 1, 1, NULL, 'An official Control Point / Arena map created by Valve. The Control point variant was shipped with the release of Team Fortress 2, while the Arena variant was released in the August 19, 2008 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Gullywash', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the October 13, 2011 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Metalworks', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the July 7, 2016 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Powerhouse', 1, 1, 1, NULL, 'An official Control Point map created by Valve in the July 2, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Process', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the July 10, 2013 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Sinshine', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the October 28, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Snakewater', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the November 21, 2013 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Sunshine', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the July 7, 2016 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Vanguard', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the December 17, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Yukon', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the August 13, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Egypt', 1, 1, 1, NULL, 'A community-created Attack/Defend map introduced in the February 24, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID,   [Population], Notes)
VALUES ('Gorge', 1, 1, 1,   NULL, 'An official Attack/Defend / Mannpower map created by Valve. The Attack/Defend variant was introduced in the December 17, 2009 patch, while the Mannpower variant was introduced in the December 22, 2014 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Gorge Event', 1, 1, 1, NULL, 'A community-created Attack/Defend map introduced in the October 28, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Gravel Pit', 1, 1, 1, NULL, 'An official Attack/Defend map that was shipped with the release of Team Fortress 2.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Junction', 1, 1, 1, NULL, 'A community-created Attack/Defend map introduced in the February 24, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Mann Manor', 1, 1, 1, NULL, 'An Attack/Defend map that was created by both Valve and several community members. It was introduced in the October 27, 2010 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Mountain Lab', 1, 1, 1, NULL, 'An Attack/Defend map that was created by both Valve and several community members. It was introduced in the October 27, 2010 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Snowplow', 1, 1, 1, NULL, 'A community-created Attack/Defend map introduced in the July 2, 2015 patch. It works slightly different from other Attack/Defend maps, as the timer for the attackers is measured by damage a train that they are guiding has received.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Steel', 1, 1, 1, NULL, 'A community-created Attack/Defend map introduced in the August 19, 2008 patch. It works slightly different from the other Attack/Defend maps, as the final control point for the attackers is available from the beginning, but is harder to capture the more points that remain under the control of the defending team.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('DeGroot Keep', 1, 1, 1, NULL, 'An official Attack/Defend map created by Valve in the December 17, 2010 patch. This is the only map that supports Medieval mode, which limits the items available, mainly to just melee weapons.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Standin', 1, 1, 1, NULL, 'A community-created Control Point map that follows a special set of rules known as "Domination".  It was introduced in the July 10, 2013 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Hydro', 1, 1, 1, NULL, 'An official map that was shipped with the release of Team Fortress 2. Its game type is unique only to itself, known as "Territorial Control", which is similar to a Control Point map.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Badwater Basin', 1, 1, 1, NULL, 'An official Payload map created by Valve in the August 19, 2008 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Barnblitz', 1, 1, 1, NULL, 'An official Payload map created by Valve in the June 23, 2011 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Borneo', 1, 1, 1, NULL, 'A community-created Payload map introduced in the July 2, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Brimstone', 1, 1, 1, NULL, 'A community-created Payload map introduced in the October 21, 2016 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Cactus Canyon', 1, 1, 1, NULL, 'An official Payload map created by Valve in the July 8, 2014 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Frontier', 1, 1, 1, NULL, 'A community-created Payload map introduced in the February 24, 2011 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Gold Rush', 1, 1, 1, NULL, 'An official Payload map created by Valve in the April 29, 2008 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Hellstone', 1, 1, 1, NULL, 'A community-created Payload map introduced in the October 28, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Hoodoo', 1, 1, 1, NULL, 'A community-created Payload map introduced in the May 21, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Snowycoast', 1, 1, 1, NULL, 'A community-created Payload map introduced in the December 17, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Swiftwater', 1, 1, 1, NULL, 'A community-created Payload map introduced in the July 7, 2016 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Thunder Mountain', 1, 1, 1, NULL, 'An official Payload / Mannpower map created by Valve. The Payload variant was introduced in the July 8, 2010 patch, while the Mannpower variant was introduced in the March 12, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Upward', 1, 1, 1, NULL, 'An official Payload map created by Valve in the July 8, 2010 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Helltower', 1, 1, 1, NULL, 'An official Payload Race map created by Valve in the October 29, 2013 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Hightower', 1, 1, 1, NULL, 'An official Payload Race map created by Valve in the July 8, 2010 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Nightfall', 1, 1, 1, NULL, 'A community-created Payload Race map introduced in the February 24, 2011 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Pipeline', 1, 1, 1, NULL, 'An official Payload Race map created by Valve in the May 21, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Byre', 1, 1, 1, NULL, 'A community-created Arena map introduced in the October 6, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Lumberyard', 1, 1, 1, NULL, 'An official Arena map created by Valve in the August 19, 2008 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Nucleus', 1, 1, 1, NULL, 'An official Arena / King of the Hill map created by Valve. The Arena variant was introduced in the May 21, 2009 patch, while the King of the Hill variant was introduced in the August 13, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Offblast', 1, 1, 1, NULL, 'A community-created Arena map introduced in the August 13, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Ravine', 1, 1, 1, NULL, 'An official Arena map created by Valve in the August 19, 2008 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Watchtower', 1, 1, 1, NULL, 'A community-created Arena map introduced in the February 24, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Eyeaduct', 1, 1, 1, NULL, 'An official King of the Hill map created by Valve in the October 27, 2011 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Ghost Fort', 1, 1, 1, NULL, 'An official King of the Hill map created by Valve in the October 26, 2012 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Harvest', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the October 29, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Harvest Event', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the October 29, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Highpass', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the December 17, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Kong King', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the August 10, 2012 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Lakeside', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the February 24, 2011 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Maple Ridge Event', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the October 21, 2016 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Moonshine Event', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the October 28, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Probed', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the October 6, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Suijin', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the July 2, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Viaduct', 1, 1, 1, NULL, 'An official King of the Hill map created by Valve in the August 13, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Carnival of Carnage', 1, 1, 1, NULL, 'An official Special Delivery map created by Valve in the October 29, 2014 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Doomsday', 1, 1, 1, NULL, 'An official Special Delivery map created by Valve in the June 27, 2012 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Dustbowl (Training)', 1, 1, 1, NULL, 'A special variant of Dustbowl created by Valve in the June 10, 2010 patch. It was created to introduce new players to the mechanics of Team Fortress 2 in a very enclosed environment.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Target', 1, 1, 1, NULL, 'A training map created by Valve in the June 10, 2010 patch. It is essentially a shooting range.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Bigrock', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the December 20, 2012 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Coal Town', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the August 15, 2012 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Decoy', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the August 15, 2012 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Ghost Town', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the October 26, 2012 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Mannhattan', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the November 21, 2013 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Mannworks', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the August 15, 2012 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Rottenburg', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the November 21, 2013 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Asteroid', 1, 1, 1, NULL, 'A special map created by Valve in the July 8, 2014 patch. It used a unique gamemode called "Robot Destruction", however this map never left beta.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Hellfire', 1, 1, 1, NULL, 'An official Mannpower map created by Valve in the October 28, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Brickyard', 1, 1, 1, NULL, 'A PASS Time map that was created by both Valve and two other studios: Bad Robot and Escalation Studios. It was introduced in the August 18, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('District', 1, 1, 1, NULL, 'A PASS Time map that was created by both Valve and two other studios: Bad Robot and Escalation Studios. It was introduced in the July 7, 2016 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Timberlodge', 1, 1, 1, NULL, 'A PASS Time map that was created by both Valve and two other studios: Bad Robot and Escalation Studios. It was introduced in the November 25, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Pit of Death', 1, 1, 1, NULL, 'A community-created Player Destruction map introduced in the October 21, 2016 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID,   [Population], Notes)
VALUES ('Watergate', 1, 1, 1, NULL, 'A community-created Player Destruction map introduced in the October 6, 2015 patch.')

SELECT * FROM Locations 
SELECT * FROM Environments

INSERT LocationEnvironments
VALUES ( 1, 1), (1, 2), ( 2, 2), ( 3, 2), ( 3, 3), ( 4, 2), ( 4, 3), ( 5, 2), ( 5, 4), ( 6, 2), ( 7, 5), ( 8, 5), ( 9, 3), 
( 9, 6), ( 10, 6), ( 11, 6), ( 12, 3), ( 13, 3), ( 14, 6), ( 15, 7), ( 16, 6), ( 16, 8), ( 17, 7), ( 18, 3), ( 19, 7), 
( 20, 5), ( 21, 7), ( 22, 3), ( 23, 3), ( 24, 3), ( 24, 6), ( 25, 9), ( 26, 6), ( 27, 6), ( 28, 10), ( 29, 6), ( 30, 11), 
( 31, 6), 
