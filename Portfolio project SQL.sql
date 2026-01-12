
1.who is the seniour most employee based on job title ??
Answer :-select * from employee
        order by levels desc
		limit 1;

----Explanation:-(where we need to check seniour most employee for that,we need to check the)
----------------------------------------------------------------------------------------------------------
2.Which countries have the most invoice ??
A.
  select billing_country, count(total) as highest_count
  from invoice 
  group by billing_country
  order by highest_count desc
  limit  1;
Explnanation:-
----------------------------------------------------------------------------------------------------------
3.What are top 3 values of total invoice ??
A.
  select  total from invoice
  order by total desc
  limit 3;
  Explanation :-
-------------------------------------------------------------------------------------------------------------
4.Which city has the best customers? we would like to throw a promotional music festival in the city
we made the most money . write a query that returns one city that has the highest sum of invoice totals.
return both the city name & sum of all invoice totals ??
A.

 select  sum(total)as invoice_Total, billing_city
 from invoice
 group by billing_city
 order by invoice_Total desc ;
 
Explanation :-
  
-------------------------------------------------------------------------------------------------------------
5.Who is the best customer ? The customer who has spent the most money will be declared the best customer.
write a query that returns the person who has spent the most money ??
A.
  select  c.customer_id,c.first_name , c.last_name, sum(invoice.total)as total
  from customer 
  join invoice
  on customer.customer_id = invoice.customer_id
  group by c.customer_id
  order by total desc
  limit 1;
  Explnation :-
  
-----------------------------------------------------------------------------------------------------------------
--Moderate type----
1.Write a query to return the email, first name & genre of all Rock music listeners .Return 
your list ordered alphabetically by email starting with A ??
A.
Part-1 :-
  select email,first_name
  from customer
  join invoice
  on invoice.customer_id = customer.customer_id
  join invoiceline
  on invoiceline.invoice_id = invoice.invoice_id
  where track_id (select track_id from track
                 join genre on track.genre_id = genre.genre_id
				 where genre like 'Rock'
  )
  order by email;

Part-2 :-
   select distinct email as Email, first_name as FirstName ,last_name as LastName ,genre.name as Name 
   from customer 
   join invoice on invoice.customer_id = customer.customer_id
   join invoiceline on invoiceline.invoice_id = invoice.invoice_id
   join track on track.track_id = invoice_line.track_id
   join genre on genre.genre_id = track.genre_id 
   where genre.name like 'Rock'
   order by email;
  Explanation :-
---------------------------------------------------------------------------------------------------------------
2. Let's invite the artists who have written the most rock music in our dataset . write a query 
that returns the artist name and total track count of the top 10 rock bands ??
A.
  select artist.artist_id , artist.artist_name, count(artist.artist_id)as number_of_songs
  from track
  join album 
  on album.album_id = track.album_id
  join artist
  on genre.genre_id = track.genre_id
  where genre.name like 'Rock'
  group by artist.artist_id
  order by number_of_songs desc
  limit 10;
  Explnation:-
 ------------------------------------------------------------------------------------------------------
 3.Return all the track names that have a song length longer than the average song length.
 Return the name and milliseconds for each track.Order by the song length with the longest 
 songs listed first ???
 A.
part:-1 select name , avg(milliseconds)as Milliseconds
  from track
  group by name
  order by milliseconds desc;

 ---------- orelse ------

 part-2:- select name, milliseconds
  from track
  where milliseconds >(select avg(milliseconds)as avg_track_length from track)
  order by milliseconds desc;
  
Explanation :-
----------------------------------------------------------------------------------------------------
----Advance-level ----
1.Find how much mount spent by each customer on artists ? write a query to return customer 
name , artist name and total spent ??
A.
   with best_selling_artist as (
               select artist.artist_id as artist_id , artist.name as artist_name,
			   sum(invoice_line.unit_price * invoice_line.quantity) as total_sales
			   from invoice_line 
			   join track on track.track_id =invoice_line.track_id
			   join album on album.album_id = track.album_id 
			   join artist on artist.artist_id = album.artist_id 
			   group by 1
			   order by 3 desc
			   limit 1
			   )
                select c.customer_id,c.first_name,c.last_name, bsa.artist_name,
				sum(il.unit_price*il.quantity)as amount_spent 
				from invoice i
				join customer c on c.customer_id = i.customer_id 
				join invoice_line il on il.invoice_id = c.invoice_id
				join track t on t.track_id = il.track_id 
				join album al on al.album_id = t.album_id
				join best_selling_artist bsa on bsa.artist_id = alb.artist_id 
				group by 1,2,3,4
				order by 5 desc ;
Explnation :-
    Part-1:-  we use a CTE to make a temporary set, by using cte syntax 
              we use sub-query for temporary set, we want to artist artist id and artist name and total from invoice table
			  so for  that we need to joins the table beacuse we are having data from different tables)
			  spent --- (for total spent we  need  to use a artist table for that 
			  ----(invoice_line.unit_price * invoice_line.quantity)with sum operation 
			  by using invoice_line table we join the tables by using alias 
			  invoice_line(invoice_line)-->>Track(Track_id)-->>album(album_id)-->>artist(artist_id)
			  by joining the tables we use 
			  1 as a artist_id
			  2 as a artist_name
			  3 as a total_sales
			  we use group by 1 and by order by 3 with desc -- with limit 1
			  and by closing bracket we close a sub-query.

	Part-2 :- By using customer as alias we use 'c' and 'bse'- as best_selling_artist
	          c.customer_id,c.first_name,c.last_name, bsa.artist_name,and amount_spent
			  by  invoice by using we join the tables 
			  invoice(customer_id)-->>customer(customer_id)-->>from invoice(invoice_id)
               -->invoiceline(track_id))-->>track_id(album_id)-->>album(artist_id)-->>
			   we used an artist table as (bte )best_selling_artist, so we use bte with album_id 
			   and by group by 1,2,3,4,5 and with order by 5 desc and we run..
--------------------------------------------------------------------------------------------------------------			   
2.we want to find out the most popular music genre for each country. 
we determine the most popular genre as the genre with the highest amount of purchases.
write a query that returns each country along with the top genre .
for countries which the maxmium number of purhases is shared return all genres.??
A.
Method-1:-

  with popular_genre as (
          select count(invoice_line.quantity)as purchases, customer.country, genre.name,genre_id,
		  ROW_number()OVER PARTITION BY customer.country ORDER BY COUNT (invoice_line.quantity)desc)as rowno
		  from invoice_line 
		  join invoice on invoice.invoice_id = invoice_line.invoice_id
		  join customer on customer.customer_id = invoice_customer_id
		  join track on track.track_id = invoice_line.track_id
		  join genre on genre.genre_id = track.genre_id
		  group by 2,3,4
		  order by 2 asc, 1 desc
		  )
		  select * from popular_genre where rowno <=1
  )

------------------------------------------------------------------------------------------------------

































