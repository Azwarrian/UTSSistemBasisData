-- Exercise Azwar Riansyah 1251420090 --
Soal 3.34
DROP TABLE IF EXISTS public.vote, public.sponsor, public.bill, public.congress_person, public.state CASCADE;

CREATE TABLE public.state (
  state_name  VARCHAR(30) PRIMARY KEY,
  region      VARCHAR(10) NOT NULL
    CHECK (region IN ('Northeast','Midwest','Southeast','Southwest','West'))
);

CREATE TABLE public.bill (
  bill_id           INTEGER PRIMARY KEY,
  bill_name         VARCHAR(150) NOT NULL,
  date_of_vote      DATE NOT NULL,
  passed_or_failed  VARCHAR(3) NOT NULL CHECK (passed_or_failed IN ('Yes','No'))
);

CREATE TABLE public.congress_person (
  cong_id     INTEGER PRIMARY KEY,
  name        VARCHAR(60) NOT NULL,
  district    INTEGER NOT NULL,
  start_date  DATE NOT NULL,
  party       VARCHAR(12) NOT NULL
    CHECK (party IN ('Republican','Democrat','Independent','Other')),
  state_name  VARCHAR(30) NOT NULL,
  CONSTRAINT uq_state_district UNIQUE (state_name, district)
);

CREATE TABLE public.sponsor (
  cong_id  INTEGER NOT NULL,
  bill_id  INTEGER NOT NULL,
  PRIMARY KEY (cong_id, bill_id)
);

CREATE TABLE public.vote (
  cong_id  INTEGER NOT NULL,
  bill_id  INTEGER NOT NULL,
  vote     VARCHAR(7) NOT NULL CHECK (vote IN ('Yes','No','Abstain','Absent')),
  PRIMARY KEY (cong_id, bill_id)
);

ALTER TABLE public.congress_person
  ADD CONSTRAINT congress_person_state_fk FOREIGN KEY (state_name) REFERENCES public.state (state_name);

ALTER TABLE public.sponsor
  ADD CONSTRAINT sponsor_congress_person_fk FOREIGN KEY (cong_id) REFERENCES public.congress_person (cong_id),
  ADD CONSTRAINT sponsor_bill_fk FOREIGN KEY (bill_id) REFERENCES public.bill (bill_id);

ALTER TABLE public.vote
  ADD CONSTRAINT vote_congress_person_fk FOREIGN KEY (cong_id) REFERENCES public.congress_person (cong_id),
  ADD CONSTRAINT vote_bill_fk FOREIGN KEY (bill_id) REFERENCES public.bill (bill_id);