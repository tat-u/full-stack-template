// 認証サーバーと通信するためのクライアント側のヘルパー

import { createAuthClient } from "better-auth/vue";

export const authClient = createAuthClient({
  // The base URL of the authentication server
  baseURL: process.env.BETTER_AUTH_URL,
});

// createAuthClient の中身のエイリアス
export const {
  signIn,
  signOut,
  signUp,
  useSession,
  requestPasswordReset,
  resetPassword,
} = authClient;
