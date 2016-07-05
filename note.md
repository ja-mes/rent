Option 1
========
Schedule job in future to increment balance for customer

**cons**
 - requires large number of background jobs
 - if job fails then balance past due balance will be wrong


Option 2
=======
Calculate customer balance when the record is found

**cons**
- difficult to calculate
- will make records load slower


*begin implementation of option 1*
