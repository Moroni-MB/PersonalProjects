
export type Goal = "strength" | "hypertrophy" | "fat_loss";

export type Equipment = "barbell" | "dumbbell" | "bodyweight";

export interface Exercise {
  name: string;
  muscleGroup: string;
  equipment: Equipment;
}

export interface WorkoutDay {
  day: string;
  exercises: Exercise[];
}

export interface WorkoutPlan {
  id: string;
  goal: Goal;
  daysPerWeek: number;
  workouts: WorkoutDay[];
}