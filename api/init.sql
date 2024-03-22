CREATE TABLE USERS (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  password VARCHAR(100)
);

CREATE TABLE gift (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description VARCHAR(100),
    text VARCHAR(100),
    image VARCHAR(100),
    video VARCHAR(100),
    music VARCHAR(100)
);
