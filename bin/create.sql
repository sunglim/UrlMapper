CREATE TABLE ua_spoof(
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  SITE VARCHAR(255) UNIQUE,
  KIND smallint
  /* 0 = unknown
     1 = sp_mail
     2 = sp_abc
     3 = sp_android
     4 = sp android_m
     5 = sp_ipad
     6 = sp_ipadn
     7 = sp_daum
     8 = sp_digi
     9 = sp_html5
     10 = sp_yahoo
     11 = sp_webtv
  */
);
INSERT INTO ua_spoof (SITE, KIND) values('mail.ru', 1);
INSERT INTO ua_spoof (SITE, KIND) values('abc.es', 2);
INSERT INTO ua_spoof (SITE, KIND) values('abc.es', 3);
SELECT * from ua_spoof;
