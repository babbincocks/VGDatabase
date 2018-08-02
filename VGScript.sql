USE master
IF (SELECT COUNT(*) FROM sys.databases WHERE name = 'VGDatabase') > 0
BEGIN
DROP DATABASE VGDatabase
END

CREATE DATABASE VGDatabase

GO

IF (SELECT COUNT(*) FROM master.dbo.syslogins WHERE name = 'VGClient') > 0
BEGIN
	DROP LOGIN VGClient
	USE VGDatabase
	--This is weirdly inconsistent from script to script, don't know yet what determines whether this needs to be done yet, but I'm just going to
	--comment it out for now.
	--DROP USER VGClient
	USE master
END

CREATE LOGIN VGClient WITH PASSWORD = 'Scuttlebug'
ALTER LOGIN VGClient WITH DEFAULT_DATABASE = VGDatabase

GO

USE VGDatabase

CREATE USER VGClient FOR LOGIN VGClient

ALTER ROLE db_datareader ADD MEMBER VGClient
ALTER ROLE db_datawriter ADD MEMBER VGClient


GO

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
LocationID INT NULL,
Notes VARCHAR(MAX) NULL

CONSTRAINT PK_RaceID PRIMARY KEY (RaceID),
CONSTRAINT FK_Races_Series FOREIGN KEY (SeriesID) REFERENCES Series(SeriesID),
CONSTRAINT FK_Races_Titles FOREIGN KEY (TitleID) REFERENCES Titles(TitleID),
CONSTRAINT FK_Races_Worlds FOREIGN KEY (WorldID) REFERENCES Worlds(WorldID),
CONSTRAINT FK_Races_Locations FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
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
RaceID INT NULL,
RoleID INT NOT NULL,
Age SMALLINT NULL,
Notes VARCHAR(MAX) NULL,

CONSTRAINT PK_CharacterID PRIMARY KEY (CharacterID),
CONSTRAINT FK_Characters_Series FOREIGN KEY (SeriesID) REFERENCES Series (SeriesID),
CONSTRAINT FK_Characters_Titles FOREIGN KEY (TitleID) REFERENCES Titles (TitleID),
CONSTRAINT FK_Characters_Races FOREIGN KEY (RaceID) REFERENCES Races (RaceID),
CONSTRAINT FK_Characters_CharacterRoles FOREIGN KEY (RoleID) REFERENCES CharacterRoles (RoleID),
CONSTRAINT CK_NoNullName CHECK (CharTitle is not NULL OR CharFirstName is not NULL OR CharMidName is not NULL OR CharLastName is not NULL)
)


CREATE TABLE ItemPurposes(
PurposeID INT IDENTITY(1,1),
ItemPurpose VARCHAR(100) NOT NULL

CONSTRAINT PK_PurposeID PRIMARY KEY (PurposeID)
)

CREATE TABLE ObtainMethods
(
MethodID INT IDENTITY(1,1),
ObtainMethod VARCHAR(35) NOT NULL UNIQUE,

CONSTRAINT PK_MethodID PRIMARY KEY (MethodID)

)

CREATE TABLE Items
(ItemID INT IDENTITY(1,1),
ItemName VARCHAR(100) NOT NULL,
ItemType VARCHAR(35) NOT NULL,
BaseDamage VARCHAR(15) NULL,
ObtainMethod VARCHAR(35) NULL,
SeriesID INT NOT NULL,
TitleID INT NULL,
[Stats] VARCHAR(500) NULL,
Notes VARCHAR(MAX) NULL

CONSTRAINT PK_ItemID PRIMARY KEY (ItemID),
CONSTRAINT FK_Items_Series FOREIGN KEY (SeriesID) REFERENCES Series(SeriesID),
CONSTRAINT FK_Items_Titles FOREIGN KEY (TitleID) REFERENCES Titles(TitleID)
)

CREATE TABLE Items_Purposes
(
ItemID INT,
PurposeID INT
CONSTRAINT PK_ItemPurpose PRIMARY KEY (ItemID, PurposeID),
CONSTRAINT FK_IP_Items FOREIGN KEY (ItemID) REFERENCES Items(ItemID),
CONSTRAINT FK_IP_Purposes FOREIGN KEY (PurposeID) REFERENCES ItemPurposes(PurposeID)
)

CREATE TABLE CharacterItems
(
ItemID INT,
CharacterID INT

CONSTRAINT PK_CharacterItem PRIMARY KEY (ItemID, CharacterID),
CONSTRAINT FK_CharacterItems_Characters FOREIGN KEY (CharacterID) REFERENCES Characters(CharacterID),
CONSTRAINT FK_CharacterItems_Items FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
)


CREATE TABLE Weapons
(
WeaponID INT IDENTITY(1,1),
WeaponName VARCHAR(100) NOT NULL,
WeaponType VARCHAR(35) NOT NULL,
BaseDamage VARCHAR(15) NOT NULL,
ObtainMethod INT NULL,
SeriesID INT NOT NULL,
TitleID INT NULL,
[Stats] VARCHAR(MAX) NULL,
Notes VARCHAR(MAX) NULL

CONSTRAINT PK_WeaponID PRIMARY KEY (WeaponID),
CONSTRAINT FK_Weapons_Series FOREIGN KEY (SeriesID) REFERENCES Series(SeriesID),
CONSTRAINT FK_Weapons_Titles FOREIGN KEY (TitleID) REFERENCES Titles(TitleID),
CONSTRAINT FK_Weapons_Obtain FOREIGN KEY (ObtainMethod) REFERENCES ObtainMethods(MethodID)


)

CREATE TABLE CharacterWeapons
(
WeaponID INT,
CharacterID INT

CONSTRAINT PK_CharacterWeapons PRIMARY KEY (WeaponID, CharacterID),
CONSTRAINT FK_CharWeap_Weapons FOREIGN KEY (WeaponID) REFERENCES Weapons(WeaponID),
CONSTRAINT FK_CharWeap_Characters FOREIGN KEY (CharacterID) REFERENCES Characters(CharacterID)
)
---------------------------------POPULATION START-----------------------------------------------------------------------------------------------






INSERT Platforms ([Platform], Manufacturer, ReleaseDate, Generation, UnitsSold, Price, Discontinued, DisconDate)
VALUES ('Windows PC', 'Microsoft', NULL, NULL, NULL, NULL, 0, NULL)
,('Magnavox Odyssey', 'Magnavox', '09-01-1972', 1, 350000, '99.00', 1, '1975')
,('Ping-O-Tronic', 'Zanussi', '09-01-1972', 1, 1000000, NULL, 1, NULL)
,('Playstation', 'Sony', '09-09-1995', 5, 102490000, '299.00', 1, '03-23-2006')
,('Nintendo 64', 'Nintendo', '09-29-1996', 5, 32930000, '199.99', 1, '03-23-2006')
,('Xbox 360', 'Microsoft', '11-22-2005', 7, 83700000, '399.99', 1, '04-20-2016')
,('Playstation 2', 'Sony', '10-26-2000', 6, 155000000, '299.00', 1, '01-14-2013')
,('Playstation 3', 'Sony', '11-11-2006', 7, 80000000, '599.00', 1, '05-29-2017')





INSERT CharacterRoles (CharacterRole, RoleDescription)
VALUES ('Primary Protagonist', 'The good guy, the Chosen One, the big kahuna, the underdog; whatever they are, it probably is what you are playing as. To put it simply, it is one of the main "good" characters. '), 
('Secondary Protagonist', 'Your best friend, your partner-in-crime, the peanut butter to your jelly; this character is sticking with you to one of, or both of, your bitter ends. This character is probably going to be around the Primary Protagonist a lot, and is quite important to the story, but let''s be honest: they''re not as important as you are.'), 
('Primary Antagonist', 'The big baddie, the Cursed King of Darkness and Evil and the Common Cold, your jerk neighbor, Ted; whatever this is, it is your primary enemy. If the end goal (or at least primary goal) of the game is to defeat, overthrow, thwart, convert, or just kick the butt of whoever this is, then they probably fall in this category. If it''s one of those cases where you''re playing as the bad guy, they''d technically be sorted under Primary Protagonist instead.'), 
('Secondary Antagonist', 'Maybe they are second-in-command to the Primary Antagonist, or maybe they are completely unrelated to them; this category of enemy, while not as imperative to the player, is still (probably) a gigantic threat. They tend to appear as a boss right before the Primary Antagonist, or a bit before them.'), 
('Boss Enemy', 'Terror. Frustration. Awe. These big fellas will probably inspire these in the player, or at least in the player character. These are the type of enemy that perhaps constitutes a big health bar showing up somewhere on the screen, or perhaps they have their own music track, or they have their own unique name. Either way, they are big, they are bad, and you should get ready.'),
('Sub-Boss Enemy', 'These are enemies that are stronger than the average enemy. They might move faster, or take more hits, or have some mindblowing ability that separates them from the rest of the fodder. "Mini-bosses" would fall in this category.'),
	('Generic Enemy', 'Maybe it is just something you would consider fodder, or maybe it is nothing to scoff at, but something that falls in this category is a threat to you; however, it is not relevant enough to the plot of the game or powerful enough (or grandiose enough) to fall into the other enemy categories.'),
		('Generic NPC', 'Another face in the crowd, these are characters that you cannot play as, and either have very little character to them, or are incredibly inconsequential to the story. However, they still do have a set name or title.'), 
		('Shopkeeper', 'So many wares! This role encompasses those whose primary role is to sell you different types of items. Whether they are friend or foe is irrelevant; they have got some cool stuff, so it does not matter that much.'), 
		('Character Class', 'Maybe you want the fast one, or the tanky one, or... maybe the stealthy one. This role is for those that may not have a set name, but are playable and are less so defined by their character, and more so by their abilities.'), 
		('Primary Grey Character', 'One minute, you are helping a sweet grandma across the street; the next, you are robbing a bank, and have already killed 4 hostages. This role covers characters, playable or not, that are at the forefront of the story/game, whose moral compass is more erratic than a confused coke fiend in a sugar factory.'), 
		('Secondary Grey Character', 'Are we cool, or nah? This role covers those that have not really decided whether they are a good or bad guy yet, and they probably will not decide any time soon. A lot of the time these characters are your characters rival of sorts, but that''s in no way a rule.'),
		('Tertiary Grey Character', 'This role is a step or two above that of what would be categorized as an NPC. Maybe they''re a character that has lasted throughout a series, it''s just a character far in the background, who has helped or hindered your journey in little ways here and there. This is just really a character that is doing things for their own ends, and in their eyes, you''re probably inconsequential.')




INSERT Series (SeriesName, DebutDate)
VALUES ('Team Fortress', '04-07-1999'), ('The Legend of Zelda', '02-21-1986'), ('Spyro', '09-09-1998'), ('Fallout', '09-30-1997'), ('Mario', '07-09-1981'), 
('Doom', '12-10-1993'), ('The Elder Scrolls', '03-25-1994'), ('The Witcher', '10-26-2007'), ('Warcraft', '11-23-1994'),
('Kirby', '04-27-1992'), ('Donkey Kong', '07-09-1981'), ('Metroid', '08-06-1986'), ('Pokemon', '02-27-1996'), 
('Sonic The Hedgehog', '06-23-1991'), ('Diablo', '12-31-1996')


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
VALUES ('Demoman', 'Tavish', 'Finnegan', 'DeGroot', 1, 1, 7, 41, 'One of the Defensive classes of Team Fortress 2, Tavish is a master of explosives hailing from the Scottish Highlands. He has described himself as a black, Scottish cyclops, due to having lost his eye as a child... and being black... and from Scotland. His blood is also largely alcoholic, due to his copious consumption of alcohol.')

INSERT Characters ( CharTitle, CharFirstName, SeriesID, TitleID, RoleID, Age, Notes)
VALUES ('Heavy', 'Mikhael', 1, 1, 7, 57, 'One of the Defensive classes of Team Fortress 2, Mikhael (or "Misha" by his family, and "Heavy" by... everyone else) is a tank of a man from the coldest regions of Russia. His massive minigun, Sasha, mows down his enemies as he holds the objective, laughing at their puny attempts to capture it.')

INSERT Characters ( CharTitle, CharFirstName, CharLastName, SeriesID, TitleID, RoleID, Age, Notes)
VALUES ('Engineer', 'Dell', 'Conagher', 1, 1, 7, 35, 'One of the Defensive classes of Team Fortress 2, Dell is a soft-spoken boy from good ol' + '' + ' Texas. He can create an array of buildings to assist his team with their battles, or to mow down any enemy foolish enough to walk in its sights.')

INSERT Characters ( CharTitle, CharLastName, SeriesID, TitleID, RoleID, Age, Notes)
VALUES ('Medic', 'Ludwig', 1, 1, 7, 50, 'One of the Support classes of Team Fortress 2, Dr. Ludwig (who is really just known as the Medic) is an interesting man; it seems that he wants to keep his team alive and well, but with how he acts, you could say the Hippocratic Oath is really more of a Hippocratic Suggestion. He has a morbid fascination with the limits of the insides of humans, and his ingenuity knows no bounds.')

INSERT Characters ( CharTitle, CharLastName, SeriesID, TitleID, RoleID, Age, Notes)
VALUES ('Sniper', 'Mundy', 1, 1, 7, 42,'One of the Support classes of Team Fortress 2, Mr. Mundy, while initially seemingly Australian, is actually from New Zealand. Much to his adoptive parents disapproval, he snipes down his targets with impeccable accuracy and a firm set of standards.')

INSERT Characters ( CharTitle, SeriesID, TitleID, RoleID, Notes)
VALUES ('Spy', 1, 1, 7, 'One of the Support classes of Team Fortress 2, the Spy is mystery-incarnate. No one knows exactly where he is from or who he is. He sneaks around like a specter, and just when you least expect it, you might find a knife lodged into your spinal column.')







INSERT Worlds (WorldName, SeriesID)
VALUES ('Earth', 1), ('Nirn', 7)




INSERT Environments (Environment)
VALUES ('Tropical'),('Jungle'),('Industrial'),('Ruins'),('Farmland'),('Alpine'),('Desert'),('Snowy'),('Halloween'),
('Construction'),('Egyptian'),('Spytech'),('City'),('Maritime'),('Brewery'),('Tundra'), ('Volcanic'), ('Metropolis'),
('Village'), ('Traditional Japanese'), ('Space')



INSERT Locations (LocationName, SeriesID, TitleID, WorldID, [Population], Notes)
VALUES ('Banana Bay', 1, 1, 1, NULL, 'A community-created Payload Race map introduced in the October 20, 2017 patch.')
, ('Brazil', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the October 20, 2017 patch.')
,('Enclosure', 1, 1, 1,   NULL, 'A community-created Payload map introduced in the October 20, 2017 patch.')
,('Lazarus', 1, 1, 1,   NULL, 'A community-created King of the Hill map introduced in the October 20, 2017 patch.')
,('Mercenary Park', 1, 1, 1, NULL, 'An official Attack/Defend map created by Valve. It was introduced in the October 20, 2017 patch.')
,('Mossrock', 1, 1, 1, NULL, 'A community-created Attack/Defend map introduced in the October 20, 2017 patch.')
,('2Fort', 1, 1, 1, NULL, 'An official Capture the Flag map that was shipped with the release of Team Fortress 2.')
,('2Fort Invasion', 1, 1, 1, NULL, 'A variant of the Capture the Flag map, 2Fort, introduced in the October 6, 2015 patch.')
,('Double Cross', 1, 1, 1,   NULL, 'An official Capture the Flag map created by Valve, introduced in the December 17, 2009 patch.')
,('Landfall', 1, 1, 1, NULL, 'A community-created Capture the Flag map introduced in the December 17, 2015 patch..')
,('Sawmill', 1, 1, 1, NULL, 'An official Capture the Flag / King of the Hill / Arena map created by Valve. The former two modes were introduced in the August 13, 2009 patch, while the latter mode was introduced in the May 21, 2009 patch.')
,('Turbine', 1, 1, 1, NULL, 'A community-created Capture the Flag map introduced in the June 19, 2008 patch.')
,('Well', 1, 1, 1, NULL, 'An official Control Point / Capture the Flag / Arena map created by Valve. The former mode was released with Team Fortress 2, while CTF was released in the January 25, 2008 patch, and the latter was released in the August 19, 2008 patch.')
,('5Gorge', 1, 1, 1, NULL, 'An official Control Point map created by Valve in the January 19, 2011 patch.')
,('Badlands', 1, 1, 1, NULL, 'An official Control Point / King of the Hill / Arena map created by Valve. The Control point variant was released in the February 14, 2008 patch, the Arena variant was released in the August 19, 2008 patch, and the King of the Hill variant was released in the April 14, 2011 patch.')
,('Coldfront', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the July 8, 2010 patch.')
,('Fastlane', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the June 19, 2008 patch.')
,('Foundry', 1, 1, 1, NULL, 'An official Control Point / Mannpower map created by Valve. The Control Point variant was introduced in the December 15, 2011 patch, while the Mannpower variant was introduced in the December 22, 2014 patch.')
,('Freight', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the April 28, 2010 patch.')
,('Granary', 1, 1, 1, NULL, 'An official Control Point / Arena map created by Valve. The Control point variant was shipped with the release of Team Fortress 2, while the Arena variant was released in the August 19, 2008 patch.')
,('Gullywash', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the October 13, 2011 patch.')
,('Metalworks', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the July 7, 2016 patch.')
,('Powerhouse', 1, 1, 1, NULL, 'An official Control Point map created by Valve in the July 2, 2015 patch.')
,('Process', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the July 10, 2013 patch.')
,('Sinshine', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the October 28, 2015 patch.')
,('Snakewater', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the November 21, 2013 patch.')
,('Sunshine', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the July 7, 2016 patch.')
,('Vanguard', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the December 17, 2015 patch.')
,('Yukon', 1, 1, 1, NULL, 'A community-created Control Point map introduced in the August 13, 2009 patch.')
,('Egypt', 1, 1, 1, NULL, 'A community-created Attack/Defend map introduced in the February 24, 2009 patch.')
,('Gorge', 1, 1, 1,   NULL, 'An official Attack/Defend / Mannpower map created by Valve. The Attack/Defend variant was introduced in the December 17, 2009 patch, while the Mannpower variant was introduced in the December 22, 2014 patch.')
,('Gorge Event', 1, 1, 1, NULL, 'A community-created Attack/Defend map introduced in the October 28, 2015 patch.')
,('Gravel Pit', 1, 1, 1, NULL, 'An official Attack/Defend map that was shipped with the release of Team Fortress 2.')
,('Junction', 1, 1, 1, NULL, 'A community-created Attack/Defend map introduced in the February 24, 2009 patch.')
,('Mann Manor', 1, 1, 1, NULL, 'An Attack/Defend map that was created by both Valve and several community members. It was introduced in the October 27, 2010 patch.')
,('Mountain Lab', 1, 1, 1, NULL, 'An Attack/Defend map that was created by both Valve and several community members. It was introduced in the October 27, 2010 patch.')
,('Snowplow', 1, 1, 1, NULL, 'A community-created Attack/Defend map introduced in the July 2, 2015 patch. It works slightly different from other Attack/Defend maps, as the timer for the attackers is measured by damage a train that they are guiding has received.')
,('Steel', 1, 1, 1, NULL, 'A community-created Attack/Defend map introduced in the August 19, 2008 patch. It works slightly different from the other Attack/Defend maps, as the final control point for the attackers is available from the beginning, but is harder to capture the more points that remain under the control of the defending team.')
,('DeGroot Keep', 1, 1, 1, NULL, 'An official Attack/Defend map created by Valve in the December 17, 2010 patch. This is the only map that supports Medieval mode, which limits the items available, mainly to just melee weapons.')
,('Standin', 1, 1, 1, NULL, 'A community-created Control Point map that follows a special set of rules known as "Domination".  It was introduced in the July 10, 2013 patch.')
,('Hydro', 1, 1, 1, NULL, 'An official map that was shipped with the release of Team Fortress 2. Its game type is unique only to itself, known as "Territorial Control", which is similar to a Control Point map.')
,('Badwater Basin', 1, 1, 1, NULL, 'An official Payload map created by Valve in the August 19, 2008 patch.')
,('Barnblitz', 1, 1, 1, NULL, 'An official Payload map created by Valve in the June 23, 2011 patch.')
,('Borneo', 1, 1, 1, NULL, 'A community-created Payload map introduced in the July 2, 2015 patch.')
,('Brimstone', 1, 1, 1, NULL, 'A community-created Payload map introduced in the October 21, 2016 patch.')
,('Cactus Canyon', 1, 1, 1, NULL, 'An official Payload map created by Valve in the July 8, 2014 patch.')
,('Frontier', 1, 1, 1, NULL, 'A community-created Payload map introduced in the February 24, 2011 patch.')
,('Gold Rush', 1, 1, 1, NULL, 'An official Payload map created by Valve in the April 29, 2008 patch.')
,('Hellstone', 1, 1, 1, NULL, 'A community-created Payload map introduced in the October 28, 2015 patch.')
,('Hoodoo', 1, 1, 1, NULL, 'A community-created Payload map introduced in the May 21, 2009 patch.')
,('Snowycoast', 1, 1, 1, NULL, 'A community-created Payload map introduced in the December 17, 2015 patch.')
,('Swiftwater', 1, 1, 1, NULL, 'A community-created Payload map introduced in the July 7, 2016 patch.')
,('Thunder Mountain', 1, 1, 1, NULL, 'An official Payload / Mannpower map created by Valve. The Payload variant was introduced in the July 8, 2010 patch, while the Mannpower variant was introduced in the March 12, 2015 patch.')
,('Upward', 1, 1, 1, NULL, 'An official Payload map created by Valve in the July 8, 2010 patch.')
,('Helltower', 1, 1, 1, NULL, 'An official Payload Race map created by Valve in the October 29, 2013 patch.')
,('Hightower', 1, 1, 1, NULL, 'An official Payload Race map created by Valve in the July 8, 2010 patch.')
,('Nightfall', 1, 1, 1, NULL, 'A community-created Payload Race map introduced in the February 24, 2011 patch.')
,('Pipeline', 1, 1, 1, NULL, 'An official Payload Race map created by Valve in the May 21, 2009 patch.')
,('Byre', 1, 1, 1, NULL, 'A community-created Arena map introduced in the October 6, 2015 patch.')
,('Lumberyard', 1, 1, 1, NULL, 'An official Arena map created by Valve in the August 19, 2008 patch.')
,('Nucleus', 1, 1, 1, NULL, 'An official Arena / King of the Hill map created by Valve. The Arena variant was introduced in the May 21, 2009 patch, while the King of the Hill variant was introduced in the August 13, 2009 patch.')
,('Offblast', 1, 1, 1, NULL, 'A community-created Arena map introduced in the August 13, 2009 patch.')
,('Ravine', 1, 1, 1, NULL, 'An official Arena map created by Valve in the August 19, 2008 patch.')
,('Watchtower', 1, 1, 1, NULL, 'A community-created Arena map introduced in the February 24, 2009 patch.')
,('Eyeaduct', 1, 1, 1, NULL, 'An official King of the Hill map created by Valve in the October 27, 2011 patch.')
,('Ghost Fort', 1, 1, 1, NULL, 'An official King of the Hill map created by Valve in the October 26, 2012 patch.')
,('Harvest', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the October 29, 2009 patch.')
,('Harvest Event', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the October 29, 2009 patch.')
,('Highpass', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the December 17, 2015 patch.')
,('Kong King', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the August 10, 2012 patch.')
,('Lakeside', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the February 24, 2011 patch.')
,('Maple Ridge Event', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the October 21, 2016 patch.')
,('Moonshine Event', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the October 28, 2015 patch.')
,('Probed', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the October 6, 2015 patch.')
,('Suijin', 1, 1, 1, NULL, 'A community-created King of the Hill map introduced in the July 2, 2015 patch.')
,('Viaduct', 1, 1, 1, NULL, 'An official King of the Hill map created by Valve in the August 13, 2009 patch.')
,('Carnival of Carnage', 1, 1, 1, NULL, 'An official Special Delivery map created by Valve in the October 29, 2014 patch.')
,('Doomsday', 1, 1, 1, NULL, 'An official Special Delivery map created by Valve in the June 27, 2012 patch.')
,('Dustbowl (Training)', 1, 1, 1, NULL, 'A special variant of Dustbowl created by Valve in the June 10, 2010 patch. It was created to introduce new players to the mechanics of Team Fortress 2 in a very enclosed environment.')
,('Target', 1, 1, 1, NULL, 'A training map created by Valve in the June 10, 2010 patch. It is essentially a shooting range.')
,('Bigrock', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the December 20, 2012 patch.')
,('Coal Town', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the August 15, 2012 patch.')
,('Decoy', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the August 15, 2012 patch.')
,('Ghost Town', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the October 26, 2012 patch.')
,('Mannhattan', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the November 21, 2013 patch.')
,('Mannworks', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the August 15, 2012 patch.')
,('Rottenburg', 1, 1, 1, NULL, 'An official Mann Vs. Machine map created by Valve in the November 21, 2013 patch.')
,('Asteroid', 1, 1, 1, NULL, 'A special map created by Valve in the July 8, 2014 patch. It used a unique gamemode called "Robot Destruction", however this map never left beta.')
,('Hellfire', 1, 1, 1, NULL, 'An official Mannpower map created by Valve in the October 28, 2015 patch.')
,('Brickyard', 1, 1, 1, NULL, 'A PASS Time map that was created by both Valve and two other studios: Bad Robot and Escalation Studios. It was introduced in the August 18, 2015 patch.')
,('District', 1, 1, 1, NULL, 'A PASS Time map that was created by both Valve and two other studios: Bad Robot and Escalation Studios. It was introduced in the July 7, 2016 patch.')
,('Timberlodge', 1, 1, 1, NULL, 'A PASS Time map that was created by both Valve and two other studios: Bad Robot and Escalation Studios. It was introduced in the November 25, 2015 patch.')
,('Pit of Death', 1, 1, 1, NULL, 'A community-created Player Destruction map introduced in the October 21, 2016 patch.')
,('Watergate', 1, 1, 1, NULL, 'A community-created Player Destruction map introduced in the October 6, 2015 patch.')


INSERT LocationEnvironments
VALUES (1, 1), (1, 2), (2, 2), (3, 2), (3, 3), (4, 2), (4, 3), (5, 2), (5, 4), (6, 2), (7, 5), (8, 5), (9, 3), 
(9, 6), (10, 6), (11, 6), (12, 3), (13, 3), (14, 6), (15, 7), (16, 6), (16, 8), (17, 7), (18, 3), (19, 7), 
(20, 5), (21, 7), (22, 3), (23, 3), (24, 3), (24, 6), (25, 9), (26, 6), (27, 6), (28, 10), (29, 6), (30, 11), 
(31, 6), (32, 9), (33, 3), (34, 12), (35, 9), (36, 6), (37, 6), (37, 8), (38, 3), (39, 6), (40, 6), (41, 3), (42, 7), 
(43, 6), (43, 8), (44, 2), (45, 9), (46, 7), (47, 6), (48, 7), (49, 9), (50, 7), (51, 8), (52, 6), (53, 6), (54, 7), 
(55, 9), (56, 7), (57, 6), (58, 3), (59, 5), (60, 6), (61, 12), (62, 3), (62, 7), (63, 7), (64, 6), (65, 9), (66, 9), (67, 5), (68, 9), (69, 3), 
(69, 7), (70, 13), (71, 11), (72, 9), (73, 9), (74, 5), (75, 6), (75, 20), (76, 6), (76, 8), (77, 9), (78, 7), (79, 7), (80, 3), (81, 7), 
(82, 7), (83, 7), (84, 9), (85, 3), (86, 6), (87, 6), (87, 19), (88, 21), (89, 7), (89, 17), (90, 3), (91, 13), (92, 6), (93, 9), (94, 13), 
(94, 14), (94, 15)

INSERT ObtainMethods
VALUES ('Default'), ('Unlock'), ('Purchase'), ('Punishment'), ('Random Drop'), ('Glitch')


INSERT Weapons
VALUES ('Scattergun', 'Shotgun', '85-105 HP', 1, 1, 1, '10 pellets per shot, 6 shots in one clip, with the maximum number of shots carried at once being 32. 85-105 damage done at point-blank range, which decreases as distance increases.', 'A short shotgun wielded by the Scout in Team Fortress 2. This is the default primary weapon for the class, and every player starts with it.')
,('Force-A-Nature', 'Shotgun', '92-113 HP', 2, 1, 1, 'Compared to the Scattergun, 50% faster firing speed, knockback on the target and shooter, +20% more bullets per shot, -10% damage penalty, and -66% clip size. Ammo reserve is the same size, and entire clip is reloaded at once.', 'A sawed-off shotgun wielded by the Scout in Team Fortress 2. This weapon is unlocked after the player obtains 10 Scout achievements. At point-blank range, this weapon performs better than the Scattergun most of the time, but any farther, and it becomes even less effective, due to the increased bullet spread.')
, ('Shortstop', 'Pistol', '69-72 HP', 5, 1, 1, 'Compared to the Scattergun, around 40% faster firing speed, the entire clip is reloaded at once, 200% damage per pellet, around a 40% smaller weapon spread diameter, alt-fire does a shove if within melee range, each shot has 60% less pellets, and when active, the user receives 20% more knockback from all weapons and the Pyro''s compression blast.', 'A four-barreled derringer-style pistol used by the Scout in Team Fortress 2. This can be unlocked either from random drops or from certain series of crates. This weapon is a bit more effective than other scatterguns at mid range, much more effective at long range, but not as effective at short range.')
, ('Soda Popper', 'Shotgun', '104 HP', 5, 1, 1, 'Compared to the Scattergun, ', '')


INSERT CharacterWeapons
VALUES (1, 1), (2, 1), (3, 1)

--SELECT CharTitle, CONCAT(CharFirstName, ' ', CharMidName, ' ', CharLastName), WeaponName
--FROM Characters C
--INNER JOIN CharacterWeapons CW
--ON CW.CharacterID = C.CharacterID
--INNER JOIN Weapons W
--ON W.WeaponID = CW.WeaponID


---------------------------------------------------INSERTS FOR THE ELDER SCROLLS BEGIN-----------------------------------------------

INSERT Worlds
VALUES ('Nirn', NULL, 7, NULL)

INSERT Locations
VALUES ('Tamriel', 7, NULL, 1, NULL, 'Tamriel is the continent where all events of The Elder Scrolls games have taken place thus far, and is comprised of nine provinces: Cyrodiil, Elsweyr, Valenwood, Black Marsh, Morrowind, Skyrim, Hammerfell, High Rock, and Summerset Isle, each of which has a race that is native to it.'),
('Akavir', 7, NULL, 1, NULL, 'Akavir is a continent far to the east of Tamriel, separated from it by a vast ocean. Not much is known of Akavir, other than several mighty beast races inhabit it.')

INSERT Races
VALUES ('Imperial', 7, NULL, 1, 1, 'Imperials hail from the province of Cyrodiil. They are a race of Men (Humans), comprised of some of the most well-educated, well-spoken, and wealthy people in Tamriel. A lot of their culture has roots in Altmer culture, ranging from their religion, to their language and architecture. They can be differentiated from other races of Men by their relatively less fair complexion compared to the other human races, while also having a lighter skin tone than that of Redguards. Imperials tend to make excellent diplomats, traders, and tacticians. Imperials are split into two ethno-cultural groups: the Nibeneans of the east side of Cyrodiil, and the Colovians of the west side. The Nibeneans build their culture and religion off of ancient customs, and focus a considerable amount on philosophy, magic, and other related fields. The Colovians are a more physical sort, putting more faith in their sword arms and their emperor.'),
('Khajiit', 7, NULL, 1, 1, 'One of the beast races of Tamriel, Khajiit hail from the province of Elsweyr'), 
('Bosmer', 7, NULL, 1, 1, 'Commonly referred to as Wood Elves, the Bosmer are a race of Mer (Elves) that hail from the province of Valenwood. As their colloquial name implies, Bosmer aren''t the most technologically advanced race in Tamriel; rather, they''ve set their civilization in the wilderness, with their major cities being located in giant, walking trees. Bosmer are one of the smallest races of Tamriel, being typically the shortest of all playable races.'), 
('Argonian', 7, NULL, 1, 1, 'One of the beast races of Tamriel, Argonians hail from the province of Black Marsh. '), 
('Dunmer', 7, NULL, 1, 1, 'Commonly referred to as Dark Elves, the Dunmer are a race of Mer (Elves) that hail from the province of Morrowind. Dunmer are quite different from the other races of Tamriel, in that they mainly worshipped Daedra, and their climate, which for the most part was very ashy and alien-like, led their architecture, customs, values, and social norms to be very different from that of other races. Most Dunmer have red, glowing eyes, with their skin typically being gray, and on some occasions, having a bit of a light-blue hue to their skin. Dunmer are pretty average in height, making them larger than Bosmer, but smaller than Altmer.'), 
('Nord', 7, NULL, 1, 1, 'Nords hail from the province of Skyrim. They are a race of Men (Humans) who are known for their prowess as warriors. They are naturally resistant to extreme colds, hence why some refer to them as "Sons of Snow". Nords prize the pursuit of honor and glory, which is why so much of their culture revolves around it, with an additional emphasis on family and local communities. Nords are regarded as being light-skinned and fair-haired, while also being quite imposing in stature. Nords see themselves as outsiders to the rest of the world due to their direct origins from the ancient race, the Atmorans, whom sailed to Tamriel from the frigid continent of Atmora to the north. This feeling of disconnect leads Nords to tend to have a lack of sympathy towards those they conquer. To a traditional Nord, death in battle is honorable, and they welcome it with open arms, believing that in death they will go to Sovngarde, the Nordic afterlife, to live and rejoice with (mostly) just other Nordic warriors for eternity.'), 
('Redguard', 7, NULL, 1, 1, 'Redguards hail from the province of Hammerfell. They are a race of Men (Humans), comprised of some of the finest warriors in Tamriel. They initially resided on the lost continent of Yokuda, but they had to migrate to what is now the province of Hammerfell after Yokuda sank into the sea. They''re ferocious and versatile in combat, which extends to their personalities, making them more effective as scouts or members of small units, as opposed to being foot soldiers in a large group. Of the different races of Men, Redguards tend to have the darkest skin tones, ranging from light brown to a very dark brown, their hair texture ranges from thick and wavy to tightly curled and wiry, and they are quite muscular and sturdy in physique. They are, however, quite average in height. Redguard culture is quite martial, in that every Redguard is trained for combat from an early age. This widespread training has kept Redguards strong, and they still haven''t been assimilated by other forces to this day.'), 
('Breton', 7, NULL, 1, 1, 'Bretons hail from the province of High Rock. They are a race of Men (Humans) that have strong traces of Mer (Elves) in their lineage. Physically, Bretons tend to look a lot more Man than Mer, with pale skin and physically resembling Imperials or Nords, but some Bretons have more of a sharp, frail appearance, like that of elves. Those Bretons also tend to inherit the same arrogance and even perhaps a slight point to their ears. Whichever way the Breton may physically appear, they share a common bond of a strong resistance to magic being used against them, with a great many Bretons becoming very powerful sorcerers. Bretons tend to be very intelligent, willful, and, unlike many of their Mer cousins, are very outgoing. Bretons all tend to share the same culture and language, but many Bretons are politically divided from one another.'), 
('Altmer', 7, NULL, 1, 1, 'Commonly referred to as High Elves, the Altmer are a race of Mer (Elves) that hail from Summerset Isle. Of all of the races of Tamriel, the Altmer are the most gifted when it comes to magic, and are considered by many humans to be arrogant and disdainful towards them, but are also considered (for the most part) to be the most civilized race by both Men and Mer. Altmer are very proud of their heritage, due to being one of the oldest races of Tamriel, and tend to not have children with other races. Altmer are among the tallest of the humanoid races of Nirn, towering over other Mer, and having very few Men that can compare in height. Altmer have a pale gold skin tone, with a slender frame, prominently pointed ears, and almond-shaped eyes that can be amber, green, or a vibrant yellow. Altmer have made some of the very best mages in the history of Tamriel.'), 
('Orsimer', 7, NULL, 1, 1, 'Commonly referred to as Orcs, the Orsimer are a race of Mer (Elves) that were born out of a feud between an Aedric god (Trinimac) and a Daedric Prince (Boethiah). The precursors to the Orsimer worshipped Trinimac, who was devoured by Boethiah; this event corrupted Trinimac, turning him into a new Daedric Prince: Malacath. Trinimac''s followers were physically corrupted from this, and became what the Orsimer are now. Orsimer are heavily muscular, with their skin tone ranging from light green, to dark brown, and they have large, sharp lower teeth that jut out of their mouth. Orcs tend to make excellent adventurers and legionnaires in the Imperial Legion, with a few even finding success as skilled mages. Since they differ so greatly from other races of Mer, Orsimer are typically considered beast-folk instead. Due to a series of events, Orsimer don''t have a province they can call home.'),
('Aedra', 7, NULL, 1, 1, ''),
('Daedra', 7, NULL, 1, 1, '')
--FILL IN THE REST OF THE RACES: Khajiit, Bosmer, Argonian, Aedra, and Daedra.

INSERT Characters
VALUES (NULL, 'Hermaeous', NULL, 'Mora', NULL, 7, NULL, 12, 12, NULL, 'Hermaeous Mora is the Daedric Prince of Knowledge and Secrets. ')

