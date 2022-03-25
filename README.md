# README

Demonstration of odd active record caching in tests.

SETUP:

1. `bundle install`
1. `rails db:create`
1. `rails db:migrate`
1. `rails test`

Three tests in this repo:

1. `assert_difference` with a Post.create
1. `assert_difference` with a raw INSERT statement
1. `assert_difference` with a raw INSERT statement and explicitly disabling AR cache for `Post`

Two tests should pass, one should fail.

log/test.log output showing one test using the AR cache for the `count`:

```
  TRANSACTION (0.2ms)  begin transaction
------------------------------
PostTest: test_with_raw_insert
------------------------------
  Post Count (0.3ms)  SELECT COUNT(*) FROM "posts"
   (0.5ms)  INSERT INTO posts (title, created_at, updated_at) VALUES ('a post', date(), date())
  CACHE Post Count (0.0ms)  SELECT COUNT(*) FROM "posts"
  TRANSACTION (0.3ms)  rollback transaction
  TRANSACTION (0.1ms)  begin transaction
-----------------------------
PostTest: test_with_ar_insert
-----------------------------
  Post Count (0.2ms)  SELECT COUNT(*) FROM "posts"
  TRANSACTION (0.1ms)  SAVEPOINT active_record_1
  Post Create (0.2ms)  INSERT INTO "posts" ("title", "created_at", "updated_at") VALUES (?, ?, ?)  [["title", "post"], ["created_at", "2022-03-25 23:48:39.242173"], ["updated_at", "2022-03-25 23:48:39.242173"]]
  TRANSACTION (0.1ms)  RELEASE SAVEPOINT active_record_1
  Post Count (0.1ms)  SELECT COUNT(*) FROM "posts"
  TRANSACTION (0.1ms)  rollback transaction
  TRANSACTION (0.1ms)  begin transaction
-------------------------------------------
PostTest: test_with_raw_insert_but_no_cache
-------------------------------------------
  Post Count (0.1ms)  SELECT COUNT(*) FROM "posts"
   (0.2ms)  INSERT INTO posts (title, created_at, updated_at) VALUES ('a post', date(), date())
  Post Count (0.1ms)  SELECT COUNT(*) FROM "posts"
  TRANSACTION (0.1ms)  rollback transaction
```

