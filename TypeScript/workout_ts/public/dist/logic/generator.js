import { exerciseLibrary } from "../data/exercises.js";
function filterExercisesByEquipment(equipment) {
    return exerciseLibrary.filter(ex => equipment.includes(ex.equipment));
}
function getRandomExercises(count, equipment) {
    const filtered = filterExercisesByEquipment(equipment);
    const shuffled = [...filtered].sort(() => 0.5 - Math.random());
    return shuffled.slice(0, count);
}
export function generateWorkoutPlan(goal, daysPerWeek, equipment) {
    const workouts = [];
    for (let i = 1; i <= daysPerWeek; i++) {
        const selectedExercises = getRandomExercises(3, equipment).map(ex => {
            let sets = 3;
            let reps = 10;
            if (goal === "strength") {
                sets = 4;
                reps = 5;
            }
            else if (goal === "hypertrophy") {
                sets = 3;
                reps = 8;
            }
            else if (goal === "fat_loss") {
                sets = 3;
                reps = 12;
            }
            return {
                ...ex,
                sets,
                reps
            };
        });
        workouts.push({
            day: `Day ${i}`,
            exercises: selectedExercises
        });
    }
    // Return workout plan with each workout
    return {
        id: Date.now().toString(),
        goal,
        daysPerWeek,
        workouts
    };
}
