CREATE TABLE ua_spoof(
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  SITE VARCHAR(255) UNIQUE,
  KIND VARCHAR(24)
);
INSERT INTO ua_spoof (SITE, KIND) values('mail.ru', "SP_MAIL");
INSERT INTO ua_spoof (SITE, KIND) values('sohu.com', "SP_ANDROID_M");
INSERT INTO ua_spoof (SITE, KIND) values('abc.es', "SP_ABC");
INSERT INTO ua_spoof (SITE, KIND) values('pluzz.francetv.fr', "SP_ABC");
INSERT INTO ua_spoof (SITE, KIND) values('syriatel.sy', "SP_ABC");
SELECT * from ua_spoof;
