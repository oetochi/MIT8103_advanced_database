#D3: repeatable read (the default)
#Run this in two windows Terminal or PowerShell. Refer to the README for more details
#Reset the stock to 10 in S1 first.

#Step	Window	Statement
#1	S2	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
#2	S2	START TRANSACTION; then SELECT stock_qty ...; (10)
#3	S1	UPDATE products SET stock_qty = 7 WHERE sku='TXN-TEST-1';
#4	S2	Repeat the SELECT: still 10
#5	S2	COMMIT; then SELECT again: now 7