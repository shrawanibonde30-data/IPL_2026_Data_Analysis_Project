-- 1. Create Database
CREATE DATABASE IPL2026;

-- 2. Select Database
USE IPL2026;

-- 3. Total Records in Ball-by-Ball Dataset
SELECT COUNT(*) FROM ipl_cleaned_final;

-- 4. Preview Ball-by-Ball Dataset
SELECT * FROM ipl_cleaned_final LIMIT 10;

-- 5. Total Records in Matches Dataset
SELECT COUNT(*) FROM matches;

-- 6. Preview Matches Dataset
SELECT * FROM matches LIMIT 10;

-- 7. Team-wise Match Wins
SELECT match_winner,COUNT(*) AS total_wins 
FROM matches
WHERE match_winner IS NOT NULL
GROUP BY match_winner
ORDER BY total_wins DESC;

-- 8. Toss Winner vs Match Winner Analysis
SELECT COUNT(*) AS total_matches,
SUM(CASE
WHEN toss_winner = match_winner
THEN 1
ELSE 0
END) AS toss_and_match_wins
FROM matches WHERE match_winner IS NOT NULL;

-- 9. Matches Played at Each Venue
SELECT venue, COUNT(*) AS total_matches FROM matches
GROUP BY venue
ORDER BY total_matches DESC;

-- 10. Total Runs Scored by Each Team
SELECT batting_team, SUM(total_runs) AS total_team_runs
FROM ipl_cleaned_final
GROUP BY batting_team
ORDER BY total_team_runs DESC;

-- 11. Top 10 Run Scorers
SELECT striker,SUM(runs_of_bat) AS total_runs FROM ipl_cleaned_final
GROUP BY striker
ORDER BY total_runs DESC
LIMIT 10;

-- 12. Top 10 Players by Boundaries (Fours & Sixes)
SELECT striker,
SUM(CASE WHEN runs_of_bat = 4 THEN 1 ELSE 0 END) AS fours,
SUM(CASE WHEN runs_of_bat = 6 THEN 1 ELSE 0 END) AS sixes,
(SUM(CASE WHEN runs_of_bat = 4 THEN 1 ELSE 0 END) +
SUM(CASE WHEN runs_of_bat = 6 THEN 1 ELSE 0 END)) AS total_boundaries
FROM ipl_cleaned_final
GROUP BY striker
ORDER BY total_boundaries DESC
LIMIT 10;

-- 13. Top 10 Players by Sixes
SELECT striker,
SUM(CASE WHEN runs_of_bat = 6 THEN 1 ELSE 0 END) AS sixes
FROM ipl_cleaned_final
GROUP BY striker
ORDER BY sixes DESC
LIMIT 10;

-- 14. Top 10 Wicket-Taking Bowlers
SELECT bowler, COUNT(*) AS wickets
FROM ipl_cleaned_final
WHERE wicket_type IS NOT NULL
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;

-- 15. Highest Team Scores in an Innings
SELECT match_no, batting_team, SUM(total_runs) AS team_score
FROM ipl_cleaned_final
GROUP BY  match_no, batting_team
ORDER BY team_score DESC
LIMIT 10;

-- 16. Lowest Team Scores in an Innings
SELECT match_no, batting_team, SUM(total_runs) AS team_score
FROM ipl_cleaned_final
GROUP BY match_no, batting_team
ORDER BY team_score ASC
LIMIT 10;

-- 17. Total Runs Scored at Each Venue
SELECT m.venue, SUM(d.total_runs) AS total_runs
FROM matches m
JOIN ipl_cleaned_final d
ON m.match_id = d.match_no
GROUP BY m.venue
ORDER BY total_runs DESC;

-- 18. Total Wickets Taken at Each Venue
SELECT m.venue, COUNT(*) AS total_wickets
FROM matches m
JOIN ipl_cleaned_final d
ON m.match_id = d.match_no
WHERE d.wicket_type IS NOT NULL
GROUP BY m.venue
ORDER BY total_wickets DESC;

-- 19. Match Win Type (Runs or Wickets)
SELECT match_id, match_winner,
CASE
WHEN match_winner = team1 AND first_ings_score > second_ings_score THEN 'Won by Runs'
WHEN match_winner = team2 AND second_ings_score > first_ings_score THEN 'Won by Runs'
ELSE 'Won by Wickets'
END AS win_type
FROM matches
WHERE match_winner IS NOT NULL;
