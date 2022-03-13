SELECT thing2.name, thing2.sum, thing3.min, thing3.max FROM (SELECT Bar.name, thing1.sum FROM Bar LEFT OUTER JOIN (SELECT bar, SUM(times_a_week) FROM Frequents GROUP BY bar) AS thing1 ON Bar.name = thing1.bar) AS thing2 LEFT OUTER JOIN (SELECT bar, MIN(price), MAX(price) FROM Serves GROUP BY bar) AS thing3 ON thing2.name = thing3.bar ORDER BY thing2.sum DESC NULLS LAST, thing2.name ASC NULLS LAST;


