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

CREATE TABLE Locations
(LocationID INT IDENTITY(1,1),
LocationName VARCHAR(200) NOT NULL,
SeriesID INT NOT NULL,
TitleID INT NULL,
WorldID INT NULL,
Environment1 VARCHAR(15) NULL,
Environment2 VARCHAR(15) NULL,
Environment3 VARCHAR(15) NULL,
[Population] INT NULL,
Notes VARCHAR(MAX) NULL




CONSTRAINT PK_LocationID PRIMARY KEY (LocationID),
CONSTRAINT FK_Locations_Series FOREIGN KEY (SeriesID) REFERENCES Series(SeriesID),
CONSTRAINT FK_Locations_Titles FOREIGN KEY (TitleID) REFERENCES Titles(TitleID),
CONSTRAINT FK_Locations_Worlds FOREIGN KEY (WorldID) REFERENCES Worlds(WorldID)
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
CONSTRAINT CK_Obtain CHECK (ObtainMethod IN ('Default', 'Unlock', 'Purchase', 'Punishment', 'Drop'))
)




























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
('Sub-Boss Enemy', 'These are enemies that are stronger than the average enemy. They might move faster, or take more hits, or '),
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
VALUES ('Sniper', 'Mundy', 1, 1, 7, 42,'One of the Support classes of Team Fortress 2, Mr. Mundy, while initially seemingly Australian, is actually from New Zealand. Much to his adoptive parents disapproval, he snipes down his targets with excellent accuracy and a hard set of standards.')

INSERT Characters ( CharTitle, SeriesID, TitleID, RoleID, Notes)
VALUES ('Spy', 1, 1, 7, 'One of the Support classes of Team Fortress 2, the Spy is mystery-incarnate. No one knows exactly where he is from or who he is. He sneaks around like a specter, and just when you least expect it, you might find a knife lodged into your spinal column.')


INSERT Worlds (WorldName, SeriesID)
VALUES ('Earth', 1)


INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Banana Bay', 1, 1, 1, 'Tropical', NULL, 'A community-created Payload Race map introduced in the October 20, 2017 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Brazil', 1, 1, 1, 'Jungle', NULL, 'A community-created King of the Hill map introduced in the October 20, 2017 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, Environment2, [Population], Notes)
VALUES ('Enclosure', 1, 1, 1, 'Jungle', 'Industrial', NULL, 'A community-created Payload map introduced in the October 20, 2017 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, Environment2, [Population], Notes)
VALUES ('Lazarus', 1, 1, 1, 'Jungle', 'Industrial', NULL, 'A community-created King of the Hill map introduced in the October 20, 2017 patch.')

--SELECT * FROM Locations

--UPDATE Locations
--SET Notes .WRITE ('B', 0, 1)
--WHERE LocationID = 1

--UPDATE Locations
--SET LocationName = STUFF(LocationName, 1, 0, 'ack')
--WHERE LocationID = 4


INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Mercenary Park', 1, 1, 1, 'Ruins', NULL, 'An official Attack/Defend map created by Valve. It was introduced in the October 20, 2017 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Mossrock', 1, 1, 1, 'Jungle', NULL, 'A community-created Attack/Defend map introduced in the October 20, 2017 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('2Fort', 1, 1, 1, 'Farmland', NULL, 'An official Capture the Flag map that was shipped with the release of Team Fortress 2.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('2Fort Invasion', 1, 1, 1, 'Farmland', NULL, 'A variant of the Capture the Flag map, 2Fort, introduced in the October 6, 2015 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, Environment2, [Population], Notes)
VALUES ('Double Cross', 1, 1, 1, 'Alpine', 'Industrial', NULL, 'An official Capture the Flag map created by Valve, introduced in the December 17, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Landfall', 1, 1, 1, 'Alpine', NULL, 'A community-created Capture the Flag map introduced in the December 17, 2015 patch..')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Sawmill', 1, 1, 1, 'Alpine', NULL, 'An official Capture the Flag / King of the Hill / Arena map created by Valve. The former two modes were introduced in the August 13, 2009 patch, while the latter mode was introduced in the May 21, 2009 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Turbine', 1, 1, 1, 'Industrial', NULL, 'A community-created Capture the Flag map introduced in the June 19, 2008 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Well', 1, 1, 1, 'Industrial', NULL, 'An official Control Point / Capture the Flag / Arena map created by Valve. The former mode was released with Team Fortress 2, while CTF was released in the January 25, 2008 patch, and the latter was released in the August 19, 2008 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('5Gorge', 1, 1, 1, 'Alpine', NULL, 'An official Control Point map created by Valve in the January 19, 2011 patch.')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Badlands', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Coldfront', 1, 1, 1, 'Snowy', 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Fastlane', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Foundry', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Freight', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Granary', 1, 1, 1, 'Farmland', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Gullywash', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Metalworks', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Powerhouse', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Process', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Sinshine', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Snakewater', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Sunshine', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Vanguard', 1, 1, 1, 'Construction', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Well', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Yukon', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Egypt', 1, 1, 1, 'Egyptian', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, Evnironment2, [Population], Notes)
VALUES ('Gorge', 1, 1, 1, 'Alpine', 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Gorge Event', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Gravel Pit', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Junction', 1, 1, 1, 'Spytech', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Mann Manor', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Mountain Lab', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Snowplow', 1, 1, 1, 'Snowy', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Steel', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('DeGroot Keep', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Standin', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Hydro', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Badwater Basin', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Barnblitz', 1, 1, 1, 'Snow', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Borneo', 1, 1, 1, 'Jungle', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Brimstone', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Cactus Canyon', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Frontier', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Gold Rush', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Hellstone', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Hoodoo', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Snowycoast', 1, 1, 1, 'Snow', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Swiftwater', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Thunder Mountain', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Upward', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Helltower', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Hightower', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Nightfall', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Pipeline', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Byre', 1, 1, 1, 'Farmland', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Granary', 1, 1, 1, 'Farmland', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Lumberyard', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Nucleus', 1, 1, 1, 'Spytech', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Offblast', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Ravine', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Watchtower', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Well', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Eyeaduct', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Ghost Fort', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Harvest', 1, 1, 1, 'Farmland', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Harvest Event', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Highpass', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Kong King', 1, 1, 1, 'City', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Lakeside', 1, 1, 1, 'Egyptian', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Maple Ridge Event', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Moonshine Event', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Probed', 1, 1, 1, 'Farmland', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Suijin', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Viaduct', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Carnival of Carnage', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Doomsday', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Dustbowl', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Target', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Bigrock', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Coal Town', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Decoy', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Ghost Town', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Mannhattan', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Mannworks', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Rottenburg', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Foundry', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Hellfire', 1, 1, 1, 'Desert', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Brickyard', 1, 1, 1, 'Industrial', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('District', 1, 1, 1, 'City', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Timberlodge', 1, 1, 1, 'Alpine', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, [Population], Notes)
VALUES ('Pit of Death', 1, 1, 1, 'Halloween', NULL, '')

INSERT Locations (LocationName, SeriesID, TitleID, WorldID, Environment1, Environment2, [Population], Notes)
VALUES ('Watergate', 1, 1, 1, 'Brewery', 'Maritime City', NULL, '')

