CREATE DATABASE `webapp_prod` CHARSET utf8mb4 COLLATE utf8mb4_bin;

USE `webapp_prod`;

CREATE TABLE `user` (

  user_id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '内部管理 ID',

  -- ウェブアプリ側でのユーザー識別子
  -- 初期値はランダム
  username VARCHAR(16) NOT NULL COMMENT 'ユーザー名',
  -- 初期値は OAuth 連携時に取得した名前
  nickname VARCHAR(32) NOT NULL COMMENT 'ニックネーム',
  -- ほとんどの場合はフリーメールのプロバイダ側が字数制限を設けているが、万が一のため長めに確保する
  -- 上限は RFC 2821 に準拠
  -- SEE: https://datatracker.ietf.org/doc/html/rfc2821#section-4.5.3.1
  -- 一般的にほとんどの場合、メールアドレスはケースインセンシティブに処理されるため、ウェブアプリ側でメールアドレスを小文字へ変換する
  email VARCHAR(256) NOT NULL COMMENT 'メールアドレス',

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',

  PRIMARY KEY (user_id),
  UNIQUE KEY uq_user_username (username),
  UNIQUE KEY uq_user_email (email)

) ENGINE InnoDB;

CREATE TABLE `user_authentication` (

  auth_id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '内部管理 ID',

  user_id INT UNSIGNED NOT NULL COMMENT 'user テーブルへの参照',
  -- OAuth プロバイダ名 (例: google, github など)
  -- oauth_provider テーブルを設けて別途で管理する方法もあるが、複数プロバイダをサポートする予定が当面はないため、現状は文字列直書きとする
  provider_name VARCHAR(32) NOT NULL COMMENT 'OAuth プロバイダ名',
  provider_uid VARCHAR(128) NOT NULL COMMENT 'OAuth プロバイダ側の UID',

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',

  PRIMARY KEY (auth_id),
  -- 同じプロバイダ内で同じ UID が 2 回登録されないようにする
  UNIQUE KEY uq_user_authentication_provider_name_provider_uid (provider_name, provider_uid),
  -- ユーザーが消えたら認証情報も消す
  CONSTRAINT fk_user_authentication_user_id FOREIGN KEY (user_id) REFERENCES user (user_id) ON DELETE CASCADE

  -- OAuth プロバイダによってはケースセンシティブな UID を発行するため、ケースセンシティブに倒す意図で `COLLATE` はバイナリ比較とする
) ENGINE InnoDB;

CREATE TABLE `security` (

  security_id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '内部管理 ID',

  ticker_symbol VARCHAR(16) NOT NULL COMMENT '証券コード',
  -- 投資信託を考慮すると、特有の命名ルールにより長くなる傾向にあるため、十二分に確保する
  full_name VARCHAR(256) NOT NULL COMMENT '正式名称',
  display_name VARCHAR(64) NOT NULL COMMENT '表示名',

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',

  PRIMARY KEY (security_id),
  UNIQUE KEY uq_security_ticker_symbol (ticker_symbol)

  -- 証券コードを扱うため、`COLLATE` はバイナリ比較とする
) ENGINE InnoDB;

CREATE TABLE `watchlist` (

  user_id INT UNSIGNED NOT NULL COMMENT 'user テーブルへの参照',
  security_id INT UNSIGNED NOT NULL COMMENT 'security テーブルへの参照',
  
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',

  -- 同じユーザーが同じ銘柄を 2 回ウォッチリストへ登録できないようにする
  PRIMARY KEY (user_id, security_id),
  
  CONSTRAINT fk_watchlist_user_id FOREIGN KEY (user_id) REFERENCES `user` (user_id) ON DELETE CASCADE,
  CONSTRAINT fk_watchlist_security_id FOREIGN KEY (security_id) REFERENCES `security` (security_id) ON DELETE CASCADE

) ENGINE InnoDB;
