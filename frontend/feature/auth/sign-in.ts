// クライアントに対してサインインの具体的な手段を提供する

import { authClient } from "./auth-client";

export const signInWithGoogle = async () => {
  await authClient.signIn.social({
    provider: "google",
    callbackURL: "/dashboard", // ログイン成功後のリダイレクト先
    errorCallbackURL: "/error", // ログイン失敗時のリダイレクト先
    // 実装をシンプルに保つため、完全な画面遷移によって OAuth フローを処理する
    // ポップアップ画面で OAuth を処理したい場合は true に設定する必要があるが、
    // モバイルユーザが利用する場合の動作保証が難しくなる懸念がある
    disableRedirect: false, // OAuth クライアント側画面へのリダイレクトの可否
  });
};
