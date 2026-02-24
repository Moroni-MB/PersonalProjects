
export type Goal = "strength" | "hypertrophy" | "fat_loss";

export type Equipment = "barbell" | "dumbbell" | "bodyweight";

export type SetRep = [number, number];

export interface Exercise {
  name: string;
  muscleGroup: string;
  equipment: Equipment;
}

// Exercise inside a workout (adds tuple)
export interface WorkoutExercise extends Exercise {
  setRep: SetRep;
}

export interface WorkoutDay {
  day: string;
  exercises: Exercise[];
}

export class WorkoutPlan {
  id: string;
  goal: Goal;
  daysPerWeek: number;
  workouts: WorkoutDay[];

  constructor(
    id: string,
    goal: Goal,
    daysPerWeek: number,
    workouts: WorkoutDay[]
  ) {
    this.id = id;
    this.goal = goal;
    this.daysPerWeek = daysPerWeek;
    this.workouts = workouts;
  }

  getTotalExercises(): number {
    return this.workouts.reduce((total, day) => {
      return total + day.exercises.length;
    }, 0);
  }
}