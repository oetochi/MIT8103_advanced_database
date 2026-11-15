# Portfolio 3 Transactions Currency

The important lesson here is that the failed UPDATE only cancels itself. The earlier INSERTs stay pending until I issued ROLLBACK. Without it, I would have had a order with a corresponding in stock further buttressing the atomicity behaviour of the database.

This portfolio is divided into 4 parts

1. Part A: commit
2. Part B: rollback
3. Part C: Review a concurrency problem, then it's fix
Scenario: Two customers want to buy 6bags each, but only 10 are in stock.
4. Part D: Isolation levels. What one session sees of another’s uncommitted work

#### Part C: Review concurrency problem and its fix

To set up this experiment, I used two Terminal windows (refer to `Part C - Run 1 screenshot`) called S1 & S2


Before running the functions below following the exact order below, first run this bash command

`mysql -u root -p` (to gain access to the sql server from the terminal)

Run1: The statements I used.
|Step|	Window|	Statement|
|----|--------|-----------|
|1|	S1|	START| TRANSACTION;|
|2|	S1| SELECT stock_qty FROM products WHERE sku='TXN-TEST-1'; (#shows 10)|
|3| S2|	START TRANSACTION;|
|4|	S2|	SELECT stock_qty FROM products WHERE sku='TXN-TEST-1'; (also shows 10)|
|5|	S1|	UPDATE products SET stock_qty = 10 - 6 WHERE sku='TXN-TEST-1';|
|6|	S2|	UPDATE products SET stock_qty = 10 - 6 WHERE sku='TXN-TEST-1'; (this will hang; S1 holds the row lock)|
|7|	S1|	COMMIT; (S2’s update now goes through)|
|8|	S2|	COMMIT;|
|9|	|either	SELECT stock_qty FROM products WHERE sku='TXN-TEST-1';|

The `Run 1` shows a problem - lost update, depicting typical careless app behavious which is to read stock, calculate the new value by itself and then writes it back. By the end of step 9, stock count is at 4 but 12 bags were sold from a total balance of 10. The main reason is because `S2` didn't see `S1's` change largely because it calculated from it's stale read of 10 (gotten from step 4 statement above). This behavious is the `lost update` anomaly. `"The lost update problem is a concurrency issue that arises when multiple processes or threads concurrently access and modify the same data, resulting in some updates unintentionally overwriting others. This problem is significant in any system where concurrent modifications are possible, such as collaborative applications, financial systems, or any scenario involving shared resources." (source: https://www.baeldung.com/cs/concurrency-control-lost-update-problem)`

In Run 2, I gave the control mechanism that guarantees distributed truth. In the screenshot: `Run_2_select_update_demo.png`, I highlighted a hang `'lock wait timeout exceeded'` error message for S2 as it's expecting update from S1 (step 6).

|Step|	Window|	Statement|
|----|--------|----------|
|1	|S1	|START TRANSACTION;|
|2	|S1	|SELECT stock_qty FROM products WHERE sku='TXN-TEST-1' FOR UPDATE; (10)|
|3	|S2	|START TRANSACTION;|
|4	|S2	|SELECT stock_qty FROM products WHERE sku='TXN-TEST-1' FOR UPDATE; (hangs: S1 holds the lock)|
|5	|S1	|UPDATE products SET stock_qty = stock_qty - 6 WHERE sku='TXN-TEST-1';
|6	|S1	|COMMIT; (S2’s SELECT now returns)|
|7	|S2	|S2's SELECT shows 4, which is correct. S2 can see that 6 bags aren’t available. Run ROLLBACK;|
| |



#### Part D: Isolation levels
Just like part C work, this one here also uses two terminals to run the `sql` sripts.

In this session, my goal is to demo three isolation levels: `READ UNCOMMITTED`, `READ COMMITETED` and `REPEATABLE READ`

Advice: first run `05_part_d.sql` before switching to your Terminal (2 windows) to complete the demos below.

`D1: Dirty Commit`

|Step	|Window	|Statement|
|-------|-------|---------|
|1	|S2	|SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;|
|2	|S2	|START TRANSACTION;|
|3	|S1	|START TRANSACTION;|
|4	|S1	|UPDATE products SET stock_qty = 3 WHERE sku='TXN-TEST-1'; #(don't commit yet)|
|5	|S2	|SELECT stock_qty FROM products WHERE sku='TXN-TEST-1'; #shows 3 (ref. `d1` screenshot), a value that was never committed|
|6	|S1	|ROLLBACK;|
|7	|S2	|Repeat the SELECT. It’s back to 10, so S2 acted on data that never officially existed. Then COMMIT;|
| |

Danger of `dirty read` for Topez Farms is that a buyer might see that stock exists whereas it is not because it was never actually committed.


`D2: non-repeatable read`

|Step	|Window	|Statement|
|-------|-------|---------|
|1	|S2	|`SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;`|
|2	|S2	|`START TRANSACTION;` then `SELECT stock_qty ...;` (10)|
|3	|S1	|`UPDATE products SET stock_qty = 7 WHERE sku='TXN-TEST-1';` (autocommit commits it)|
|4	|S2	|Repeat the `SELECT:...;` Noticed how the same query in the same transaction gave a different answer - '7'? Then COMMIT;

For Topez Farms, the problem with non-repeatable read is that it'll lead to data inconsistency, for example, in checkout flow.


`D3: repeatable read`

Reset the stock to 10 in S1 first.

|Step  |Window	|Statement|
|------|-------|---------|
|1	|S2	|SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;|
|2	|S2	|START TRANSACTION; then SELECT stock_qty ...; (stock count is 10)|
|3	|S1	|UPDATE products SET stock_qty = 7 WHERE sku='TXN-TEST-1';|
|4	|S2	|Repeat the SELECT: (quantity still remains 10)|
|5	|S2	|COMMIT; then SELECT again: now 7|

