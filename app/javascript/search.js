const DELAY = 1000; // miliseconds
let typingTimerId
let lastLoggedQuery = "";

const searchBox = document.getElementById("searchBox");
const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

searchBox.addEventListener("input", () => {
  clearTimeout(typingTimerId)

  typingTimerId = setTimeout(() => {
    const currentQuery = searchBox.value.trim();

    if (currentQuery.length < 2 || currentQuery === lastLoggedQuery) return;

    lastLoggedQuery = currentQuery;

    fetch("/search", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": csrfToken

      },
      body: JSON.stringify({ query: lastLoggedQuery }),
    }).then(() => {
      updateTopQueries();
    });
  }, DELAY)
})

function updateTopQueries() {
  fetch("/search/analytics", { method: "GET" })
    .then((response) => response.json())
    .then((data) => {
      const tableBody = document.querySelector("tbody");
      tableBody.innerHTML = ""

      Object.entries(data).forEach(([query, count]) => {
        const row = document.createElement("tr");
        row.innerHTML = `
          <td style="color: #444;">${query}</td>
          <td>
            <span class="badge rounded-pill" style="background-color: #007bff; color: white;">
              ${count}
            </span>
          </td>
        `;
        tableBody.appendChild(row);
      });
    });
}