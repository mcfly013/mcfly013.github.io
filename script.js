
function toggleDay(id) {
    const el = document.getElementById(id);
    el.style.display = el.style.display === "block" ? "none" : "block";
}

document.addEventListener("input", function (event) {
    if (event.target.classList.contains("weight-now") || event.target.classList.contains("weight-last")) {
        const container = event.target.closest(".exercise");
        const now = parseFloat(container.querySelector(".weight-now").value) || 0;
        const last = parseFloat(container.querySelector(".weight-last").value) || 0;
        const diff = now - last;
        container.querySelector(".progress").textContent = diff.toFixed(1);
    }
});
