CREATE TABLE touch_sites (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  SITE VARCHAR(24) UNIQUE
);

INSERT INTO touch_sites(SITE) values('youku.com');
SELECT * from touch_sites;
