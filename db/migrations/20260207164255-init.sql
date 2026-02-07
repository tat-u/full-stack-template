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
  UNIQUE KEY uq_username (username),
  UNIQUE KEY uq_email (email),

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

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
  UNIQUE KEY uq_provider_uid (provider_name, provider_uid),
  -- ユーザーが消えたら認証情報も消す
  CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES user (user_id) ON DELETE CASCADE,

  -- OAuth プロバイダによってはケースセンシティブな UID を発行するため、ケースセンシティブに倒す意図で `COLLATE` はバイナリ比較とする
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE `security` (

  security_id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '内部管理 ID',

  ticker_symbol VARCHAR(16) NOT NULL COMMENT '証券コード',
  -- 投資信託を考慮すると、特有の命名ルールにより長くなる傾向にあるため、十二分に確保する
  full_name VARCHAR(256) NOT NULL COMMENT '正式名称',
  display_name VARCHAR(64) NOT NULL COMMENT '表示名',

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作成日時',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日時',

  PRIMARY KEY (security_id),
  UNIQUE KEY uq_ticker_symbol (ticker_symbol),

  -- 証券コードを扱うため、`COLLATE` はバイナリ比較とする
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- TODO: ウォッチリスト実装 (以下は Gemini 生成のため要修正)

CREATE TABLE `watchlists` (
  user_id INT UNSIGNED NOT NULL COMMENT 'user テーブルへの参照',
  security_id INT UNSIGNED NOT NULL COMMENT 'security_master テーブルへの参照',
  
  -- お気に入り登録した順番で並べ替えたい場合に便利
  sort_order INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '表示順序',
  
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  -- 同じユーザーが同じ銘柄を2回登録できないようにする
  PRIMARY KEY (user_id, security_id),
  
  -- 外部キー制約（親が消えたら自動削除）
  CONSTRAINT fk_watchlist_user FOREIGN KEY (user_id) REFERENCES `user` (user_id) ON DELETE CASCADE,
  CONSTRAINT fk_watchlist_security FOREIGN KEY (security_id) REFERENCES `security_master` (security_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='ユーザーのウォッチリスト';
