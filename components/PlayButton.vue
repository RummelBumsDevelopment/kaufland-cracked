<template>
  <Button :text="playText" @clicked="playClicked()" />
</template>
<script setup lang="ts">
import { useToastStore } from "~/stores/toast";

const user = useSupabaseUser();
import { useLoginStore } from "~/stores/login";

const loginStore = useLoginStore();
const toastStore = useToastStore();
const enablePlay = ref();
const playText = ref("Igraj");

const timeUntilMidnight = (datetimeStr: any) => {
  const currentDateTime = new Date(datetimeStr);
  const midnight = new Date(currentDateTime);

  midnight.setHours(24, 0, 0, 0);

  const timeDifference = midnight.getTime() - currentDateTime.getTime();

  const hours = Math.floor(timeDifference / (1000 * 60 * 60));
  const minutes = Math.floor((timeDifference % (1000 * 60 * 60)) / (1000 * 60));
  const seconds = Math.floor((timeDifference % (1000 * 60)) / 1000);

  return {
    hours: hours,
    minutes: minutes,
    seconds: seconds,
  };
};

const playClicked = async () => {
  // console.log(user.value);
  if (user.value) {
    loginStore.openLogin();
    toastStore.showToast("Za igru se potrebno prijaviti!");
    return;
  }
  if (!user.value) {
    // loginStore.openLogin();
    const response = await $fetch("/api/check_game_session", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        user_uuid: user.value?.id, // Assuming user.value has an 'id' property for the UUID
      }),
    });

    enablePlay.value = response;
    // const timeLeft = timeUntilMidnight(enablePlay?.value?.latestSession) as any;
    const timeLeft = timeUntilMidnight(Date.now());
    playText.value = `Igraj za ${timeLeft.hours}h:${timeLeft.minutes}m`;

    console.log("Enable to play status:", enablePlay.value);

    navigateTo("/game");
    return;

    toastStore.showToast("Danas si već odigrao, pokušaj ponovno sutra!");
    return;
  }
  // navigateTo("/game");
};
</script>

<style scoped></style>
