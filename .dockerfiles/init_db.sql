CREATE TABLE IF NOT EXISTS Teams (
    team_id VARCHAR(20) PRIMARY KEY,
    name    VARCHAR(50) NOT NULL,
    wins    SMALLINT NOT NULL,
    losses  SMALLINT NOT NULL
);

CREATE TABLE IF NOT EXISTS Players (
    player_id   SERIAL PRIMARY KEY,
    team_id     VARCHAR(20) 
                REFERENCES Teams (team_id) NOT NULL,
    name        VARCHAR(50) NOT NULL,
    born        DATE NOT NULL,
    height      DECIMAL(5,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS Games (
    game_id          VARCHAR(20) PRIMARY KEY,
    home_team_id     VARCHAR(20)
                     REFERENCES Teams (team_id) NOT NULL,
    guest_team_id    VARCHAR(20)
                     REFERENCES Teams (team_id) NOT NULL,
    home_team_score  SMALLINT NOT NULL,
    guest_team_score SMALLINT NOT NULL,
    date             DATE
);

CREATE TABLE IF NOT EXISTS Results (
    result_id   SERIAL PRIMARY KEY,
    game_id     VARCHAR(20)
                REFERENCES Games (game_id) NOT NULL,
    player_id   INT
                REFERENCES Players (player_id) NOT NULL,
    points      SMALLINT NOT NULL,
    rebounds    SMALLINT NOT NULL,
    assists     SMALLINT NOT NULL
);


-- ADD DATA TO TEST THE REST API
INSERT INTO Teams VALUES ('LAL_2019_2020', 'Los Angeles Lakers', 52, 19);
INSERT INTO Teams VALUES ('MIA_2019_2020', 'Miami Heat', 44, 29);

INSERT INTO Players VALUES(DEFAULT, 'LAL_2019_2020', 'LeBron James', '1984-12-30', 2.06);
INSERT INTO Players VALUES(DEFAULT, 'LAL_2019_2020', 'Anthony Davis', '1993-03-11', 2.08);
INSERT INTO Players VALUES(DEFAULT, 'LAL_2019_2020', 'Kentavious Caldwell-Pope', '1993-02-18', 1.96);
INSERT INTO Players VALUES(DEFAULT, 'LAL_2019_2020', 'Kyle Kuzma', '1995-07-24', 2.03);
INSERT INTO Players VALUES(DEFAULT, 'LAL_2019_2020', 'Danny Green', '1987-06-22', 1.98);

INSERT INTO Players VALUES(DEFAULT, 'MIA_2019_2020', 'Jimmy Butler', '1989-10-14', 2.01);
INSERT INTO Players VALUES(DEFAULT, 'MIA_2019_2020', 'Bam Adebayo', '1997-07-18', 2.06);
INSERT INTO Players VALUES(DEFAULT, 'MIA_2019_2020', 'Tyler Herro', '2000-01-20', 1.96);
INSERT INTO Players VALUES(DEFAULT, 'MIA_2019_2020', 'Duncan Robinson', '1994-04-22', 2.01);
INSERT INTO Players VALUES(DEFAULT, 'MIA_2019_2020', 'Kendrick Nunn', '1995-08-03', 1.88);

INSERT INTO Games VALUES('LALvsMIA_10102020', 'LAL_2019_2020', 'MIA_2019_2020', 108, 111, '2020-10-10');
INSERT INTO Games VALUES('MIAvsLAL_12102020', 'MIA_2019_2020', 'LAL_2019_2020', 93, 106, '2020-10-12');

INSERT INTO Results VALUES(DEFAULT, 'LALvsMIA_10102020', 1, 40, 13, 7);
INSERT INTO Results VALUES(DEFAULT, 'LALvsMIA_10102020', 2, 28, 12, 3);
INSERT INTO Results VALUES(DEFAULT, 'LALvsMIA_10102020', 3, 16, 3, 2);
INSERT INTO Results VALUES(DEFAULT, 'LALvsMIA_10102020', 4, 7, 1, 0);
INSERT INTO Results VALUES(DEFAULT, 'LALvsMIA_10102020', 5, 8, 1, 1);
INSERT INTO Results VALUES(DEFAULT, 'LALvsMIA_10102020', 6, 35, 12, 11);
INSERT INTO Results VALUES(DEFAULT, 'LALvsMIA_10102020', 7, 13, 4, 4);
INSERT INTO Results VALUES(DEFAULT, 'LALvsMIA_10102020', 8, 12, 1, 3);
INSERT INTO Results VALUES(DEFAULT, 'LALvsMIA_10102020', 9, 26, 5, 2);
INSERT INTO Results VALUES(DEFAULT, 'LALvsMIA_10102020', 10, 14, 4, 3);

INSERT INTO Results VALUES(DEFAULT, 'MIAvsLAL_12102020', 1, 28, 14, 10);
INSERT INTO Results VALUES(DEFAULT, 'MIAvsLAL_12102020', 2, 19, 15, 3);
INSERT INTO Results VALUES(DEFAULT, 'MIAvsLAL_12102020', 3, 17, 2, 0);
INSERT INTO Results VALUES(DEFAULT, 'MIAvsLAL_12102020', 4, 2, 1, 0);
INSERT INTO Results VALUES(DEFAULT, 'MIAvsLAL_12102020', 5, 11, 5, 1);
INSERT INTO Results VALUES(DEFAULT, 'MIAvsLAL_12102020', 6, 12, 7, 8);
INSERT INTO Results VALUES(DEFAULT, 'MIAvsLAL_12102020', 7, 25, 19, 5);
INSERT INTO Results VALUES(DEFAULT, 'MIAvsLAL_12102020', 8, 7, 3, 4);
INSERT INTO Results VALUES(DEFAULT, 'MIAvsLAL_12102020', 9, 10, 1, 3);
INSERT INTO Results VALUES(DEFAULT, 'MIAvsLAL_12102020', 10, 8, 3, 1);

