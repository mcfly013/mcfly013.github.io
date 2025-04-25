
document.querySelectorAll('.accordion-btn').forEach((btn, idx) => {
    btn.addEventListener('click', function () {
        this.classList.toggle('active');
        const panel = this.nextElementSibling;
        panel.style.display = panel.style.display === 'block' ? 'none' : 'block';
    });
});

const days = {
    monday: [
        { name: "Bankdrücken", image: "images/bankdruecken.jpg" },
        { name: "Schrägbankdrücken", image: "images/schraegbank.jpg" },
        { name: "Fliegende", image: "images/fliegende.jpg" }
    ],
    wednesday: [
        { name: "Kniebeugen", image: "images/kniebeuge.jpg" },
        { name: "Beinpresse", image: "images/beinpresse.jpg" },
        { name: "Beinstrecker", image: "images/beinstrecker.jpg" }
    ],
    friday: [
        { name: "Klimmzüge", image: "images/klimmzug.jpg" },
        { name: "Rudern", image: "images/rudern.jpg" },
        { name: "Latziehen", image: "images/latziehen.jpg" }
    ]
};

let totalInputs = 0;
let filledInputs = 0;

function updateProgress() {
    const percentage = totalInputs === 0 ? 0 : Math.round((filledInputs / totalInputs) * 100);
    document.getElementById("progress-fill").style.width = percentage + "%";
    document.getElementById("progress-text").innerText = `Fortschritt: ${percentage}%`;
}

function generateExercises(dayId, exercises) {
    const container = document.getElementById("day-" + dayId);
    exercises.forEach(ex => {
        const div = document.createElement("div");
        div.className = "exercise";
        div.innerHTML = `
            <h3>${ex.name}</h3>
            <img src="${ex.image}" alt="${ex.name}">
            Sätze: <input type="number" min="0" class="tracker"><br>
            Wiederholungen: <input type="number" min="0" class="tracker">
        `;
        container.appendChild(div);
    });
}

Object.keys(days).forEach(day => generateExercises(day, days[day]));

document.querySelectorAll('.tracker').forEach(input => {
    totalInputs++;
    input.addEventListener('input', () => {
        filledInputs = [...document.querySelectorAll('.tracker')].filter(i => i.value).length;
        updateProgress();
    });
});

updateProgress();
