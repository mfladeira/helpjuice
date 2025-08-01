const DELAY = 1000; // miliseconds
let typingTimerId
let lastLoggedQuery = "";

const searchBox = document.getElementById("searchBox");

searchBox.addEventListener("input", () => {
  clearTimeout(typingTimerId)

  typingTimerId = setTimeout(() => {
    const currentQuery = searchBox.value.trim();

    if (currentQuery.length < 2 || currentQuery === lastLoggedQuery) return;

    lastLoggedQuery = currentQuery;

    console.log(lastLoggedQuery)
  }, DELAY);
})