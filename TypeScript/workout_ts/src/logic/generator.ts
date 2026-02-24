import {
  Goal,
  Equipment,
  WorkoutPlan,
  WorkoutDay,
  WorkoutExercise,
} from "../types/workout.js";
import { exerciseLibrary } from "../data/exercises.js";

function filterExercisesByEquipment(equipment: Equipment[]) {
  return exerciseLibrary.filter((ex) => equipment.includes(ex.equipment));
}

function getRandomExercises(count: number, equipment: Equipment[]) {
  const filtered = filterExercisesByEquipment(equipment);

  if (filtered.length === 0) {
    throw new Error("No exercises available for selected equipment.");
  }

  const shuffled = [...filtered].sort(() => 0.5 - Math.random());
  return shuffled.slice(0, count);
}

export function generateWorkoutPlan(
  goal: Goal,
  daysPerWeek: number,
  equipment: Equipment[]
): WorkoutPlan {
  console.log("Equipment:", equipment);
  if (!Number.isInteger(daysPerWeek) || daysPerWeek <= 0) {
    throw new Error("Days per week must be greater than 0.");
  }

  if (equipment.length == 0) {
    throw new Error("Please select at least one type of equipment.");
  }
  const workouts: WorkoutDay[] = [];

  for (let i = 1; i <= daysPerWeek; i++) {
    // ✅ Explicitly type this as WorkoutExercise[]
    const selectedExercises: WorkoutExercise[] = getRandomExercises(
      3,
      equipment
    ).map((ex) => {
      let sets = 3;
      let reps = 10;

      if (goal === "strength") {
        sets = 4;
        reps = 5;
      } else if (goal === "hypertrophy") {
        sets = 3;
        reps = 8;
      } else if (goal === "fat_loss") {
        sets = 3;
        reps = 12;
      }

      return {
        ...ex,
        setRep: [sets, reps],
      };
    });

    workouts.push({
      day: `Day ${i}`,
      exercises: selectedExercises,
    });
  }

  return new WorkoutPlan(Date.now().toString(), goal, daysPerWeek, workouts);
}
