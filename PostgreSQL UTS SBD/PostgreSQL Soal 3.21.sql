-- Exercise Azwar Riansyah 1251420090 --
Soal 3.21 
DROP TABLE IF EXISTS vote, sponsor, bill, congress_person, state CASCADE;

CREATE TABLE state (
  state_name  VARCHAR(30) NOT NULL,
  region      VARCHAR(10) NOT NULL
    CHECK (region IN ('Northeast','Midwest','Southeast','Southwest','West')),
  CONSTRAINT state_pk PRIMARY KEY (state_name)
);

CREATE TABLE bill (
  bill_id           INTEGER NOT NULL,
  bill_name         VARCHAR(150) NOT NULL,
  date_of_vote      DATE NOT NULL,
  passed_or_failed  VARCHAR(3) NOT NULL
    CHECK (passed_or_failed IN ('Yes','No')),
  CONSTRAINT bill_pk PRIMARY KEY (bill_id)
);

CREATE TABLE congress_person (
  cong_id     INTEGER NOT NULL,
  name        VARCHAR(60) NOT NULL,
  district    INTEGER NOT NULL,
  start_date  DATE NOT NULL,
  party       VARCHAR(12) NOT NULL
    CHECK (party IN ('Republican','Democrat','Independent','Other')),
  state_name  VARCHAR(30) NOT NULL,
  CONSTRAINT congress_person_pk PRIMARY KEY (cong_id),
  CONSTRAINT congress_person_state_fk FOREIGN KEY (state_name)
    REFERENCES state (state_name),
  CONSTRAINT uq_state_district UNIQUE (state_name, district)
);

CREATE TABLE sponsor (
  cong_id  INTEGER NOT NULL,
  bill_id  INTEGER NOT NULL,
  CONSTRAINT sponsor_pk PRIMARY KEY (cong_id, bill_id),
  CONSTRAINT sponsor_congress_person_fk FOREIGN KEY (cong_id)
    REFERENCES congress_person (cong_id),
  CONSTRAINT sponsor_bill_fk FOREIGN KEY (bill_id)
    REFERENCES bill (bill_id)
);

CREATE TABLE vote (
  cong_id  INTEGER NOT NULL,
  bill_id  INTEGER NOT NULL,
  vote     VARCHAR(7) NOT NULL
    CHECK (vote IN ('Yes','No','Abstain','Absent')),
  CONSTRAINT vote_pk PRIMARY KEY (cong_id, bill_id),
  CONSTRAINT vote_congress_person_fk FOREIGN KEY (cong_id)
    REFERENCES congress_person (cong_id),
  CONSTRAINT vote_bill_fk FOREIGN KEY (bill_id)
    REFERENCES bill (bill_id)
);