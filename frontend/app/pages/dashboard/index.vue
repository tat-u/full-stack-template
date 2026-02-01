<script setup>
import { useSession } from "@@/feature/auth";

const session = useSession();

watch(session, (newSession) => {
  console.log("Session updated:", newSession);
});
</script>

<template>
  <div>
    <span>ダッシュボードページ</span>
    <a href="/">トップページへ</a>

    <span>{{
      session.data
        ? `ようこそ、${session.data.user.name}さん`
        : "ログインしていません"
    }}</span>

    <div v-if="session.data">
      <span>ユーザ情報</span>
      <span>
        {{ JSON.stringify(session.data) }}
      </span>
    </div>
  </div>
</template>

<style scoped>
span,
a {
  display: block;
}
</style>
