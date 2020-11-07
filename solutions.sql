/* challenge 1 */
DROP TABLE temp_table
CREATE TEMPORARY TABLE IF NOT EXISTS temp_table (
SELECT AUTHORS.au_id , titles.title_id, (titleauthor.royaltyper/100)*(royalty/100)*price*qty AS sales_royalty, titleauthor.royaltyper
FROM AUTHORS
INNER JOIN titleauthor ON AUTHORS.au_id = titleauthor.au_id
INNER JOIN titles ON titles.title_id = titleauthor.title_id
INNER JOIN sales ON titleauthor.title_id = sales.title_id	
ORDER BY AUTHORS.au_id) 

/* challenge 2 & 3 */
CREATE TABLE most_profiting_authors (
SELECT au_id, ROUND(SUM(sales_profit),2) AS profits
FROM (	  
SELECT  au_id, sub_q.title_id, sales_royalty+(advance*royaltyper/100) AS sales_profit
FROM (
SELECT au_id, title_id, ROUND(SUM(sales_royalty),2) AS sales_royalty,royaltyper
FROM temp_table
GROUP BY au_id, title_id
ORDER BY au_id) AS sub_q
INNER JOIN titles ON titles.title_id = sub_q.title_id) sub_q2
GROUP BY au_id
ORDER BY profits DESC
)

      			