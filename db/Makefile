# Connet to MySQL database as defined in .my.cnf
mysql:
# コマンドライン引数でパスワードを渡すとログファイルへ残り、
# 環境変数で渡すと /proc/$pid/environ へ残るため、公式推奨の方法である設定ファイル経由で接続する
# SEE: https://dev.mysql.com/doc/refman/8.0/en/password-security-user.html
	mysql --defaults-extra-file=.my.cnf

# Attach to the running database container's bash
attach:
	docker compose exec db bash