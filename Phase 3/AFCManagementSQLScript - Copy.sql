USE AFCManagement;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS CLUBSCOMPETITION, LEAGUE, CONTINENTAL;

DROP TABLE IF EXISTS COMPETITION;

DROP TABLE IF EXISTS PRESIDENT, FOOTBALLCLUB, STADIUM, MATCHES, TABLELOG, COMPETITIION, 
LEAGUE, CONTINENTAL, CLUBSCOMPETITON, STORES, MERCHANDISE, TICKETBOOTH, FAN, PAYMENT, 
SPORTINGDIRECTOR, ACCOUNTANT, REPORT, PLAYER, OTHERPLAYER, CLUBPLAYER, PLAYERSTAFF, 
MEDICALSTAFF, TRAININGSTAFF, APPOINTMENT;
SET FOREIGN_KEY_CHECKS = 1;
DROP TABLE IF EXISTS COMPETITION;
show tables;


CREATE TABLE FOOTBALLCLUB(
	ClubID VARCHAR(8) NOT NULL,
	ClubName VARCHAR(40) CHECK (ClubName <> '') DEFAULT 'Manchester United',
	Country VARCHAR(20) DEFAULT 'England' CHECK(Country <> ''),
    FoundingYear INT NOT NULL CHECK (FoundingYear >= 1850 ),
	PRIMARY KEY(ClubID)
);

CREATE TABLE PRESIDENT(
	PresIDNumber VARCHAR(13) NOT NULL,
	Name VARCHAR(20) CHECK (Name <>""),
	Surname VARCHAR(20) CHECK (Surname <> ""),
	CountryOfOrgin VARCHAR(20) DEFAULT 'Unknown',
	DateOfBirth DATE CHECK (DateOfBirth >= '1900-01-01'),
	ClubID VARCHAR(8) NOT NULL,
	PRIMARY KEY(PresIDNumber),
	FOREIGN KEY(ClubID) REFERENCES FOOTBALLCLUB(ClubID) ON DELETE CASCADE
);
CREATE TABLE STADIUM(
	StadiumID VARCHAR(8) NOT NULL,
	ClubID VARCHAR(8) NOT NULL,
	StadiumName VARCHAR(50) DEFAULT 'Unknown',
	StadiumCapacity INT CHECK (StadiumCapacity > 0 AND StadiumCapacity <= 200000),
	Location VARCHAR(30) DEFAULT 'Unknown stadium location',
	PRIMARY KEY(StadiumID),
	FOREIGN KEY(ClubID) REFERENCES FOOTBALLCLUB(ClubID) ON DELETE CASCADE
);
ALTER TABLE STADIUM
MODIFY StadiumName VARCHAR(50) DEFAULT 'Unknown';

CREATE TABLE MATCHES(
	MatchID VARCHAR(8) NOT NULL,
	StadiumID VARCHAR(8) NOT NULL,
	HomeOrAway VARCHAR(4) CHECK (HomeOrAway IN ('Home', 'Away')),
	Result VARCHAR(4) CHECK (Result IN ('Win', 'Lose', 'Draw')),
	Coach VARCHAR(20) DEFAULT 'Coach',
	DateOfMatch DATE CHECK (DateOfMatch >= '2000-01-01'),
	StartTime TIME DEFAULT '15:00:00',
	PRIMARY KEY(MatchID),
	FOREIGN KEY(StadiumID) REFERENCES STADIUM(StadiumID) ON DELETE RESTRICT
);
-- CHECK THIS TABLE

CREATE TABLE COMPETITION(
	CompetitonID VARCHAR(8) NOT NULL,
	Name VARCHAR(20) CHECK (Name <> '') DEFAULT 'Uknown Competition',
	Season VARCHAR(5)  CHECK (Season REGEXP '^[0-9]{2}/[0-9]{2}$'),
	NumberOfTeams INT DEFAULT 0 CHECK (NumberOfTeams = 20 OR NumberOfTeams =36), 
	GoverningBody VARCHAR(15) DEFAULT 'FIFA' CHECK (GoverningBody <> ''),
	CurrentChampions VARCHAR(20) DEFAULT 'Uknown' CHECK (CurrentChampions <> ''),
	LogID VARCHAR(8) NOT NULL,
	PRIMARY KEY(CompetitonID)
);

CREATE TABLE TABLELOG(
	LogID VARCHAR(8) NOT NULL,
	ClubID VARCHAR(8) NOT NULL,
	Season VARCHAR(5) CHECK (Season REGEXP '^[0-9]{2}/[0-9]{2}$') DEFAULT '24/25',
	MatchID VARCHAR(8) NOT NULL,
	CompetitonID VARCHAR(8) NOT NULL,
	Position INT DEFAULT 0 CHECK (Position >= 1 AND Position <= 20),
	PRIMARY KEY(LogID),
	FOREIGN KEY(ClubID) REFERENCES FOOTBALLCLUB(ClubID) ON DELETE CASCADE,
	FOREIGN KEY(MatchID) REFERENCES MATCHES(MatchID) ON DELETE RESTRICT,
	FOREIGN KEY(CompetitonID) REFERENCES COMPETITION(CompetitonID) ON DELETE CASCADE
);

CREATE TABLE LEAGUE(
	CompetitonID VARCHAR(8) NOT NULL,
	TransferWindowStartDate DATE DEFAULT '2025-01-01',
	TransferWindowEndDate DATE DEFAULT '2025-01-30',
	CHECK (TransferWindowEndDate>=TransferWindowStartDate),
	SpendingLimit FLOAT CHECK (SpendingLimit >=0),
	FOREIGN KEY(CompetitonID) REFERENCES COMPETITION(CompetitonID) ON DELETE CASCADE 
	-- SUBTYPE
);
CREATE TABLE CONTINENTAL(
	CompetitonID VARCHAR(8) NOT NULL,
	CountryAssociation VARCHAR(20) DEFAULT 'UEFA' CHECK (CountryAssociation <> ''),
	FinalCountry VARCHAR(20) DEFAULT 'UEFA' CHECK (FinalCountry <> ''),
	FinalStadium VARCHAR(30) DEFAULT 'Uknown stadium' CHECK (FinalStadium <> ''),
	FOREIGN KEY(CompetitonID) REFERENCES COMPETITION(CompetitonID) ON DELETE CASCADE
	-- SUBTYPE
);
CREATE TABLE CLUBSCOMPETITION(
	-- records all the matches a club plays and their position in the table after each match
	CompetitonID VARCHAR(8) NOT NULL,
	ClubID VARCHAR(8) NOT NULL,
	Matches INT DEFAULT 38 CHECK (38<=Matches<=67),
	Ranking INT DEFAULT 20 CHECK (1<=Ranking<=36),
	PRIMARY KEY (CompetitonID, ClubID),
	FOREIGN KEY (CompetitonID) REFERENCES COMPETITION(CompetitonID) ON DELETE CASCADE,
	FOREIGN KEY(ClubID) REFERENCES FOOTBALLCLUB(ClubID) ON DELETE CASCADE
);
CREATE TABLE STORES(
	StoreID VARCHAR(8) NOT NULL,
	StoreNetIncome FLOAT NOT NULL,
	StoreName VARCHAR(20) DEFAULT 'Uknown' CHECK (StoreName <> ''),
	YearEstablished DATE DEFAULT '2000-01-01' CHECK (YearEstablished > '1900-01-01'),
	UnitOfBuilding VARCHAR(2) DEFAULT 'A' CHECK (UnitOfBuilding <> ''),
	Manager VARCHAR(20) DEFAULT 'Uknown Manager' CHECK (Manager <> ''),
	NumberOfStaff INT DEFAULT 10 CHECK (NumberOfStaff >0),
	Month VARCHAR(9) CHECK (Month IN ('January', 'Febuary', 'March','April','May','June','July','August','September','October','November','December')),
	Year INT DEFAULT 2025 CHECK(YEAR>1970),
	StadiumID VARCHAR(8) NOT NULL,
	PRIMARY KEY(StoreID,StoreNetIncome),
	FOREIGN KEY(StadiumID) REFERENCES STADIUM(StadiumID) ON DELETE CASCADE
);
CREATE TABLE MERCHANDISE(
	StoreID VARCHAR(8) NOT NULL,
	StoreNetIncome FLOAT NOT NULL,
	SeasonKits VARCHAR(5)  DEFAULT '20/21' CHECK (SeasonKits REGEXP '^[0-9]{2}/[0-9]{2}$'),
	TypeOfKit VARCHAR(6)   DEFAULT 'Home' CHECK (TypeOfKit IN ('Home','Away','Third Kit')),
	TotalStockAvailable INT DEFAULT 0 CHECK(TotalStockAvailable >=0),
	Price FLOAT DEFAULT 600 CHECK( Price >0),
	-- FOREIGN KEY(StoreID) REFERENCES STORES(StoreID) ON DELETE CASCADE,
	FOREIGN KEY(StoreID,StoreNetIncome) REFERENCES STORES(StoreID,StoreNetIncome) ON DELETE CASCADE
);
CREATE TABLE TICKETBOOTH(
	StoreID VARCHAR(8) NOT NULL,
	StoreNetIncome FLOAT NOT NULL DEFAULT 0,
	TypeOfTicket VARCHAR(10) DEFAULT 'Standard' CHECK( TypeOfTicket IN('Standard','Premium','Deluxe')),
	SeatNumber INT DEFAULT 0 CHECK (SeatNumber <150000),
	Price FLOAT DEFAULT 60 CHECK (Price>0),
	-- FOREIGN KEY(StoreID) REFERENCES STORES(StoreID) ON DELETE CASCADE,
	FOREIGN KEY(StoreID,StoreNetIncome) REFERENCES STORES(StoreID,StoreNetIncome) ON DELETE CASCADE
);
CREATE TABLE FAN(
	IDNumber VARCHAR(13) NOT NULL,
	Name VARCHAR(20) DEFAULT 'Name not found' CHECK (Name <> ''),
	Surname VARCHAR(20) DEFAULT 'Surname not found' CHECK (Surname <> ''),
	DateOfBirth DATE DEFAULT '2000-01-01',
	PRIMARY KEY(IDNumber)
);

DELIMITER $$

CREATE TRIGGER validate_date_of_birth
BEFORE INSERT ON FAN
FOR EACH ROW
BEGIN
    IF NEW.DateOfBirth >= CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Date of birth must be before the current date';
    END IF;
END $$

DELIMITER ;

CREATE TABLE PAYMENT(
	PaymentNumber VARCHAR(8) NOT NULL,
	Amount FLOAT DEFAULT 60 CHECK (Amount>0),
	DateOfPayment DATE DEFAULT '2000-01-01',
	TimeOfPayment TIME DEFAULT '00:00:00',
	Product VARCHAR(80) DEFAULT 'Uknown Product',
	IDNumber VARCHAR(13) NOT NULL,
	StoreID VARCHAR(8) NOT NULL,
	PRIMARY KEY(PaymentNumber),
	FOREIGN KEY(IDNumber) REFERENCES FAN(IDNumber) ON DELETE CASCADE,
	FOREIGN KEY(StoreID) REFERENCES STORES(StoreID) ON DELETE CASCADE
);
CREATE TABLE SPORTINGDIRECTOR(
	SportID VARCHAR(8) NOT NULL,
	SportNetSpend FLOAT NOT NULL,
	Name VARCHAR(20) DEFAULT 'Name' CHECK(Name <>''),
	Surname VARCHAR(20) DEFAULT 'Surname not found' CHECK(Surname <>''),
	LastClub VARCHAR(20) DEFAULT 'N/A',
	TransferBudget FLOAT DEFAULT 0 CHECK (TransferBudget >=0),
	Year INT DEFAULT 2000,
	Month VARCHAR(9) CHECK (Month IN ('January', 'Febuary', 'March','April','May','June','July','August','September','October','November','December')),
	PRIMARY KEY(SportID,SportNetSpend)
);
DESCRIBE SPORTINGDIRECTOR;
ALTER TABLE SPORTINGDIRECTOR
DROP COLUMN PIDNumber;
ADD ClubID VARCHAR(8) NOT NULL;

ALTER TABLE SPORTINGDIRECTOR
ADD PIDNumber VARCHAR(8) NOT NULL;

--REMEMBER THIS
ALTER TABLE SPORTINGDIRECTOR
ADD CONSTRAINT PIDNumber
FOREIGN KEY (PIDNumber) REFERENCES PLAYER(PIDNumber) ON DELETE CASCADE;

ALTER TABLE SPORTINGDIRECTOR
ADD CONSTRAINT ClubID
FOREIGN KEY (ClubID) REFERENCES FOOTBALLCLUB(ClubID) ON DELETE CASCADE;

DESCRIBE SPORTINGDIRECTOR;

CREATE TABLE ACCOUNTANT(
	AccID VARCHAR(8) NOT NULL,
	TeamMarketValue FLOAT DEFAULT 10 CHECK(TeamMarketValue >0),
	Name VARCHAR(20) DEFAULT 'Name not found' CHECK (Name<>''),
	Surname VARCHAR(20)  DEFAULT 'Surname not found' CHECK (Surname<>''),
	Age INT DEFAULT 18 CHECK(Age>=18),
	Month VARCHAR(9) CHECK (Month IN ('January', 'Febuary', 'March','April','May','June','July','August','September','October','November','December')),
	Year INT DEFAULT 2000,
	NetProfit FLOAT DEFAULT 0 CHECK(NetProfit>=0),
	StoreID VARCHAR(8) NOT NULL,
	SportID VARCHAR(8) NOT NULL,
	PRIMARY KEY(AccID),
	FOREIGN KEY(StoreID) REFERENCES STORES(StoreID) ON DELETE RESTRICT,
	FOREIGN KEY(SportID) REFERENCES SPORTINGDIRECTOR(SportID) ON DELETE RESTRICT
);
CREATE TABLE REPORT(
	AccID VARCHAR(8) NOT NULL,
	PresIDNumber VARCHAR(13) NOT NULL,
	DateOfReport DATE NOT NULL,
	Amount FLOAT CHECK (Amount <> 0),
	PRIMARY KEY(AccID,PresIDNumber,DateOfReport),
	FOREIGN KEY(AccID) REFERENCES ACCOUNTANT(AccID) ON DELETE CASCADE,
	FOREIGN KEY(PresIDNumber) REFERENCES PRESIDENT(PresIDNumber) ON DELETE CASCADE
);

DELIMITER $$

CREATE TRIGGER validate_DateOfReport
BEFORE INSERT ON REPORT
FOR EACH ROW
BEGIN
    IF NEW.DateOfReport > CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Report date cannot be in the future';
    END IF;
END $$

DELIMITER ;

CREATE TABLE PLAYER(
	PIDNumber VARCHAR(8) NOT NULL,
	Name VARCHAR(20) DEFAULT 'Name not found' CHECK (Name<>''),
	Surname VARCHAR(20)  DEFAULT 'Surname not found' CHECK (Surname<>''),
	Age INT DEFAULT 18 CHECK(Age>=16),
	Position VARCHAR(30) DEFAULT 'Goalkeeper' CHECK(Position IN('Attacker', 'Midfielder','Defender','Goalkeeper')),
	MarketValue FLOAT DEFAULT 0 CHECK(MarketValue>=0),
	PRIMARY KEY(PIDNumber)
);

CREATE TABLE OTHERPLAYER(
	PIDNumber VARCHAR(8) NOT NULL,
	Name VARCHAR(20)DEFAULT 'Name not found' CHECK (Name<>''),
	LastClub VARCHAR(20) DEFAULT 'N/A' CHECK(LastClub <> ''),
	ReleaseClause FLOAT DEFAULT 0 CHECK(ReleaseClause >=0),
	Manager VARCHAR(20) NOT NULL,
	FOREIGN KEY(PIDNumber) REFERENCES PLAYER(PIDNumber) ON DELETE CASCADE
);
CREATE TABLE CLUBPLAYER(
	PIDNumber VARCHAR(8) NOT NULL,
	Name VARCHAR(20) DEFAULT 'Name not found' CHECK (Name<>''),
	ShirtNumber INT DEFAULT 7 CHECK (0<ShirtNumber<=99),
	ClubID VARCHAR(8) NOT NULL,
	PRIMARY KEY(PIDNumber),
	FOREIGN KEY(ClubID) REFERENCES FOOTBALLCLUB(ClubID) ON DELETE CASCADE,
	FOREIGN KEY(PIDNumber) REFERENCES PLAYER(PIDNumber) ON DELETE CASCADE
);
CREATE TABLE PLAYERSTAFF(
	StaffNumber VARCHAR(8) NOT NULL,
	Name VARCHAR(20) DEFAULT 'Name not found' CHECK (Name<>''),
	Surname VARCHAR(20) DEFAULT 'Surname not found' CHECK (Surname<>''),
	Age INT DEFAULT 18 CHECK(Age>=18),
	PRIMARY KEY(StaffNumber)
);
CREATE TABLE MEDICALSTAFF(
	StaffNumber VARCHAR(8) NOT NULL,
	Qualification VARCHAR(60) DEFAULT 'Unkown Qualification' CHECK( Qualification <>''),
	Practice VARCHAR(30)  DEFAULT 'Football club medical staff' CHECK( Practice <>''),
	FOREIGN KEY(StaffNumber) REFERENCES PLAYERSTAFF(StaffNumber) ON DELETE CASCADE
);
CREATE TABLE TRAININGSTAFF(
	StaffNumber VARCHAR(8) NOT NULL,
	Position VARCHAR(30) DEFAULT 'No distinct position training' CHECK(Position IN('Attacker', 'Midfielder','Defender','Goalkeeper')),
	CoachingDegree VARCHAR(30) DEFAULT 'Standard Degree' CHECK(CoachingDegree<>''),
	FOREIGN KEY(StaffNumber) REFERENCES PLAYERSTAFF(StaffNumber) ON DELETE CASCADE
);
CREATE TABLE APPOINTMENT(
	DateOfAppointment DATE NOT NULL,
	StaffNumber VARCHAR(8) NOT NULL,
	PIDNumber VARCHAR(8) NOT NULL,
	Description VARCHAR(50) DEFAULT 'Check up' CHECK(Description IN('Routine Medical Checkup','Pre-Season Medical Assessment','Post-Match Recovery Assessment','Blood Tests','Injury Diagnosis','Physiotherapy Session','Post Injury Fitness Test')),
	PRIMARY KEY(DateOfAppointment,StaffNumber,PIDNumber),
	FOREIGN KEY(StaffNumber) REFERENCES PLAYERSTAFF(StaffNumber) ON DELETE RESTRICT,
	FOREIGN KEY(PIDNumber) REFERENCES PLAYER(PIDNumber) ON DELETE RESTRICT 
);
show tables;


-- we set a new delimiter that acts as the end of the statement. This way the semi colon becomes a character we can use in the coding of our procedure
DELIMITER $$

CREATE PROCEDURE AddNewPlayerWithClubInfo(IN playerID VARCHAR(8), IN playerName VARCHAR(20), IN playerSurname VARCHAR(20), IN playerAge INT, IN playerPosition VARCHAR(30),IN marketValue FLOAT,IN shirtNumber INT,IN clubID VARCHAR(8))
BEGIN
    INSERT INTO PLAYER (PIDNumber, Name, Surname, Age, Position, MarketValue)
    VALUES (playerID, playerName, playerSurname, playerAge, playerPosition, marketValue);

    INSERT INTO CLUBPLAYER (PIDNumber, ShirtNumber, ClubID)
    VALUES (playerID, shirtNumber, clubID);
END $$
-- this tells us that this is the end of $$ being used as the end of the statement

DELIMITER ;
-- now the semicolon becomes our normal delimiter again

CALL AddNewPlayerWithClubInfo('PLR001', 'Cristiano', 'Ronaldo', 39, 'Attacker', 150000000, 7, 'MUN');

DELIMITER $$

CREATE PROCEDURE AddNewClub(IN CID VARCHAR(8),IN CName VARCHAR(40), IN Cnt VARCHAR(20), IN FoundYear INT )
BEGIN 
	INSERT INTO FOOTBALLCLUB (ClubID, ClubName,Country,FoundingYear)
	VALUES (CID,CName,Cnt,FoundYear);
END $$

DELIMITER ;

CALL AddNewClub('MUN','Manchester United','England',1878);
SELECT * FROM FOOTBALLCLUB;

INSERT INTO PRESIDENT
TRUNCATE TABLE PRESIDENT;
TRUNCATE TABLE FOOTBALLCLUB;
TRUNCATE TABLE PLAYER;
SELECT * FROM CLUBPLAYER;
SELECT * FROM FOOTBALLCLUB;


DELIMITER $$

CREATE PROCEDURE UpdateStoreIncomeAndReport(
    IN storeID VARCHAR(8),
    IN newIncome FLOAT,
    IN accID VARCHAR(8),
    IN presID VARCHAR(13),
    IN reportDate DATE,
    IN reportAmount FLOAT
)
BEGIN
    -- Update the income for a store (across all records for simplicity)
    UPDATE STORES
    SET StoreNetIncome = newIncome
    WHERE StoreID = storeID;

    -- Insert a new report for the accountant to the president
    INSERT INTO REPORT (AccID, PresIDNumber, DateOfReport, Amount)
    VALUES (accID, presID, reportDate, reportAmount);
END $$

DELIMITER ;


SELECT * FROM PRESIDENT;
DESCRIBE PRESIDENT;


DROP PROCEDURE IF EXISTS addNewPresident;


DELIMITER $$

CREATE PROCEDURE addNewPresident(IN PID VARCHAR(13),IN name VARCHAR(20),IN sname VARCHAR(20),IN coo VARCHAR(20),IN dob DATE,IN cid VARCHAR(8))
BEGIN
	INSERT INTO PRESIDENT(PresIDNumber, Name, Surname, CountryOfOrgin, DateOfBirth, ClubID)
	VALUES(PID, name, sname, coo, dob, cid);
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS InsertClubPlayer;

DELIMITER $$
CREATE PROCEDURE InsertClubPlayer(IN pid VARCHAR(8),IN pname VARCHAR(20),IN psurname VARCHAR(20),IN page INT,IN pposition VARCHAR(30),IN pvalue FLOAT,IN shirtNum INT,IN clubID VARCHAR(8))
BEGIN
    INSERT INTO PLAYER(PIDNumber, Name, Surname, Age, Position, MarketValue)
    VALUES (pid, pname, psurname, page, pposition, pvalue);

    INSERT INTO CLUBPLAYER(PIDNumber,Name, ShirtNumber, ClubID)
    VALUES (pid,pname, shirtNum, clubID);
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS InsertOtherPlayer;
DELIMITER $$
CREATE PROCEDURE InsertOtherPlayer(IN pid VARCHAR(8),IN pname VARCHAR(20),IN psurname VARCHAR(20),IN page INT,IN pposition VARCHAR(30),IN pvalue FLOAT,IN lastClub VARCHAR(20),IN releaseClause FLOAT,IN ManagerIN VARCHAR(20))
BEGIN
    INSERT INTO PLAYER(PIDNumber, Name, Surname, Age, Position, MarketValue)
    VALUES (pid, pname, psurname, page, pposition, pvalue);

    INSERT INTO OTHERPLAYER(PIDNumber,Name, LastClub, ReleaseClause, Manager)
    VALUES (pid,pname,lastClub, releaseClause, ManagerIN);
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS InsertSportingDirector; 
DELIMITER $$
CREATE PROCEDURE InsertSportingDirector(IN in_SportID VARCHAR(8),IN in_SportNetSpend FLOAT,IN in_Name VARCHAR(20),IN in_Surname VARCHAR(20),IN in_TransferBudget FLOAT,IN in_Year INT,IN in_Month VARCHAR(9),IN CID VARCHAR(8), IN _PIDN VARCHAR(8))
BEGIN
    INSERT INTO SPORTINGDIRECTOR (SportID, SportNetSpend, Name, Surname, TransferBudget, Year, Month, ClubID,PIDNumber) 
    VALUES (in_SportID, in_SportNetSpend, in_Name, in_Surname, in_TransferBudget, in_Year, in_Month,CID,_PIDN);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE UpdateClubPlayer(IN pid VARCHAR(8),IN pname VARCHAR(20),IN psurname VARCHAR(20),IN page INT,IN pposition VARCHAR(30),IN pvalue FLOAT,IN shirtNum INT,IN clubID VARCHAR(8))
BEGIN
    -- Update PLAYER table
    UPDATE PLAYER
    SET Name = pname,Surname = psurname,Age = page,Position = pposition,MarketValue = pvalue
    WHERE PIDNumber = pid;

    -- Update CLUBPLAYER table
    UPDATE CLUBPLAYER
    SET ShirtNumber = shirtNum,ClubID = clubID
    WHERE PIDNumber = pid;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE UpdateOtherPlayer(IN p_pid VARCHAR(8),IN p_name VARCHAR(20),IN p_surname VARCHAR(20),IN p_age INT,IN p_position VARCHAR(30),IN p_marketValue FLOAT,IN p_lastClub VARCHAR(20),IN p_releaseClause FLOAT,IN p_manager VARCHAR(20))
BEGIN
    UPDATE PLAYER
    SET Name = p_name, Surname = p_surname, Age = p_age, Position = p_position, MarketValue = p_marketValue
    WHERE PIDNumber = p_pid;

    UPDATE OTHERPLAYER
    SET Name = p_name, LastClub = p_lastClub, ReleaseClause = p_releaseClause, Manager = p_manager
    WHERE PIDNumber = p_pid;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS InsertStadium;
DELIMITER $$
CREATE PROCEDURE InsertStadium(IN in_StadiumID VARCHAR(8),IN in_ClubID VARCHAR(8),IN in_StadiumName VARCHAR(30),IN in_StadiumCapacity INT, IN in_Location VARCHAR(30))
BEGIN
    INSERT INTO STADIUM (StadiumID, ClubID, StadiumName, StadiumCapacity, Location) 
    VALUES (in_StadiumID, in_ClubID, in_StadiumName, in_StadiumCapacity, in_Location);
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE DeleteStadium(IN in_StadiumID VARCHAR(8))
BEGIN
    DELETE FROM STADIUM WHERE StadiumID = in_StadiumID;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE UpdateStadium(IN in_StadiumID VARCHAR(8),IN in_ClubID VARCHAR(8),IN in_StadiumName VARCHAR(50),IN in_StadiumCapacity INT ,IN in_Location VARCHAR(50))
BEGIN
    UPDATE STADIUM
    SET ClubID = in_ClubID,StadiumName = in_StadiumName,StadiumCapacity = in_StadiumCapacity,Location = in_Location
    WHERE StadiumID = in_StadiumID;
END $$
DELIMITER ;

--FINISH THIS LATER
DELIMITER $$
CREATE PROCEDURE UpdateStore(IN StoreID VARCHAR(8), IN StoreNetIncome FLOAT, IN StoreName VARCHAR(20),IN YearEstablished DATE, IN UnitOfBuilding VARCHAR(2), IN Manager VARCHAR(20), IN NumberOfStaff INT, IN Month VARCHAR(9), IN Year INT, IN StadiumID VARCHAR(8) )
BEGIN
    UPDATE STADIUM
    SET ClubID = in_ClubID,StadiumName = in_StadiumName,StadiumCapacity = in_StadiumCapacity,Location = in_Location
    WHERE StadiumID = in_StadiumID;
END $$
DELIMITER ;


CREATE TABLE STORES(
	StoreID VARCHAR(8) NOT NULL,
	StoreNetIncome FLOAT NOT NULL,
	StoreName VARCHAR(20) DEFAULT 'Uknown' CHECK (StoreName <> ''),
	YearEstablished DATE DEFAULT '2000-01-01' CHECK (YearEstablished > '1900-01-01'),
	UnitOfBuilding VARCHAR(2) DEFAULT 'A' CHECK (UnitOfBuilding <> ''),
	Manager VARCHAR(20) DEFAULT 'Uknown Manager' CHECK (Manager <> ''),
	NumberOfStaff INT DEFAULT 10 CHECK (NumberOfStaff >0),
	Month VARCHAR(9) CHECK (Month IN ('January', 'Febuary', 'March','April','May','June','July','August','September','October','November','December')),
	Year INT DEFAULT 2025 CHECK(YEAR>1970),
	StadiumID VARCHAR(8) NOT NULL,
	PRIMARY KEY(StoreID,StoreNetIncome),
	FOREIGN KEY(StadiumID) REFERENCES STADIUM(StadiumID) ON DELETE CASCADE
);


show tables; 
TRUNCATE TABLE PLAYER;
DROP TABLE IF EXISTS CLUBPLAYER;
DROP TABLE IF EXISTS OTHERPLAYER;
DROP TABLE IF EXISTS PLAYER;

DELETE FROM PLAYER;
SELECT * FROM PLAYER;


DROP TABLE IF EXISTS CLUBPLAYER;
DROP TABLE IF EXISTS OTHERPLAYER;

