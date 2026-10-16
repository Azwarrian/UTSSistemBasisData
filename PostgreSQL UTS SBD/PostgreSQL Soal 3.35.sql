-- Exercise Azwar Riansyah 1251420090 --
Soal 3.35
DROP TABLE IF EXISTS seat_reservation, leg_instance, flight_leg, fare, flight,
                     airplane, can_land, airplane_type, airport CASCADE;

CREATE TABLE airport (
  airport_code  VARCHAR(10)  PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  city          VARCHAR(60)  NOT NULL,
  state         VARCHAR(60)  NOT NULL
);

CREATE TABLE airplane_type (
  type_name  VARCHAR(30) PRIMARY KEY,
  max_seats  INTEGER NOT NULL CHECK (max_seats > 0),
  company    VARCHAR(60) NOT NULL
);

CREATE TABLE can_land (
  type_name     VARCHAR(30) NOT NULL REFERENCES airplane_type (type_name),
  airport_code  VARCHAR(10) NOT NULL REFERENCES airport (airport_code),
  PRIMARY KEY (type_name, airport_code)
);

CREATE TABLE airplane (
  airplane_id  INTEGER PRIMARY KEY,
  total_seats  INTEGER NOT NULL CHECK (total_seats > 0),
  type_name    VARCHAR(30) NOT NULL REFERENCES airplane_type (type_name)
);

CREATE TABLE flight (
  flight_id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  flight_number  VARCHAR(10) NOT NULL UNIQUE,
  airline        VARCHAR(60) NOT NULL,
  weekdays       VARCHAR(20) NOT NULL
);

CREATE TABLE fare (
  flight_id     INTEGER NOT NULL REFERENCES flight (flight_id),
  fare_code     VARCHAR(10) NOT NULL,
  amount        NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
  restrictions  VARCHAR(200),
  PRIMARY KEY (flight_id, fare_code)
);

CREATE TABLE flight_leg (
  flight_leg_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  flight_id       INTEGER NOT NULL REFERENCES flight (flight_id),
  leg_no          INTEGER NOT NULL,
  dep_airport     VARCHAR(10) NOT NULL REFERENCES airport (airport_code),
  sched_dep_time  TIME NOT NULL,
  arr_airport     VARCHAR(10) NOT NULL REFERENCES airport (airport_code),
  sched_arr_time  TIME NOT NULL,
  CONSTRAINT uq_flight_leg UNIQUE (flight_id, leg_no)
);

CREATE TABLE leg_instance (
  leg_instance_id  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  flight_leg_id    INTEGER NOT NULL REFERENCES flight_leg (flight_leg_id),
  leg_date         DATE NOT NULL,
  avail_seats      INTEGER NOT NULL CHECK (avail_seats >= 0),
  airplane_id      INTEGER NOT NULL REFERENCES airplane (airplane_id),
  dep_airport      VARCHAR(10) NOT NULL REFERENCES airport (airport_code),
  dep_time         TIME NOT NULL,
  arr_airport      VARCHAR(10) NOT NULL REFERENCES airport (airport_code),
  arr_time         TIME,
  CONSTRAINT uq_leg_instance UNIQUE (flight_leg_id, leg_date)
);

CREATE TABLE seat_reservation (
  leg_instance_id  INTEGER NOT NULL REFERENCES leg_instance (leg_instance_id),
  seat_no          VARCHAR(5) NOT NULL,
  customer_name    VARCHAR(80) NOT NULL,
  customer_phone   VARCHAR(20) NOT NULL,
  PRIMARY KEY (leg_instance_id, seat_no)
);