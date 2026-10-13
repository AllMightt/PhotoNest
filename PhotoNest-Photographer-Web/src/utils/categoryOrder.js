export function reorderCategories(categories, sourceId, targetId) {
  const next = [...categories].sort((a, b) => Number(a.sort || 0) - Number(b.sort || 0))
  const sourceIndex = next.findIndex((item) => item.id === sourceId)
  const targetIndex = next.findIndex((item) => item.id === targetId)
  if (sourceIndex < 0 || targetIndex < 0 || sourceIndex === targetIndex) {
    return next
  }
  const [source] = next.splice(sourceIndex, 1)
  next.splice(targetIndex, 0, source)
  return next.map((item, index) => ({ ...item, sort: (index + 1) * 10 }))
}

export function categoriesWithWorkCount(categories, works) {
  const counts = works.reduce((map, work) => {
    const categoryId = Number(work.categoryId)
    map.set(categoryId, (map.get(categoryId) || 0) + 1)
    return map
  }, new Map())
  return categories
    .map((category) => ({ ...category, workCount: counts.get(Number(category.id)) || 0 }))
    .sort((a, b) => Number(a.sort || 0) - Number(b.sort || 0))
}
