--ex. 4
--Câte filme (titluri, respectiv exemplare) au fost împrumutate 
--din cea mai cerut? categorie?

SELECT * FROM rental order by title_id;
--SELECT t.title, r.copy_id, t.category, r.member_id, r.book_date, r.act_ret_date
--FROM rental r
--JOIN TITLE_COPY tc ON r.copy_id = tc.copy_id and r.title_id = tc.title_id
--JOIN TITLE t ON t.title_id = tc.title_id;


SELECT COUNT(DISTINCT t.title), COUNT(r.copy_id)
FROM rental r
JOIN TITLE_COPY tc ON r.copy_id = tc.copy_id and r.title_id = tc.title_id
JOIN TITLE t ON t.title_id = tc.title_id
GROUP BY t.category
    HAVING COUNT(t.category) = 
        (SELECT MAX(COUNT(tt.category))
            FROM title tt
            JOIN rental rr ON rr.title_id = tt.title_id
            GROUP BY tt.category
        );


--ex.5
--Câte exemplare din fiecare film sunt disponibile în prezent?
--(considera?i c? statusul unui exemplar nu este setat, deci nu poate fi utilizat)?
WITH unavailable_copies_by_title AS
    (SELECT  title_id, 
    COALESCE((SELECT COUNT(rr.copy_id) FROM rental rr
                WHERE rr.act_ret_date IS NULL 
                    AND rr.title_id = r.title_id
                GROUP BY rr.title_id), 0)  "nrExemplareNedisponibile"
        FROM rental r
        GROUP BY title_id
        ORDER BY title_id
    )
--SELECT * FROM unavailable_copies_by_title;
SELECT t.title, tc.title_id, COUNT(tc.copy_id) - COALESCE(uc."nrExemplareNedisponibile", 0) 
"Numar exemplare disponibile"
    FROM title_copy tc
        JOIN title t ON t.title_id = tc.title_id
        LEFT JOIN unavailable_copies_by_title uc ON tc.title_id = uc.title_id
    GROUP BY t.title, tc.title_id, uc."nrExemplareNedisponibile"
    ORDER BY title_id;


SELECT * FROM title_copy;

--rezolvarea din fisier:
--SELECT r.title_id, COUNT (r.copy_id)
--FROM rental r 
--WHERE r.act_ret_date IS NOT NULL
--GROUP BY r.title_id;


--ex. 6
--Afi?a?i urm?toarele informa?ii: titlul filmului, num?rul exemplarului, statusul setat ?i statusul corect
SELECT t.title, tc.copy_id, tc.status,
    CASE
        WHEN (t.title_id, tc.copy_id) IN (SELECT title_id, copy_id 
                                            FROM rental 
                                            WHERE act_ret_date IS NULL) 
            THEN 'RENTED'
        WHEN (t.title_id, tc.copy_id) IN (SELECT title_id, copy_id 
                                            FROM rental 
                                            WHERE act_ret_date IS NOT NULL) 
            THEN 'AVAILABLE'
        ELSE tc.status
    END "Status corect"
FROM title t
    JOIN title_copy tc ON t.title_id = tc.title_id;


--ex. 9
WITH filme_per_membru AS
    (SELECT r.member_id, tc.title_id, COUNT(r.title_id) "Numar filme imprumutate"
        FROM title_copy tc
        LEFT JOIN rental r  ON r.title_id = tc.title_id
        GROUP BY r.member_id, tc.title_id
        ORDER BY member_id)
--SELECT * FROM filme_per_membru;
SELECT COALESCE(m.last_name, '-') "Nume", COALESCE(m.first_name, '-') "Prenume", fm.title_id, fm."Numar filme imprumutate"
FROM filme_per_membru fm
    LEFT JOIN member m ON fm.member_id = m.member_id
ORDER BY fm.title_id;


--ex. 11

WITH most_rented AS
(SELECT rr.title_id, rr.copy_id, COUNT(rr.copy_id)             
        FROM rental rr 
        GROUP BY rr.title_id, rr.copy_id
        HAVING COUNT(rr.copy_id) =(SELECT MAX(COUNT(re.copy_id))
                                    FROM rental re 
                                    WHERE rr.title_id = re.title_id 
                                    GROUP BY re.title_id, re.copy_id)
        ORDER BY title_id)
        
SELECT mr.title_id, mr.copy_id, tc.status
FROM most_rented mr 
    JOIN title_copy tc ON mr.title_id = tc.title_id AND mr.copy_id = tc.copy_id;

                                            
                                            
                                            
