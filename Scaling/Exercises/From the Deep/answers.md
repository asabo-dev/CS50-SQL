# From the Deep

## Random Partitioning
Reasons to Use Random Partitioning
1. Since data is stored across different data servers randomly, the risk of overloading one database server is greatly reduced.

2. Data collection would be fast because the database design is not over-engineered.

Reasons Not to Use Random Partitioning
1. Querying data might be slow and tedious because requests must be sent to all the servers to ensure that no data is missed.

2. Data is not grouped in any meaningful way, making range queries inefficient and increasing system overhead.

## Partitioning by Hour
Reasons to Use Partitioning by Hour
1. Range queries (e.g., time-based queries) can be executed on a single server, thereby improving performance.

2. Querying the database is straightforward since the timestamp (hour) determines exactly which server stores the data.

Reasons Not to Use Partitioning by Hour
1. Most of the data would be stored in Boat A, which could lead to an overload of the database server.

2. Uneven load can reduce system performance and scalability due to bottlenecks on heavily used servers.

## Partitioning by Hash Value
Reasons to Use Partitioning by Hash Value
1. Data is spread among different data servers across the three boats, thereby reducing the risk of a hotspot (server overload).

2. Querying specific records would be fast since the hash function deterministically maps each key to a server.

Reasons Not to Use Partitioning by Hash Value
1. Range queries are inefficient because related data is spread among multiple servers.

2. Queries that involve multiple records require searching all the data servers, thereby increasing overhead.
