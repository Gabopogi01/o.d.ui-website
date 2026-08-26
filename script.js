document.addEventListener("DOMContentLoaded", () => {
  const sound = new Audio('click.ogg');

  document.addEventListener('click', (event) => {
    if (event.button === 0) {
      sound.currentTime = 0;
      sound.play().catch(error => {
        console.log("Playback failed:", error);
      });
    }
  });
});