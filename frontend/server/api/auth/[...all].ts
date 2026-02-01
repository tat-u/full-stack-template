// `/auth` で始まるすべてのリクエストを処理するエンドポイント
//
// NOTE: ドキュメントに従い、仕方なく /api/auth/[...all].ts に配置しています
// SEE: https://www.better-auth.com/docs/installation#mount-handler
// WARN: これに伴い、API サーバーでは /api/auth 以下を使用しないようにします

import { auth } from "@@/utils/auth";

export default defineEventHandler((event) => {
  // better-auth のリクエストハンドラに処理を委譲
  return auth.handler(toWebRequest(event));
});
