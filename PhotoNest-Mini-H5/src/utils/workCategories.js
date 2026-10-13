export function visibleCategories(categories = []) {
  return categories
    .filter((category) => category && category.status !== '1')
    .sort((left, right) => Number(left.sort || 0) - Number(right.sort || 0))
}
