import { generateWorkoutPlan } from "./logic/generator.js";
import { Goal, Equipment } from "./types/workout.js";

console.log("JS Loaded");

const goalSelect = document.getElementById("goal") as HTMLSelectElement;
const daysInput = document.getElementById("days") as HTMLInputElement;
const equipmentInput = document.getElementById("equipment") as HTMLInputElement;
const output = document.getElementById("output") as HTMLPreElement;
const button = document.getElementById("generate") as HTMLButtonElement;

button.addEventListener("click", () => {
  const goal = goalSelect.value as Goal;
  const days = parseInt(daysInput.value);
  const equipment = equipmentInput.value.split(",") as Equipment[];

  const workout = generateWorkoutPlan(goal, days, equipment);

  renderWorkout(workout);
});

function renderWorkout(workout: any) {
  output.innerHTML = "";

  const title = document.createElement("h2");
  title.textContent = `${workout.goal.toUpperCase()} PROGRAM`;
  output.appendChild(title);

  // Define colors for muscle groups
  const muscleColors: Record<string, string> = {
    chest: "#ef4444",
    back: "#3b82f6",
    "upper-back": "#6366f1",
    legs: "#10b981",
    shoulders: "#f59e0b",
    arms: "#8b5cf6",
    core: "#f43f5e",
    default: "#6b7280"
  };

  workout.workouts.forEach((day: any) => {
    const dayCard = document.createElement("div");
    dayCard.className = "day-card";

    const dayTitle = document.createElement("h3");
    dayTitle.textContent = day.day;
    dayCard.appendChild(dayTitle);

    const list = document.createElement("ul");

    day.exercises.forEach((exercise: any) => {
      const item = document.createElement("li");

      // Exercise text
      item.textContent = `${exercise.name} — ${exercise.sets}x${exercise.reps} `;

      // Muscle group badge
      const muscleSpan = document.createElement("span");
      muscleSpan.textContent = exercise.muscleGroup.toUpperCase();
      muscleSpan.classList.add("muscle");

      // Set background color dynamically
      muscleSpan.style.backgroundColor =
        muscleColors[exercise.muscleGroup] || muscleColors.default;

      item.appendChild(muscleSpan);
      list.appendChild(item);
    });

    dayCard.appendChild(list);
    output.appendChild(dayCard);
  });
}