#D2: non-repeatable read
#Run this in two windows Terminal or PowerShell. Refer to the README for more details

#Step	Window	Statement
#1	S2	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
#2	S2	START TRANSACTION; then SELECT stock_qty ...; (10)
#3	S1	UPDATE products SET stock_qty = 7 WHERE sku='TXN-TEST-1'; (autocommit commits it)
#4	S2	Repeat the SELECT: 7. Then COMMIT;