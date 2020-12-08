DECLARE
    v_total_points   NUMBER := 0;
    v_gr_cnt         NUMBER := 0;
    v_same_cnt       NUMBER := 0;
    v_string         VARCHAR(4000);
    alpha            VARCHAR2(50) := 'abcdefghijklmnopqrstuvwxyz';
    TYPE t_main_arr IS
        TABLE OF NUMBER INDEX BY VARCHAR2(1);
    v_m              t_main_arr;
    v_c              t_main_arr;
    l_idx    varchar2(20);
BEGIN
    FOR j IN 1..length(alpha) LOOP v_m(substr(alpha, j, 1)) := 0;
    END LOOP;

    FOR i IN (
        SELECT
            *
        FROM
            flight_form
    ) LOOP
        SELECT
            regexp_count(i.group_answers, '#', 1, 'i')
        INTO v_gr_cnt
        FROM
            dual;
        v_c := v_m;
        v_string := replace(i.group_answers, '#');

        for x in 1.. length(v_string) loop
          v_c(substr(v_string,x,1)) := v_c(substr(v_string,x,1)) + 1;
        end loop;

        l_idx := v_c.first;
        while (l_idx is not null) loop
         if v_c(l_idx) = v_gr_cnt THEN
           dbms_output.put_line( ' String: '||v_c(l_idx)||' '||v_gr_cnt);
           v_total_points := v_total_points + 1;
         end if;
        l_idx := v_c.next(l_idx); 
        end loop;
    END LOOP;

    dbms_output.put_line(v_total_points);
END;
