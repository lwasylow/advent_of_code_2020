WITH prnt AS (
    SELECT
        regexp_substr(rule_in_plain, '^(.*) bags contain (.*)\.$', 1, 1, NULL, 1) parent_bag,
        regexp_substr(rule_in_plain, '^(.*) bags contain (.*)\.$', 1, 1, NULL, 2) chld
    FROM
        baggage
), tree AS (
    SELECT
        regexp_substr(TRIM(column_value), '^(\d+) (.*?) bags?$',1, 1, NULL, 1) child_cnt,
        regexp_substr(TRIM(column_value), '^(\d+) (.*?) bags?$', 1, 1, NULL, 2) bag,
        parent_bag
FROM
        prnt,
        xmltable ( ( '"'
                     || replace(chld, ',', '","')
                     || '"' ) )
), cte (
    lvl,
    bag,
    parent_bag,
    child_cnt,
    total_cnt
) AS ( SELECT
           1,
           bag,
           parent_bag,
           child_cnt,
           to_number(child_cnt) child_cnt
       FROM
           tree
       WHERE
           parent_bag = 'shiny gold'
       UNION ALL
       SELECT
           r.lvl + 1,
           d.bag,
           d.parent_bag,
           d.child_cnt,
           round(d.child_cnt * r.total_cnt, 1)
       FROM
           tree d
       INNER JOIN cte r
       ON d.parent_bag = r.bag
       WHERE d.parent_bag IS NOT NULL
       )
       SELECT sum(total_cnt) FROM cte;
       
