USE AFCManagement;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS clubscompetition_t, league_t, continental_t;
DROP TABLE IF EXISTS competition_t;

DROP TABLE IF EXISTS president_t, footballclub_t, stadium_t, matches_t, tablelog_t, competition_t, 
league_t, continental_t, clubcompetition_t, stores_t, merchandise_t, ticketbooth_t, fan_t, payment_t, 
sportingdirector_t, accountant_t, report_t, player_t, otherplayer_t, clubplayer_t, playerstaff_t, 
medicalstaff_t, trainingstaff_t, appointment_t;

SET FOREIGN_KEY_CHECKS = 1;

DROP TABLE IF EXISTS competition_t;

show tables;


CREATE TABLE footballclub_t(
	ClubID VARCHAR(8) NOT NULL,
	ClubName VARCHAR(40) DEFAULT 'Uknown Club',
	Country VARCHAR(20) DEFAULT 'Uknown Country',
    FoundingYear INT NOT NULL,
    CONSTRAINT ClubName_chk CHECK (ClubName <> ''),
    CONSTRAINT FoundingYear_chk CHECK (FoundingYear >= 1850 ),
    CONSTRAINT Country_chk CHECK(Country <> ''),
	CONSTRAINT footballclub_t_pk PRIMARY KEY(ClubID)
);
CREATE TABLE president_t (
	PresIDNumber VARCHAR(13) NOT NULL,
	Name VARCHAR(20) DEFAULT 'Unknown Name',
	Surname VARCHAR(20) DEFAULT 'Unknown Surname',
	CountryOfOrgin VARCHAR(20) DEFAULT 'Unknown',
	DateOfBirth DATE,
	ClubID VARCHAR(8) NOT NULL,
	CONSTRAINT name_chk CHECK (Name <> ''),
	CONSTRAINT surname_chk CHECK (Surname <> ''),
	CONSTRAINT countryoforgin_chk CHECK (CountryOfOrgin <> ''),
	CONSTRAINT dateofbirth_chk CHECK (DateOfBirth >= '1900-01-01'),
	CONSTRAINT president_t_pk PRIMARY KEY (PresIDNumber),
	CONSTRAINT footballclub_t_fk FOREIGN KEY (ClubID) REFERENCES footballclub_t(ClubID) ON DELETE CASCADE
);
CREATE TABLE stadium_t (
    StadiumID VARCHAR(8) NOT NULL,
    ClubID VARCHAR(8) NOT NULL,
    StadiumName VARCHAR(50) DEFAULT 'Unknown',
    StadiumCapacity INT,
    Location VARCHAR(30) DEFAULT 'Unknown stadium location',

    CONSTRAINT StadiumName_chk CHECK (StadiumName <> ''),
    CONSTRAINT StadiumCapacity_chk CHECK (StadiumCapacity > 0 AND StadiumCapacity <= 200000),
    CONSTRAINT Location_chk CHECK (Location <> ''),
    CONSTRAINT stadium_t_pk PRIMARY KEY (StadiumID),
    CONSTRAINT stad_footballclub_t_fk FOREIGN KEY (ClubID) REFERENCES footballclub_t(ClubID) ON DELETE CASCADE
);

CREATE TABLE matches_t (
    MatchID VARCHAR(8) NOT NULL,
    StadiumID VARCHAR(8) NOT NULL,
    HomeOrAway VARCHAR(4),
    Result VARCHAR(4),
    Coach VARCHAR(20) DEFAULT 'Coach',
    DateOfMatch DATE,
    StartTime TIME DEFAULT '15:00:00',
    
    CONSTRAINT HomeOrAway_chk CHECK (HomeOrAway IN ('Home', 'Away')),
    CONSTRAINT Result_chk CHECK (Result IN ('Win', 'Lose', 'Draw')),
    CONSTRAINT DateOfMatch_chk CHECK (DateOfMatch >= '2000-01-01'),
    CONSTRAINT matches_t_pk PRIMARY KEY(MatchID),
    CONSTRAINT match_stadium_t_fk FOREIGN KEY(StadiumID) REFERENCES stadium_t(StadiumID) ON DELETE RESTRICT
);
CREATE TABLE competition_t(
	CompetitonID VARCHAR(8) NOT NULL,
	Name VARCHAR(20) DEFAULT 'Uknown Competition',
	Season VARCHAR(5) DEFAULT 'UknSz',
	NumberOfTeams INT DEFAULT 0,
	GoverningBody VARCHAR(15) DEFAULT 'FIFA',
	CurrentChampions VARCHAR(20) DEFAULT 'Uknown',
	LogID VARCHAR(8) NOT NULL,

	CONSTRAINT competition_Name_chk CHECK (Name <> ''),
	CONSTRAINT competition_NumberOfTeams_chk CHECK (NumberOfTeams = 20 OR NumberOfTeams = 36),
	CONSTRAINT competition_GoverningBody_chk CHECK (GoverningBody <> ''),
	CONSTRAINT competition_CurrentChampions_chk CHECK (CurrentChampions <> ''),
	CONSTRAINT competition_t_pk PRIMARY KEY(CompetitonID)
);


CREATE TABLE tablelog_t (
    LogID VARCHAR(8) NOT NULL,
    ClubID VARCHAR(8) NOT NULL,
    Season VARCHAR(5) DEFAULT 'UknSz',
    MatchID VARCHAR(8) NOT NULL,
    CompetitonID VARCHAR(8) NOT NULL,
    Position INT DEFAULT 0,

    CONSTRAINT tablelog_Position_chk CHECK (Position >= 1 AND Position <= 20),
    CONSTRAINT tablelog_t_pk PRIMARY KEY(LogID),
    CONSTRAINT tablelog_footballclub_t_fk FOREIGN KEY(ClubID) REFERENCES footballclub_t(ClubID) ON DELETE CASCADE,
    CONSTRAINT tablelog_matches_t_fk FOREIGN KEY(MatchID) REFERENCES matches_t(MatchID) ON DELETE RESTRICT,
    CONSTRAINT tablelog_competition_t_fk FOREIGN KEY(CompetitonID) REFERENCES competition_t(CompetitonID) ON DELETE CASCADE
);

CREATE TABLE league_t(
	CompetitonID VARCHAR(8) NOT NULL,
	TransferWindowStartDate DATE DEFAULT '2025-01-01',
	TransferWindowEndDate DATE DEFAULT '2025-01-30',
	SpendingLimit FLOAT DEFAULT 0,
	
	CONSTRAINT TransferWindowEndDate_chk CHECK (TransferWindowEndDate >= TransferWindowStartDate),
	CONSTRAINT SpendingLimit_chk CHECK (SpendingLimit >= 0),
	
	CONSTRAINT league_t_pk PRIMARY KEY(CompetitonID),
	CONSTRAINT league_competition_t_fk FOREIGN KEY(CompetitonID) REFERENCES competition_t(CompetitonID) ON DELETE CASCADE
);

CREATE TABLE continental_t(
	CompetitonID VARCHAR(8) NOT NULL,
	CountryAssociation VARCHAR(20) DEFAULT 'No Country Assoc',
	FinalCountry VARCHAR(20) DEFAULT 'TBD',
	FinalStadium VARCHAR(30) DEFAULT 'stadium TBD',

	CONSTRAINT continental_t_CountryAssociation_chk CHECK (CountryAssociation <> ''),
	CONSTRAINT continental_t_FinalCountry_chk CHECK (FinalCountry <> ''),
	CONSTRAINT continental_t_FinalStadium_chk CHECK (FinalStadium <> ''),
	
	CONSTRAINT continental_t_pk PRIMARY KEY(CompetitonID),
	CONSTRAINT continental_t_competition_t_fk FOREIGN KEY(CompetitonID) REFERENCES competition_t(CompetitonID) ON DELETE CASCADE
);

CREATE TABLE clubcompetition_t(
	CompetitonID VARCHAR(8) NOT NULL,
	ClubID VARCHAR(8) NOT NULL,
	Matches INT DEFAULT 38,
	Ranking INT DEFAULT 20,

	CONSTRAINT clubcompetition_t_Matches_chk CHECK (Matches >= 38 AND Matches <= 67),
	CONSTRAINT clubcompetition_t_Ranking_chk CHECK (Ranking >= 1 AND Ranking <= 36),
	
	CONSTRAINT clubcompetition_t_clubcompetition_t_pk PRIMARY KEY(CompetitonID, ClubID),
	CONSTRAINT clubcompetition_t_competition_t_fk FOREIGN KEY(CompetitonID) REFERENCES competition_t(CompetitonID) ON DELETE CASCADE,
	CONSTRAINT clubcompetition_t_footballclub_t_fk FOREIGN KEY(ClubID) REFERENCES footballclub_t(ClubID) ON DELETE CASCADE
);


CREATE TABLE stores_t(
	StoreID VARCHAR(8) NOT NULL,
	StoreNetIncome FLOAT NOT NULL DEFAULT 0.0,
	StoreName VARCHAR(20) DEFAULT 'Uknown',
	YearEstablished DATE DEFAULT '2000-01-01',
	Manager VARCHAR(20) DEFAULT 'Uknown Manager',
	NumberOfStaff INT DEFAULT 10,
	Month VARCHAR(9),
	Year INT DEFAULT '2025',
	StadiumID VARCHAR(8) NOT NULL,

	CONSTRAINT StoreName_chk CHECK (StoreName <> ''),
	CONSTRAINT YearEstablished_chk CHECK (YearEstablished > '1970-01-01'),
	CONSTRAINT Manager_chk CHECK (Manager <> ''),
	CONSTRAINT NumberOfStaff_chk CHECK (NumberOfStaff > 0),
	CONSTRAINT Month_chk CHECK (Month IN ('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')),
	CONSTRAINT Year_chk CHECK (Year > 1970),
	
	CONSTRAINT stores_t_pk PRIMARY KEY(StoreID, StoreNetIncome),
	CONSTRAINT stadium_t_fk FOREIGN KEY(StadiumID) REFERENCES stadium_t(StadiumID) ON DELETE CASCADE
);
DROP TABLE IF EXISTS merchandise_t;
CREATE TABLE merchandise_t(
	StoreID VARCHAR(8) NOT NULL,
	StoreNetIncome FLOAT NOT NULL DEFAULT 0.0,
	SeasonKits VARCHAR(5) DEFAULT 'UknSz',
	TypeOfKit VARCHAR(6) DEFAULT 'Home',
	TotalStockAvailable INT DEFAULT 0,
	Price FLOAT DEFAULT 600,

	CONSTRAINT TypeOfKit_chk CHECK (TypeOfKit IN ('Home', 'Away', 'Third')),
	CONSTRAINT TotalStockAvailable_chk CHECK (TotalStockAvailable >= 0),
	CONSTRAINT Price_chk CHECK (Price > 0),

	CONSTRAINT merchandise_t_pk PRIMARY KEY(StoreID, StoreNetIncome),
	CONSTRAINT merchandise_stores_t_fk FOREIGN KEY(StoreID, StoreNetIncome) REFERENCES stores_t(StoreID, StoreNetIncome) ON DELETE CASCADE
);

CREATE TABLE ticketbooth_t(
	StoreID VARCHAR(8) NOT NULL,
	TypeOfTicket VARCHAR(10) DEFAULT 'Standard',
	SeatNumber INT DEFAULT 0,
	Price FLOAT DEFAULT 60,

	CONSTRAINT ticketbooth_TypeOfTicket_chk CHECK (TypeOfTicket IN ('Standard', 'Premium', 'Deluxe')),
	CONSTRAINT ticketbooth_SeatNumber_chk CHECK (SeatNumber < 150000),
	CONSTRAINT ticketbooth_Price_chk CHECK (Price > 0),

	CONSTRAINT ticketbooth_t_pk PRIMARY KEY(StoreID, StoreNetIncome),
	CONSTRAINT ticketbooth_stores_t_fk FOREIGN KEY(StoreID, StoreNetIncome) REFERENCES stores_t(StoreID, StoreNetIncome) ON DELETE CASCADE
);

CREATE TABLE fan_t(
	IDNumber VARCHAR(13) NOT NULL,
	Name VARCHAR(20) DEFAULT 'Name not found',
	Surname VARCHAR(20) DEFAULT 'Surname not found',
	DateOfBirth DATE DEFAULT '2000-01-01',

	CONSTRAINT fan_Name_chk CHECK (Name <> ''),
	CONSTRAINT fan_Surname_chk CHECK (Surname <> ''),

	CONSTRAINT fan_t_pk PRIMARY KEY(IDNumber)
);
CREATE TABLE payment_t(
	PaymentNumber VARCHAR(8) NOT NULL,
	Amount FLOAT DEFAULT 60,
	DateOfPayment DATE DEFAULT '1970-01-01',
	TimeOfPayment TIME DEFAULT '00:00:00',
	Product VARCHAR(80) DEFAULT 'Uknown Product',
	IDNumber VARCHAR(13) NOT NULL,
	StoreID VARCHAR(8) NOT NULL,

	CONSTRAINT payment_Amount_chk CHECK (Amount > 0),
	CONSTRAINT payment_DateOfPayment_chk CHECK (DateOfPayment >= '1970-01-01'),
	CONSTRAINT payment_TimeOfPayment_chk CHECK (TimeOfPayment >= '00:00:00' AND TimeOfPayment <= '23:59:59'),
	CONSTRAINT payment_Product_chk CHECK (Product <> ''),

	CONSTRAINT payment_t_pk PRIMARY KEY(PaymentNumber),
	CONSTRAINT payment_fan_t_fk FOREIGN KEY(IDNumber) REFERENCES fan_t(IDNumber) ON DELETE CASCADE,
	CONSTRAINT payment_stores_t_fk FOREIGN KEY(StoreID) REFERENCES stores_t(StoreID) ON DELETE CASCADE
);

CREATE TABLE player_t(
	PIDNumber VARCHAR(8) NOT NULL,
	Name VARCHAR(20) DEFAULT 'Name not found',
	Surname VARCHAR(20) DEFAULT 'Surname not found',
	Age INT DEFAULT 18,
	Position VARCHAR(30) DEFAULT 'Goalkeeper',
	MarketValue FLOAT DEFAULT 0,

	CONSTRAINT player_Name_chk CHECK (Name <> ''),
	CONSTRAINT player_Surname_chk CHECK (Surname <> ''),
	CONSTRAINT player_Age_chk CHECK (Age >= 16),
	CONSTRAINT player_Position_chk CHECK (Position IN ('Attacker', 'Midfielder', 'Defender', 'Goalkeeper')),
	CONSTRAINT player_MarketValue_chk CHECK (MarketValue >= 0),

	CONSTRAINT player_t_pk PRIMARY KEY(PIDNumber)
);

CREATE TABLE otherplayer_t(
	PIDNumber VARCHAR(8) NOT NULL,
	Name VARCHAR(20) DEFAULT 'Name not found',
	LastClub VARCHAR(20) DEFAULT 'N/A',
	ReleaseClause FLOAT DEFAULT 0,
	Manager VARCHAR(20) NOT NULL,

	CONSTRAINT otherplayer_Name_chk CHECK (Name <> ''),
	CONSTRAINT otherplayer_LastClub_chk CHECK (LastClub <> ''),
	CONSTRAINT otherplayer_ReleaseClause_chk CHECK (ReleaseClause >= 0),

	CONSTRAINT otherplayer_t_pk PRIMARY KEY(PIDNumber),
	CONSTRAINT otherplayer_player_t_fk FOREIGN KEY(PIDNumber) REFERENCES player_t(PIDNumber) ON DELETE CASCADE
);

CREATE TABLE clubplayer_t(
	PIDNumber VARCHAR(8) NOT NULL,
	Name VARCHAR(20) DEFAULT 'Name not found',
	ShirtNumber INT DEFAULT 7,
	ClubID VARCHAR(8) NOT NULL,

	CONSTRAINT clubplayer_Name_chk CHECK (Name <> ''),
	CONSTRAINT clubplayer_ShirtNumber_chk CHECK (ShirtNumber > 0 AND ShirtNumber <= 99),

	CONSTRAINT clubplayer_t_pk PRIMARY KEY(PIDNumber),
	CONSTRAINT clubplayer_footballclub_t_fk FOREIGN KEY(ClubID) REFERENCES footballclub_t(ClubID) ON DELETE CASCADE,
	CONSTRAINT clubplayer_player_t_fk FOREIGN KEY(PIDNumber) REFERENCES player_t(PIDNumber) ON DELETE CASCADE
);

CREATE TABLE sportingdirector_t(
	SportID VARCHAR(8) NOT NULL,
	SportNetSpend FLOAT NOT NULL,
	Name VARCHAR(20) DEFAULT 'Name',
	Surname VARCHAR(20) DEFAULT 'Surname not found',
	LastClub VARCHAR(20) DEFAULT 'N/A',
	TransferBudget FLOAT DEFAULT 0,
	Year INT DEFAULT 2000,
	Month VARCHAR(9) CHECK (Month IN ('January', 'February', 'March','April','May','June','July','August','September','October','November','December')),
	PIDNumber VARCHAR(8) NOT NULL,
	ClubID VARCHAR(8) NOT NULL,

	CONSTRAINT sportingdirector_Name_chk CHECK(Name <> ''),
	CONSTRAINT sportingdirector_Surname_chk CHECK(Surname <> ''),
	CONSTRAINT sportingdirector_TransferBudget_chk CHECK (TransferBudget >= 0),

	CONSTRAINT sportingdirector_t_pk PRIMARY KEY(SportID, SportNetSpend),
	CONSTRAINT sportingdirector_player_t_fk FOREIGN KEY (PIDNumber) REFERENCES player_t(PIDNumber) ON DELETE CASCADE,
	CONSTRAINT sportingdirector_footballclub_t_fk FOREIGN KEY (ClubID) REFERENCES footballclub_t(ClubID) ON DELETE CASCADE
);

CREATE TABLE accountant_t(
	AccID VARCHAR(8) NOT NULL,
	TeamMarketValue FLOAT DEFAULT 10,
	Name VARCHAR(20) DEFAULT 'Name not found',
	Surname VARCHAR(20) DEFAULT 'Surname not found',
	Age INT DEFAULT 18,
	Month VARCHAR(9) CHECK (Month IN ('January', 'February', 'March','April','May','June','July','August','September','October','November','December')),
	Year INT DEFAULT 2000,
	NetProfit FLOAT DEFAULT 0,
	StoreID VARCHAR(8) NOT NULL,
	SportID VARCHAR(8) NOT NULL,

	CONSTRAINT accountant_Name_chk CHECK (Name <> ''),
	CONSTRAINT accountant_Surname_chk CHECK (Surname <> ''),
	CONSTRAINT accountant_NetProfit_chk CHECK (NetProfit >= 0),
	CONSTRAINT accountant_TeamMarketValue_chk CHECK (TeamMarketValue > 0),
	CONSTRAINT accountant_Age_chk CHECK (Age >= 18),

	CONSTRAINT accountant_t_pk PRIMARY KEY(AccID),
	CONSTRAINT accountant_stores_t_fk FOREIGN KEY(StoreID) REFERENCES stores_t(StoreID) ON DELETE RESTRICT,
	CONSTRAINT accountant_sportingdirector_t_fk FOREIGN KEY(SportID) REFERENCES sportingdirector_t(SportID) ON DELETE RESTRICT
);

CREATE TABLE report_t(
	AccID VARCHAR(8) NOT NULL,
	PresIDNumber VARCHAR(13) NOT NULL,
	DateOfReport DATE,
	Amount FLOAT DEFAULT 0,

	CONSTRAINT report_Amount_chk CHECK (Amount <> 0),

	CONSTRAINT report_t_pk PRIMARY KEY(AccID, PresIDNumber, DateOfReport),
	CONSTRAINT report_accountant_t_fk FOREIGN KEY(AccID) REFERENCES accountant_t(AccID) ON DELETE CASCADE,
	CONSTRAINT report_president_t_fk FOREIGN KEY(PresIDNumber) REFERENCES president_t(PresIDNumber) ON DELETE CASCADE
);

CREATE TABLE playerstaff_t(
	StaffNumber VARCHAR(8) NOT NULL,
	Name VARCHAR(20) DEFAULT 'Name not found',
	Surname VARCHAR(20) DEFAULT 'Surname not found',
	Age INT DEFAULT 18,
	CONSTRAINT playerstaff_surname_chk CHECK (Surname <> ''),
	CONSTRAINT playerstaff_name_chk CHECK (Name <> ''),
	CONSTRAINT playerstaff_age_chk CHECK (Age >= 18),

	CONSTRAINT playerstaff_t_pk PRIMARY KEY(StaffNumber)
);

CREATE TABLE medicalstaff_t(
	StaffNumber VARCHAR(8) NOT NULL,
	Qualification VARCHAR(60) DEFAULT 'Unknown Qualification',
	Practice VARCHAR(30) DEFAULT 'Football club medical staff',
	CONSTRAINT medicalstaff_practice_chk CHECK (Practice <> ''),
	CONSTRAINT medicalstaff_qualification_chk CHECK (Qualification <> ''),

	CONSTRAINT medicalstaff_t_pk PRIMARY KEY(StaffNumber),
	CONSTRAINT medicalstaff_playerstaff_fk FOREIGN KEY(StaffNumber) REFERENCES playerstaff_t(StaffNumber) ON DELETE CASCADE
);

CREATE TABLE trainingstaff_t(
	StaffNumber VARCHAR(8) NOT NULL,
	Position VARCHAR(30) DEFAULT 'No distinct position training',
	CoachingDegree VARCHAR(30) DEFAULT 'Standard Degree',
	CONSTRAINT trainingstaff_coachingdegree_chk CHECK (CoachingDegree <> ''),
	CONSTRAINT trainingstaff_position_chk CHECK (Position IN ('Attacker', 'Midfielder', 'Defender', 'Goalkeeper')),

	CONSTRAINT trainingstaff_t_pk PRIMARY KEY(StaffNumber),
	CONSTRAINT trainingstaff_playerstaff_fk FOREIGN KEY(StaffNumber) REFERENCES playerstaff_t(StaffNumber) ON DELETE CASCADE
);

CREATE TABLE appointment_t(
	DateOfAppointment DATE NOT NULL,
	StaffNumber VARCHAR(8) DEFAULT 2,
	PIDNumber VARCHAR(8) NOT NULL,
	Description VARCHAR(50) DEFAULT 'Check up',
	CONSTRAINT appointment_description_chk CHECK (Description IN ('Routine Medical Checkup', 'Pre-Season Medical Assessment', 'Post-Match Recovery Assessment', 'Blood Tests', 'Injury Diagnosis', 'Physiotherapy Session', 'Post Injury Fitness Test')),
	CONSTRAINT appointment_staffnumber_chk CHECK (StaffNumber >= 2),
	PRIMARY KEY(DateOfAppointment, StaffNumber, PIDNumber),
	FOREIGN KEY(StaffNumber) REFERENCES playerstaff_t(StaffNumber) ON DELETE RESTRICT,
	FOREIGN KEY(PIDNumber) REFERENCES player_t(PIDNumber) ON DELETE RESTRICT
);
show tables;

-- //////////////////////////////////////////////TRIGGERS////////////////////////////////////////////////////////

DROP TRIGGER IF EXISTS validate_date_of_birth;
DELIMITER //
CREATE TRIGGER validate_date_of_birth
BEFORE INSERT ON fan_t
FOR EACH ROW
BEGIN
    IF NEW.DateOfBirth >= CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Date of birth must be before the current date';
    END IF;
END //
DELIMITER ;
-- we set a new delimiter that acts as the end of the statement. This way the semi colon becomes a character we can use in the coding of our procedure

DROP TRIGGER IF EXISTS before_insert_report;
DELIMITER //
CREATE TRIGGER before_insert_report
BEFORE INSERT ON report_t
FOR EACH ROW
BEGIN
   IF NEW.DateOfReport IS NULL THEN
      SET NEW.DateOfReport = CURRENT_DATE();
   END IF;
END //
DELIMITER ;

-- //////////////////////////////////////////////MAIN STORED PROCEDURES//////////////////////////////////////////////


DROP PROCEDURE IF EXISTS Report1;
DELIMITER //
CREATE PROCEDURE Report1(
    IN inYear INT,
    IN inMonth VARCHAR(9)
)
BEGIN
    WITH club_totals AS ( -- table of clubs who spent the most money
        SELECT ClubID, SUM(SportNetSpend) AS TotalSpent
        FROM sportingdirector_t
        WHERE Year = inYear AND Month = inMonth
        GROUP BY ClubID
        ORDER BY TotalSpent DESC -- in descending order
        LIMIT 5 -- the top 5
    ),
    club_max AS ( -- table of clubs who spent the most money
        SELECT sportingdirector_t.ClubID, sportingdirector_t.PIDNumber, sportingdirector_t.SportNetSpend AS LargestPurchase
        FROM sportingdirector_t
        JOIN (
            SELECT ClubID, MAX(SportNetSpend) AS MaxSpend
            FROM sportingdirector_t
            WHERE Year = inYear AND Month = inMonth -- Matches the given year and month
            GROUP BY ClubID
        ) mx
        ON sportingdirector_t.ClubID = mx.ClubID AND sportingdirector_t.SportNetSpend = mx.MaxSpend -- joining the tables
    )
    SELECT 
        clubs.ClubName, -- columns in the displayed table
        clubTotals.TotalSpent, 
        clubMax.LargestPurchase, 
        player.Name AS TopPlayerFirst, 
        player.Surname AS TopPlayerLast
    FROM club_totals clubTotals
    JOIN footballclub_t clubs ON clubTotals.ClubID = clubs.ClubID -- joining the club_totals table to footballclub_t on CID
    JOIN club_max clubMax ON clubTotals.ClubID = clubMax.ClubID -- joining the club_totals table to clubMax_t on CID
    JOIN player_t player ON clubMax.PIDNumber = player.PIDNumber -- joining the club_totals table to player_t on PID to display the names
    ORDER BY clubTotals.TotalSpent DESC;
END//
DELIMITER ;



DROP PROCEDURE IF EXISTS GetClubSquad;
DELIMITER $$
CREATE PROCEDURE GetClubSquad(IN in_ClubID VARCHAR(8))
BEGIN
    SELECT 
        fc.ClubName,
        p.Name,
        p.Surname,
        p.Position,
        p.Age,
        p.MarketValue
    FROM clubplayer_t cp
    JOIN player_t p ON cp.PIDNumber = p.PIDNumber
    JOIN footballclub_t fc ON cp.ClubID = fc.ClubID
    WHERE cp.ClubID = in_ClubID
    ORDER BY p.Position, p.MarketValue DESC;
END $$
DELIMITER ;


-- //////////////////////////////////////////////OTHER STORED PROCEDURES//////////////////////////////////////////////


DROP PROCEDURE IF EXISTS AddNewPlayerWithClubInfo;
DELIMITER //
CREATE PROCEDURE AddNewPlayerWithClubInfo(
	IN playerID VARCHAR(8), 
	IN playerName VARCHAR(20), 
	IN playerSurname VARCHAR(20), 
	IN playerAge INT, 
	IN playerPosition VARCHAR(30),
	IN marketValue FLOAT,
	IN shirtNumber INT,
	IN clubID VARCHAR(8)
)
BEGIN
    INSERT INTO player_t (PIDNumber, Name, Surname, Age, Position, MarketValue)
    VALUES (playerID, playerName, playerSurname, playerAge, playerPosition, marketValue);

    INSERT INTO clubplayer_t (PIDNumber, ShirtNumber, ClubID)
    VALUES (playerID, shirtNumber, clubID);
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS AddNewClub;
DELIMITER //
CREATE PROCEDURE AddNewClub(
	IN CID VARCHAR(8),
	IN CName VARCHAR(40), 
	IN Cnt VARCHAR(20), 
	IN FoundYear INT 
)
BEGIN 
	INSERT INTO footballclub_t (ClubID, ClubName,Country,FoundingYear)
	VALUES (CID,CName,Cnt,FoundYear);
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS UpdateStoreIncomeAndReport;
DELIMITER //
CREATE PROCEDURE UpdateStoreIncomeAndReport(
    IN storeID VARCHAR(8),
    IN newIncome FLOAT,
    IN accID VARCHAR(8),
    IN presID VARCHAR(13),
    IN reportDate DATE,
    IN reportAmount FLOAT
)
BEGIN
    UPDATE stores_t
    SET StoreNetIncome = newIncome
    WHERE StoreID = storeID;

    INSERT INTO report_t (AccID, PresIDNumber, DateOfReport, Amount)
    VALUES (accID, presID, reportDate, reportAmount);
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS addNewPresident;
DELIMITER //

CREATE PROCEDURE addNewPresident(
	IN PID VARCHAR(13),
	IN name VARCHAR(20),
	IN sname VARCHAR(20),
	IN coo VARCHAR(20),
	IN dob DATE,
	IN cid VARCHAR(8)
)
BEGIN
	INSERT INTO president_t(PresIDNumber, Name, Surname, CountryOfOrgin, DateOfBirth, ClubID)
	VALUES(PID, name, sname, coo, dob, cid);
END //

DELIMITER ;


DROP PROCEDURE IF EXISTS InsertClubPlayer;
DELIMITER //
CREATE PROCEDURE InsertClubPlayer(
    IN pid VARCHAR(8),
    IN pname VARCHAR(20),
    IN psurname VARCHAR(20),
    IN page INT,
    IN pposition VARCHAR(30),
    IN pvalue FLOAT,
    IN shirtNum INT,
    IN clubID VARCHAR(8)
)
BEGIN
    INSERT INTO player_t(PIDNumber, Name, Surname, Age, Position, MarketValue)
    VALUES (pid, pname, psurname, page, pposition, pvalue);

    INSERT INTO clubplayer_t(PIDNumber, Name, ShirtNumber, ClubID)
    VALUES (pid, pname, shirtNum, clubID);
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS InsertOtherPlayer;
DELIMITER //
CREATE PROCEDURE InsertOtherPlayer(
    IN pid VARCHAR(8),
    IN pname VARCHAR(20),
    IN psurname VARCHAR(20),
    IN page INT,
    IN pposition VARCHAR(30),
    IN pvalue FLOAT,
    IN lastClub VARCHAR(20),
    IN releaseClause FLOAT,
    IN ManagerIN VARCHAR(20)
)
BEGIN
    INSERT INTO player_t(PIDNumber, Name, Surname, Age, Position, MarketValue)
    VALUES (pid, pname, psurname, page, pposition, pvalue);

    INSERT INTO otherplayer_t(PIDNumber, Name, LastClub, ReleaseClause, Manager)
    VALUES (pid, pname, lastClub, releaseClause, ManagerIN);
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS InsertSportingDirector; 
DELIMITER //
CREATE PROCEDURE InsertSportingDirector(
    IN in_SportID VARCHAR(8),
    IN in_SportNetSpend FLOAT,
    IN in_Name VARCHAR(20),
    IN in_Surname VARCHAR(20),
    IN in_TransferBudget FLOAT,
    IN in_Year INT,
    IN in_Month VARCHAR(9),
    IN CID VARCHAR(8),
    IN _PIDN VARCHAR(8)
)
BEGIN
    INSERT INTO sportingdirector_t(SportID, SportNetSpend, Name, Surname, TransferBudget, Year, Month, ClubID, PIDNumber) 
    VALUES (in_SportID, in_SportNetSpend, in_Name, in_Surname, in_TransferBudget, in_Year, in_Month, CID, _PIDN);
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS UpdateClubPlayer;
DELIMITER //
CREATE PROCEDURE UpdateClubPlayer(
    IN pid VARCHAR(8),
    IN pname VARCHAR(20),
    IN psurname VARCHAR(20),
    IN page INT,
    IN pposition VARCHAR(30),
    IN pvalue FLOAT,
    IN shirtNum INT,
    IN clubID VARCHAR(8)
)
BEGIN
    UPDATE player_t
    SET Name = pname, Surname = psurname, Age = page, Position = pposition, MarketValue = pvalue
    WHERE PIDNumber = pid;

    UPDATE clubplayer_t
    SET ShirtNumber = shirtNum, ClubID = clubID
    WHERE PIDNumber = pid;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS UpdateOtherPlayer;
DELIMITER //
CREATE PROCEDURE UpdateOtherPlayer(
    IN p_pid VARCHAR(8),
    IN p_name VARCHAR(20),
    IN p_surname VARCHAR(20),
    IN p_age INT,
    IN p_position VARCHAR(30),
    IN p_marketValue FLOAT,
    IN p_lastClub VARCHAR(20),
    IN p_releaseClause FLOAT,
    IN p_manager VARCHAR(20)
)
BEGIN
    UPDATE player_t
    SET Name = p_name, Surname = p_surname, Age = p_age, Position = p_position, MarketValue = p_marketValue
    WHERE PIDNumber = p_pid;

    UPDATE otherplayer_t
    SET Name = p_name, LastClub = p_lastClub, ReleaseClause = p_releaseClause, Manager = p_manager
    WHERE PIDNumber = p_pid;
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS InsertStadium;
DELIMITER //
CREATE PROCEDURE InsertStadium(
    IN in_StadiumID VARCHAR(8),
    IN in_ClubID VARCHAR(8),
    IN in_StadiumName VARCHAR(30),
    IN in_StadiumCapacity INT,
    IN in_Location VARCHAR(30)
)
BEGIN
    INSERT INTO stadium_t (StadiumID, ClubID, StadiumName, StadiumCapacity, Location) 
    VALUES (in_StadiumID, in_ClubID, in_StadiumName, in_StadiumCapacity, in_Location);
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS DeleteStadium;
DELIMITER //
CREATE PROCEDURE DeleteStadium(IN in_StadiumID VARCHAR(8))
BEGIN
    DELETE FROM stadium_t WHERE StadiumID = in_StadiumID;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS UpdateStadium;
DELIMITER //
CREATE PROCEDURE UpdateStadium(
	IN in_StadiumID VARCHAR(8),
	IN in_ClubID VARCHAR(8),
	IN in_StadiumName VARCHAR(50),
	IN in_StadiumCapacity INT ,
	IN in_Location VARCHAR(50)
)
BEGIN
    UPDATE stadium_t
    SET ClubID = in_ClubID, StadiumName = in_StadiumName, StadiumCapacity = in_StadiumCapacity, Location = in_Location
    WHERE StadiumID = in_StadiumID;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS UpdateStore;
DELIMITER //
CREATE PROCEDURE UpdateStore(IN in_StoreID VARCHAR(8),
	IN in_StoreNetIncome FLOAT,
	IN in_StoreName VARCHAR(20),
	IN in_YearEstablished DATE,
	IN in_UnitOfBuilding VARCHAR(2),
	IN in_Manager VARCHAR(20),
	IN in_NumberOfStaff INT,
	IN in_Month VARCHAR(9),
	IN in_Year INT,
	IN in_StadiumID VARCHAR(8)
)
BEGIN
    UPDATE stores_t
    SET 
        StoreName = in_StoreName,
        YearEstablished = in_YearEstablished,
        UnitOfBuilding = in_UnitOfBuilding,
        Manager = in_Manager,
        NumberOfStaff = in_NumberOfStaff,
        Month = in_Month,
        Year = in_Year,
        StadiumID = in_StadiumID
    WHERE 
        StoreID = in_StoreID AND StoreNetIncome = in_StoreNetIncome;
END//
DELIMITER ;




DROP PROCEDURE IF EXISTS AddNewMerchandiseStore;
DELIMITER //
CREATE PROCEDURE AddNewMerchandiseStore(
    IN in_StoreID VARCHAR(8),
    IN in_StoreNetIncome FLOAT,
    IN in_StoreName VARCHAR(20),
    IN in_YearEstablished DATE,
    IN in_Manager VARCHAR(20),
    IN in_NumberOfStaff INT,
    IN in_Month VARCHAR(9),
    IN in_Year INT,
    IN in_StadiumID VARCHAR(8),
    IN in_SeasonKits VARCHAR(5),
    IN in_TypeOfKit VARCHAR(6),
    IN in_TotalStockAvailable INT,
    IN in_Price FLOAT
)
BEGIN
    -- Insert into parent table
    INSERT INTO stores_t (StoreID, StoreNetIncome, StoreName, YearEstablished, Manager, NumberOfStaff, Month, Year, StadiumID)
    VALUES (in_StoreID, in_StoreNetIncome, in_StoreName, in_YearEstablished, in_Manager, in_NumberOfStaff, in_Month, in_Year, in_StadiumID);

    -- Insert into child table
    INSERT INTO merchandise_t (StoreID, StoreNetIncome, SeasonKits, TypeOfKit, TotalStockAvailable, Price)
    VALUES (in_StoreID, in_StoreNetIncome, in_SeasonKits, in_TypeOfKit, in_TotalStockAvailable, in_Price);
END //
DELIMITER ;




DROP PROCEDURE IF EXISTS AddNewTicketBoothStore;
DELIMITER //

CREATE PROCEDURE AddNewTicketBoothStore(
    IN in_StoreID VARCHAR(8),
    IN in_StoreNetIncome FLOAT,
    IN in_StoreName VARCHAR(20),
    IN in_YearEstablished DATE,
    IN in_Manager VARCHAR(20),
    IN in_NumberOfStaff INT,
    IN in_Month VARCHAR(9),
    IN in_Year INT,
    IN in_StadiumID VARCHAR(8),
    IN in_TypeOfTicket VARCHAR(10),
    IN in_SeatNumber INT,
    IN in_Price FLOAT
)
BEGIN
    -- Insert into parent table
    INSERT INTO stores_t (StoreID, StoreNetIncome, StoreName, YearEstablished, Manager, NumberOfStaff, Month, Year, StadiumID)
    VALUES (in_StoreID, in_StoreNetIncome, in_StoreName, in_YearEstablished, in_Manager, in_NumberOfStaff, in_Month, in_Year, in_StadiumID);

    -- Insert into child table
    INSERT INTO ticketbooth_t (StoreID, StoreNetIncome, TypeOfTicket, SeatNumber, Price)
    VALUES (in_StoreID, in_StoreNetIncome, in_TypeOfTicket, in_SeatNumber, in_Price);
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS Top5NetIncomePerCapacity;
DELIMITER //

CREATE PROCEDURE Top5NetIncomePerCapacity()
BEGIN
    SELECT 
        fc.ClubName,
        st.StadiumName,
        st.StadiumCapacity,
        ROUND(SUM(s.StoreNetIncome) / st.StadiumCapacity, 2) AS IncomePerCapacity,
        ROUND(SUM(s.StoreNetIncome), 2) AS TotalIncome
    FROM footballclub_t fc
    JOIN stadium_t st ON fc.ClubID = st.ClubID
    JOIN stores_t s ON st.StadiumID = s.StadiumID
    GROUP BY fc.ClubID, st.StadiumName, st.StadiumCapacity
    HAVING st.StadiumCapacity > 0
    ORDER BY IncomePerCapacity DESC;
END //
DELIMITER ;



show tables; 

SELECT * FROM footballclub_t;