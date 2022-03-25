# README

Demonstration of odd active record caching in tests.

SETUP:

1. `bundle install`
1. `rails db:create`
1. `rails db:migrate`
1. `rails test`

One test should pass, one should fail.

log/test.log output showing one test using the AR cache for the `count`:

```
  TRANSACTION (0.1ms)  begin transaction
-----------------------------
PostTest: test_with_ar_insert
-----------------------------
  Post Count (0.3ms)  SELECT COUNT(*) FROM "posts"
  TRANSACTION (0.2ms)  SAVEPOINT active_record_1
  Post Create (0.5ms)  INSERT INTO "posts" ("title", "created_at", "updated_at") VALUES (?, ?, ?)  [["title", "post"], ["created_at", "2022-03-25 23:12:19.862933"], ["updated_at", "2022-03-25 23:12:19.862933"]]
  TRANSACTION (0.2ms)  RELEASE SAVEPOINT active_record_1
  Post Count (0.2ms)  SELECT COUNT(*) FROM "posts"
  TRANSACTION (0.2ms)  rollback transaction
  TRANSACTION (0.1ms)  begin transaction
------------------------------
PostTest: test_with_raw_insert
------------------------------
  Post Count (0.3ms)  SELECT COUNT(*) FROM "posts"
   (0.3ms)  INSERT INTO posts (title, created_at, updated_at) VALUES ('a post', date(), date())
  CACHE Post Count (0.0ms)  SELECT COUNT(*) FROM "posts"
  TRANSACTION (0.2ms)  rollback transaction
```

