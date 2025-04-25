<!DOCTYPE html>
<html lang="de">
<head>
  <meta charset="UTF-8">
  <title>Mein Trainingsplan</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f2f2f2;
      margin: 0;
      padding: 0;
    }

    header {
      background-color: #3b82f6;
      color: white;
      text-align: center;
      padding: 1em 0;
    }

    header h1 {
      margin: 0;
    }

    .container {
      max-width: 700px;
      margin: 2em auto;
      background: white;
      padding: 1.5em;
      border-radius: 10px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    .day {
      margin-bottom: 2em;
    }

    .day h2 {
      margin-bottom: 0.5em;
      color: #3b82f6;
    }

    .exercise {
      display: flex;
      align-items: center;
      margin-bottom: 0.5em;
    }

    .exercise input[type="text"] {
      flex: 1;
      padding: 0.5em;
      border: 1px solid #ccc;
      border-radius: 5px;
    }

    .exercise input[type="checkbox"] {
      margin-left: 0.5em;
      transform: scale(1.3);
    }

    .progress-bar {
      height: 10px;
      background-color: #e0e0e0;
      border-radius: 5px;
      margin-top: 0.3em;
      overflow: hidden;
    }

    .progress-fill {
      height: 100%;
      background-color: #10b981;
      width: 0%;
      transition: width 0.3s ease;
    }

    .controls {
      display: flex;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 0.5em;
      margin-bottom: 1em;
    }

    button {
      background: #3b82f6;
      color: white;
      border: none;
      padding: 0.5em 1em;
      border-radius: 5px;
      cursor: pointer;
    }

    button:hover {
      background: #2563eb;
    }

    .logo {
      font-size: 2em;
    }

    textarea {
      width: 100%;
      height: 100px;
      padding: 0.5em;
      border: 1px solid #ccc;
      border-radius: 5px;
      resize: vertical;
    }
  </style>
</head>
<body>
  <header>
    <div class="logo">💪</div>
    <h1>Mein Trainingsplan</h1>
  </header>

  <div class="container">
    <div class="controls">
      <button onclick="resetWeek()">Wochen-Reset</button>
      <button onclick="exportPlan()">Exportieren</button>
      <button onclick="importPlan()">Importieren</button>
    </div>
    <div id="plan"></div>
    <div id="import-area" style="margin-top: 1em; display: none;">
      <textarea id="import-text" placeholder="Trainingsdaten hier einfügen..."></textarea>
      <button onclick="applyImport()">Übernehmen</button>
    </div>
  </div>

  <script>
    const days = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];
    const planContainer = document.getElementById("plan");

    function loadPlan() {
      planContainer.innerHTML = "";
      const saved = JSON.parse(localStorage.getItem("trainingsplan") || "{}");

      days.forEach(day => {
        const dayDiv = document.createElement("div");
        dayDiv.className = "day";

        const heading = document.createElement("h2");
        heading.textContent = day;
        dayDiv.appendChild(heading);

        const exercises = saved[day] || [];
        exercises.forEach(ex => {
          const exerciseDiv = createExerciseInput(day, ex.text, ex.done);
          dayDiv.appendChild(exerciseDiv);
        });

        const newInput = createExerciseInput(day);
        dayDiv.appendChild(newInput);

        const progress = document.createElement("div");
        progress.className = "progress-bar";
        const fill = document.createElement("div");
        fill.className = "progress-fill";
        progress.appendChild(fill);
        dayDiv.appendChild(progress);

        planContainer.appendChild(dayDiv);

        updateProgress(dayDiv, exercises);
      });
    }

    function createExerciseInput(day, value = "", checked = false) {
      const div = document.createElement("div");
      div.className = "exercise";

      const input = document.createElement("input");
      input.type = "text";
      input.value = value;
      input.placeholder = "Übung eintragen...";

      const checkbox = document.createElement("input");
      checkbox.type = "checkbox";
      checkbox.checked = checked;

      input.addEventListener("input", () => saveExercise(day));
      checkbox.addEventListener("change", () => saveExercise(day));

      div.appendChild(input);
      div.appendChild(checkbox);

      return div;
    }

    function saveExercise(day) {
      const dayDivs = document.querySelectorAll(".day");
      const data = {};

      dayDivs.forEach(dayDiv => {
        const heading = dayDiv.querySelector("h2").textContent;
        const inputs = dayDiv.querySelectorAll(".exercise");
        const exercises = [];

        inputs.forEach(div => {
          const text = div.querySelector("input[type='text']").value;
          const done = div.querySelector("input[type='checkbox']").checked;
          if (text.trim() !== "") {
            exercises.push({ text, done });
          }
        });

        data[heading] = exercises;
        updateProgress(dayDiv, exercises);
      });

      localStorage.setItem("trainingsplan", JSON.stringify(data));
    }

    function updateProgress(dayDiv, exercises) {
      const fill = dayDiv.querySelector(".progress-fill");
      if (!fill) return;
      const total = exercises.length;
      const done = exercises.filter(e => e.done).length;
      const percent = total > 0 ? (done / total) * 100 : 0;
      fill.style.width = percent + "%";
    }

    function resetWeek() {
      const saved = JSON.parse(localStorage.getItem("trainingsplan") || "{}");
      Object.keys(saved).forEach(day => {
        saved[day] = saved[day].map(e => ({ text: e.text, done: false }));
      });
      localStorage.setItem("trainingsplan", JSON.stringify(saved));
      loadPlan();
    }

    function exportPlan() {
      const data = localStorage.getItem("trainingsplan");
      prompt("Kopiere diesen Text und speichere ihn z.B. in einer Notiz:", data);
    }

    function importPlan() {
      document.getElementById("import-area").style.display = "block";
    }

    function applyImport() {
      const text = document.getElementById("import-text").value;
      try {
        JSON.parse(text); // Check ob gültig
        localStorage.setItem("trainingsplan", text);
        loadPlan();
        alert("Import erfolgreich!");
      } catch (e) {
        alert("Ungültige Daten. Bitte überprüfe den Text.");
      }
    }

    loadPlan();
  </script>
</body>
</html>
