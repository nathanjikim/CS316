SELECT Frequents.drinker FROM Frequents, Likes WHERE Frequents.drinker=Likes.drinker AND Likes.beer = 'Corona' AND bar = 'James Joyce Pub' AND times_a_week >= 2;