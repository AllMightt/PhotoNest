function visibleCategories(categories = []) {
  return categories
    .filter((category) => category && category.status !== '1')
    .sort((left, right) => {
      const sortDiff = Number(left.sort || 0) - Number(right.sort || 0)
      if (sortDiff !== 0) return sortDiff
      return Number(left.id || 0) - Number(right.id || 0)
    })
}

module.exports = {
  visibleCategories
}
