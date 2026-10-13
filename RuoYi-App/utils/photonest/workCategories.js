export function visibleCategories(categories = [], works = []) {
  const activeCategoryIds = new Set(
    works
      .filter(work => work && work.status !== '1')
      .map(work => Number(work.categoryId))
      .filter(Boolean)
  )

  return categories
    .filter(category => category && category.status !== '1')
    .filter(category => activeCategoryIds.has(Number(category.id)))
    .sort((left, right) => Number(left.sort || 0) - Number(right.sort || 0))
}
