**RBAC & Applying Database Schema**

- **Overview:** Brief notes about the RBAC additions in `postgres_schema.sql`.

- **Files:**
  - Schema: [postgres_schema.sql](postgres_schema.sql)
  - RBAC README: [RBAC_README.md](RBAC_README.md)

**What was added**
- `roles`, `permissions`, `role_permissions`, `staff_roles` tables
- Seed rows for roles: `admin`, `hotel_owner`, `hotel_staff`
- `staff_roles` FK to `staff` is added via `ALTER TABLE` to avoid ordering issues when running the full script.

**Run locally (psql)**
1. Create database (if not exists):

```bash
createdb hotel_booking_db
```

2. Apply schema file:

```bash
psql -d hotel_booking_db -f postgres_schema.sql
```

- If you run the script multiple times, modify the seed `INSERT INTO roles ...` to use `ON CONFLICT DO NOTHING` to avoid duplicate key errors, e.g.:

```sql
INSERT INTO roles (name, description)
VALUES ('admin','...')
ON CONFLICT (name) DO NOTHING;
```

**Run inside Docker (Postgres container)**
1. Start a Postgres container (example):

```bash
docker run --name pg-local -e POSTGRES_PASSWORD=pass -e POSTGRES_DB=hotel_booking_db -p 5432:5432 -d postgres:15
```

2. Copy and apply schema:

```bash
docker cp postgres_schema.sql pg-local:/tmp/postgres_schema.sql
docker exec -it pg-local psql -U postgres -d hotel_booking_db -f /tmp/postgres_schema.sql
```

**Notes & Recommendations**
- The `postgres_schema.sql` file includes FK constraints added with `ALTER TABLE` to avoid ordering/circular issues.
- If you want idempotent seeds, change `INSERT` into `INSERT ... ON CONFLICT DO NOTHING` as shown above.
- For migrations in a CI/CD pipeline, convert the DDL into migration files (Flyway / Liquibase / Prisma / Sqitch) rather than running raw SQL scripts.

If you want, I can:
- Convert the seed inserts to idempotent statements and update the file.
- Generate Flyway-style migration files from the DDL.
