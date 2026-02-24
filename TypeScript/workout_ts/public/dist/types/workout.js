export class WorkoutPlan {
    constructor(id, goal, daysPerWeek, workouts) {
        this.id = id;
        this.goal = goal;
        this.daysPerWeek = daysPerWeek;
        this.workouts = workouts;
    }
    getTotalExercises() {
        return this.workouts.reduce((total, day) => {
            return total + day.exercises.length;
        }, 0);
    }
}
