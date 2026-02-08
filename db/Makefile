.PHONY: mysql mysqldump attach

# Connet to MySQL database as defined in .my.cnf
# e.g.) `make mysql < migration.sql`
mysql:
# コマンドライン引数でパスワードを渡すとログファイルへ残り、
# 環境変数で渡すと /proc/$pid/environ へ残るため、公式推奨の方法である設定ファイル経由で接続する
# SEE: https://dev.mysql.com/doc/refman/8.0/en/password-security-user.html
	mysql --defaults-extra-file=.my.cnf

# Dump all databases to dump.sql
mysqldump:
	mysqldump --defaults-extra-file=.my.cnf --single-transaction --all-databases > dump.sql

# Attach to the running database container's bash
attach:
	docker compose exec db bash

# Print current date in YYYYMMDDHHMMSS format
# .sql migration files use this format for timestamp prefix
date:
	date +%Y%m%d%H%M%S