--comparatie tablou indexat - tablou imbricat - vector

DECLARE
    TYPE tab_ind IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    i                   PLS_INTEGER;
    t tab_ind;
    timp_start          PLS_INTEGER;
    timp_atribuiri      PLS_INTEGER;
    timp_count          PLS_INTEGER;
    timp_loop_1         PLS_INTEGER;
    timp_delete_elem    PLS_INTEGER;
    timp_loop_3         PLS_INTEGER;
    timp_metode         PLS_INTEGER;
    timp_delete_obj     PLS_INTEGER;
    timp_while          PLS_INTEGER;
BEGIN
    -- atribuire valori
    timp_start := DBMS_UTILITY.GET_TIME;
    FOR i IN 1..2000000 LOOP
        t(i):=i;
    END LOOP;
    timp_atribuiri := DBMS_UTILITY.GET_TIME;
    
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
    timp_count := DBMS_UTILITY.GET_TIME;
    
    --atribui null valorilor de pe pozitii impare
    FOR i IN 1..2000000 LOOP
        IF i mod 2 = 1 THEN t(i):= NULL;
        END IF;
    END LOOP;
    timp_loop_1 := DBMS_UTILITY.GET_TIME;
    
    --sterg elementele de pe pozitii pare
    FOR i IN t.first..t.last LOOP
        if i mod 2 = 0 THEN t.DELETE(i);
        END IF;
    END LOOP;
    timp_delete_elem := DBMS_UTILITY.GET_TIME;
    
    --apelez diverse metode...
    DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first || ' si valoarea ' || nvl(t(t.first),0));
    DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last || ' si valoarea ' || nvl(t(t.last),0));
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT || ' elemente: ');
    timp_metode := DBMS_UTILITY.GET_TIME;
    
    --ciclare cu for
    FOR i IN t.FIRST..t.LAST LOOP
        IF t.EXISTS(i) THEN
            t(i) := t(i) + 1;
        END IF;
    END LOOP;
    timp_loop_3 := DBMS_UTILITY.GET_TIME;
    
    --ciclare cu while
    i := t.FIRST;
    WHILE i IS NOT NULL LOOP
        t(i) := t(i) - 1;
        i := t.NEXT(i);
    END LOOP;
    timp_while := DBMS_UTILITY.GET_TIME;
    
    --stergere colectie (dealocare memorie)
    t.DELETE;
    timp_delete_obj := DBMS_UTILITY.GET_TIME;
    
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('----------INDEX-BY TABLE--------------');
    DBMS_OUTPUT.PUT_LINE('Atribuiri: ' || (timp_atribuiri - timp_start) || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('Apel count: ' || (timp_count - timp_atribuiri) || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('FOR...LOOP - modificari date: ' || (timp_loop_1 - timp_count)  || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('Stergere elemente: ' || (timp_delete_elem - timp_loop_1)  || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('Apel metode: ' || (timp_metode - timp_delete_elem)  || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('FOR...LOOP + exists: ' || (timp_loop_3 - timp_metode) || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('WHILE...LOOP + next: ' || (timp_while - timp_loop_3) || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('Stergere colectie: ' || (timp_delete_obj - timp_loop_3)  || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');    
END;
/


DECLARE
    TYPE tab_imb IS TABLE OF NUMBER;
    i                   PLS_INTEGER;
    t tab_imb           := tab_imb();
    timp_start          PLS_INTEGER;
    timp_atribuiri      PLS_INTEGER;
    timp_count          PLS_INTEGER;
    timp_loop_1         PLS_INTEGER;
    timp_delete_elem    PLS_INTEGER;
    timp_loop_3         PLS_INTEGER;
    timp_metode         PLS_INTEGER;
    timp_delete_obj     PLS_INTEGER;
    timp_while          PLS_INTEGER;
BEGIN
    -- atribuire valori
    timp_start := DBMS_UTILITY.GET_TIME;
    FOR i IN 1..2000000 LOOP
        t.extend;
        t(i):=i;
    END LOOP;
    timp_atribuiri := DBMS_UTILITY.GET_TIME;
    
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
    timp_count := DBMS_UTILITY.GET_TIME;
    
    FOR i IN 1..2000000 LOOP
        IF i mod 2 = 1 THEN t(i):= NULL;
        END IF;
    END LOOP;
    timp_loop_1 := DBMS_UTILITY.GET_TIME;
    
    
    FOR i IN t.first..t.last LOOP
        IF i mod 2 = 0 THEN t.DELETE(i);
        END IF;
    END LOOP;
    timp_delete_elem := DBMS_UTILITY.GET_TIME;
    
    DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first || ' si valoarea ' || nvl(t(t.first),0));
    DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last || ' si valoarea ' || nvl(t(t.last),0));
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT || ' elemente: ');
    timp_metode := DBMS_UTILITY.GET_TIME;
    
    FOR i IN t.FIRST..t.LAST LOOP
        IF t.EXISTS(i) THEN
            t(i) := t(i) + 1;
        END IF;
    END LOOP;
    timp_loop_3 := DBMS_UTILITY.GET_TIME;
    
    i := t.FIRST;
    WHILE i IS NOT NULL LOOP
        t(i) := t(i) - 1;
        i := t.NEXT(i);
    END LOOP;
    timp_while := DBMS_UTILITY.GET_TIME;
    
    t.DELETE;
    timp_delete_obj := DBMS_UTILITY.GET_TIME;
    
    
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('----------NESTED TABLE--------------');
    DBMS_OUTPUT.PUT_LINE('Atribuiri: ' || (timp_atribuiri - timp_start) || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('Apel count: ' || (timp_count - timp_atribuiri) || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('FOR...LOOP - modificari date: ' || (timp_loop_1 - timp_count)  || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('Stergere elemente: ' || (timp_delete_elem - timp_loop_1)  || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('Apel metode: ' || (timp_metode - timp_delete_elem)  || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('FOR...LOOP + exists: ' || (timp_loop_3 - timp_metode) || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('WHILE...LOOP + next: ' || (timp_while - timp_loop_3) || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('Stergere colectie: ' || (timp_delete_obj - timp_loop_3)  || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');    
END;
/




DECLARE
    TYPE vect IS VARRAY(2000000) OF NUMBER;
    i                   PLS_INTEGER;
    t vect              := vect();
    timp_start          PLS_INTEGER;
    timp_atribuiri      PLS_INTEGER;
    timp_count          PLS_INTEGER;
    timp_loop_1         PLS_INTEGER;
    timp_loop_3         PLS_INTEGER;
    timp_metode         PLS_INTEGER;
    timp_delete_obj     PLS_INTEGER;
    timp_while          PLS_INTEGER;
BEGIN
    -- atribuire valori
    timp_start := DBMS_UTILITY.GET_TIME;
    FOR i IN 1..2000000 LOOP
        t.extend;
        t(i):=i;
    END LOOP;
    timp_atribuiri := DBMS_UTILITY.GET_TIME;
    
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
    timp_count := DBMS_UTILITY.GET_TIME;
    
    FOR i IN 1..2000000 LOOP
        IF i mod 2 = 1 THEN t(i):= NULL;
        END IF;
    END LOOP;
    timp_loop_1 := DBMS_UTILITY.GET_TIME;
    
    DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first || ' si valoarea ' || nvl(t(t.first),0));
    DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last || ' si valoarea ' || nvl(t(t.last),0));
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT || ' elemente: ');
    timp_metode := DBMS_UTILITY.GET_TIME;
    
    FOR i IN t.FIRST..t.LAST LOOP
        IF t.EXISTS(i) THEN
            t(i) := t(i) + 1;
        END IF;
    END LOOP;
    timp_loop_3 := DBMS_UTILITY.GET_TIME;
    
    i := t.FIRST;
    WHILE i IS NOT NULL LOOP
        t(i) := t(i) - 1;
        i := t.NEXT(i);
    END LOOP;
    timp_while := DBMS_UTILITY.GET_TIME;
    
    t.DELETE;
    timp_delete_obj := DBMS_UTILITY.GET_TIME;
     
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('----------VARRAYS--------------');
    DBMS_OUTPUT.PUT_LINE('Atribuiri: ' || (timp_atribuiri - timp_start) || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('Apel count: ' || (timp_count - timp_atribuiri) || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('FOR...LOOP - modificari date: ' || (timp_loop_1 - timp_count)  || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('Apel metode: ' || (timp_metode - timp_loop_1)  || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('FOR...LOOP + exists: ' || (timp_loop_3 - timp_metode) || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('WHILE...LOOP + next: ' || (timp_while - timp_loop_3) || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('Stergere colectie: ' || (timp_delete_obj - timp_loop_3)  || ' sutimi de secunda');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');    
END;
/



--4.18
DECLARE
    TYPE t_imb IS TABLE OF NUMBER(2);
    t t_imb := t_imb();
    t1 t_imb := t_imb(1,2,1,3,3);
    t2 t_imb := t_imb(1,2,4,2,1);
    t3 t_imb := t_imb(1,2,4);
    t4 t_imb := t_imb(1,2,4);
    t5 t_imb := t_imb(1,2);
BEGIN
    -- IS EMPTY
    IF t IS EMPTY THEN
        DBMS_OUTPUT.PUT_LINE('t nu are elemente');
    END IF;
    -- CARDINALITY
    DBMS_OUTPUT.PUT('t1 are '|| CARDINALITY(t1) || ' elemente: ');
    
    FOR i IN 1..t1.LAST LOOP
        DBMS_OUTPUT.PUT(t1(i)||' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
    DBMS_OUTPUT.PUT('t2 are '|| CARDINALITY(t2) ||' elemente: ');
    FOR i IN 1..t2.LAST LOOP
        DBMS_OUTPUT.PUT(t2(i)||' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
    -- SET
    t:= SET(t1);
    DBMS_OUTPUT.PUT('t1 fara duplicate: ');
    FOR i IN 1..t.LAST LOOP
        DBMS_OUTPUT.PUT(t(i)||' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
    -- MULTISET EXCEPT ALL
    t := t1 MULTISET EXCEPT ALL t2;
    DBMS_OUTPUT.PUT('(MULTISET EXCEPT ALL) t1 minus t2: ');
    FOR i IN 1..t.LAST LOOP
        DBMS_OUTPUT.PUT(t(i)||' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
     -- MULTISET EXCEPT (DISTINCT)
    t := t1 MULTISET EXCEPT DISTINCT t2;
    DBMS_OUTPUT.PUT('(MULTISET EXCEPT DISTINCT)t1 minus t2: ');
    FOR i IN 1..t.LAST LOOP
        DBMS_OUTPUT.PUT(t(i)||' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
    -- MULTISET UNION ALL
    DBMS_OUTPUT.PUT('t1 union all t2: ');
    t := t1 MULTISET UNION ALL t2;
    FOR i IN 1..t.LAST LOOP
        DBMS_OUTPUT.PUT(t(i)||' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
    -- MULTISET UNION DISTINCT
    DBMS_OUTPUT.PUT('t1 union distinct t2: ');
    t := t1 MULTISET UNION DISTINCT t2;
    FOR i IN 1..t.LAST LOOP
        DBMS_OUTPUT.PUT(t(i)||' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
    -- MULTISET INSERSECT ALL
    t := t1 MULTISET INTERSECT ALL t2;
    DBMS_OUTPUT.PUT('t1 intersect all t2 : ');
    FOR i IN 1..t.LAST LOOP
        DBMS_OUTPUT.PUT(t(i)||' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
    -- MULTISET INSERSECT DISTINCT
    t := t1 MULTISET INTERSECT DISTINCT t2;
    DBMS_OUTPUT.PUT('t1 intersect distinct t2 : ');
    FOR i IN 1..t.LAST LOOP
        DBMS_OUTPUT.PUT(t(i)||' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
    -- test egalitate
    IF t2 = t3 THEN DBMS_OUTPUT.PUT_LINE('t2 = t3');
    ELSE DBMS_OUTPUT.PUT_LINE('t2 <> t3');
    END IF;
    
    IF t3 = t4 THEN DBMS_OUTPUT.PUT_LINE('t3 = t4');
    ELSE DBMS_OUTPUT.PUT_LINE('t3 <> t4');
    END IF;
    
    -- IN
    IF t4 IN (t1,t2,t3) THEN DBMS_OUTPUT.PUT_LINE('t4 in (t1,t2,t3)');
    ELSE DBMS_OUTPUT.PUT_LINE('t4 not in (t1,t2,t3)'); 
    END IF;
    
    -- IS A SET
    IF t4 IS A SET THEN DBMS_OUTPUT.PUT_LINE('t4 este multime');
    ELSE DBMS_OUTPUT.PUT_LINE('t4 nu este multime');
    END IF;
    
    -- MEMBER OF
    IF 2 MEMBER OF t4 THEN DBMS_OUTPUT.PUT_LINE('2 este in t4');
    ELSE DBMS_OUTPUT.PUT_LINE('2 nu este in t4');
    END IF;
    
    -- SUBMULTISET OF
    IF t5 SUBMULTISET OF t4 THEN DBMS_OUTPUT.PUT_LINE('t5 este inclus in t4');
    ELSE DBMS_OUTPUT.PUT_LINE('t5 nu este inclus in t4');
    END IF;
END;
/


