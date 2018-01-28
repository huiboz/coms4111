
select * from mastersmall where playerid = "napolmi01";
select * from appearancessmall where playerid = "napolmi01";


select appearances.playerID,appearances.teamID,appearances.yearID from appearances join
	((select yearID, teamID from appearances where playerid = "napolmi01") as a)
	where appearances.yearID = a.yearID and appearances.teamID = a.teamID and
		appearances.yearID > 2010 and appearances.yearID < 2017 and appearances.playerid != "napolmi01"
	order by appearances.playerID desc;

select * from mastersmall;

/*
select appearances.playerID,appearances.teamID,appearances.yearID from appearances where
	concat(appearances.yearID,appearances.teamID) in
	((select concat(yearID, teamID) from appearances where playerid = "napolmi01"))
	and appearances.yearID > 2010 and appearances.yearID < 2017
	order by appearances.playerID desc;
*/
