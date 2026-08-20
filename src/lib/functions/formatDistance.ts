const metersToImperial = (
  meters: number,
): { magnitude: number; unit: string } => {
  if (meters > 500) {
    // Convert to miles
    return { magnitude: meters * 0.0006213712, unit: "mi" };
  } else {
    // Convert to yards
    return { magnitude: meters * 1.093613, unit: "yds" };
  }
};

export const formatDist = (dist: number | undefined) => {
  if (dist === undefined) return "??";
  if (localStorage.getItem("unitSystem") === "imperial") {
    const formattedDist = metersToImperial(dist);
    return `${Math.round(formattedDist.magnitude * 10) / 10}${formattedDist.unit}`;
  } else {
    return `${dist}m`;
  }
};
