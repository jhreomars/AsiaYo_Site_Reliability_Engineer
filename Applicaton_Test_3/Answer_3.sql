SELECT c.class 
FROM score s 
JOIN class c ON s.name = c.name 
WHERE s.score = (
    SELECT DISTINCT score 
    FROM score 
    ORDER BY score DESC 
    LIMIT 1 OFFSET 1
);