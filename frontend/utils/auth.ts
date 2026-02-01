// NOTE: ドキュメントで指示されているため、仕方なく utils 直下に置いています
// SEE: https://www.better-auth.com/docs/installation#create-a-better-auth-instance

import { betterAuth } from "better-auth";

// Better Auth インスタンスの作成
export const auth = betterAuth({
  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    },
  },
  emailAndPassword: {
    enabled: true,
    async sendResetPassword(url, user) {
      console.log("Reset password url:", url);
      console.log("For user:", user);
    },
  },
});
