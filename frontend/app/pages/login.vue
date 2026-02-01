<script setup>
import { signInWithGoogle } from "@@/feature/auth";
</script>

<template>
  <div>
    <span>ログインページ</span>
    <a href="/">トップページへ</a>
    <a href="/dashboard">ダッシュボードへ</a>
    <button @click="signInWithGoogle">Googleでログイン</button>
  </div>
</template>

<style scoped>
span,
a,
button {
  display: block;
}
</style>
