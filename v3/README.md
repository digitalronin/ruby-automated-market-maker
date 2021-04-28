# Create counterparties holding balances

Demonstrates how folks gain/lose by trading.

```
$ bin/amm.rb
Pool eth: 10.0, tokens: 1000.0

> Alice buy 1
Alice gets 90.90909090909088 tokens for 1.0 ether, price 0.0110
Pool eth: 11.0, tokens: 909.0909090909091

> Bob buy 1
Bob gets 75.75757575757575 tokens for 1.0 ether, price 0.0132
Pool eth: 12.0, tokens: 833.3333333333334

> Alice sell all
Alice gets 1.1803278688524586 ether for 90.90909090909088 tokens, price 0.0130
Pool eth: 10.819672131147541, tokens: 924.2424242424242

> Bob sell all
Bob gets 0.8196721311475414 ether for 75.75757575757575 tokens, price 0.0108
Pool eth: 10.0, tokens: 1000.0

> counterparties
Alice   ether: 10.1803, tokens: 0.0000
Bob     ether: 9.8197,  tokens: 0.0000
```
