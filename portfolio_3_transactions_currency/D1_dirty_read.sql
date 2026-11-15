#Demo_1: READ UNCOMMITTED
#Run this in two windows Terminal or PowerShell. Refer to the README for more details

#Step	Window	Statement
#1	S2	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
#2	S2	START TRANSACTION;
#3	S1	START TRANSACTION;
#4	S1	UPDATE products SET stock_qty = 3 WHERE sku='TXN-TEST-1'; (do not commit)
#5	S2	SELECT stock_qty FROM products WHERE sku='TXN-TEST-1'; shows 3, a value that was never committed
#6	S1	ROLLBACK;
#7	S2	Repeat the SELECT. It’s back to 10, so S2 acted on data that never officially existed. Then COMMIT;