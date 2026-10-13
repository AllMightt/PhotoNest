import { describe, expect, it } from 'vitest'
import { maskPhone } from '../utils/phone'
import { visibleCategories } from '../utils/workCategories'

describe('guest data display rules', () => {
  it('masks mainland mobile numbers only for presentation', () => {
    expect(maskPhone('13812345678')).toBe('138****5678')
    expect(maskPhone('not-a-phone')).toBe('not-a-phone')
  })

  it('shows enabled categories and sorts by photographer order', () => {
    const categories = [
      { id: 1, categoryName: '婚礼', sort: 30, status: '0' },
      { id: 2, categoryName: '写真', sort: 10, status: '0' },
      { id: 3, categoryName: '百天', sort: 20, status: '0' },
      { id: 4, categoryName: '空分类', sort: 40, status: '0' },
      { id: 5, categoryName: '隐藏', sort: 50, status: '1' }
    ]

    expect(visibleCategories(categories).map((item) => item.categoryName)).toEqual(['写真', '百天', '婚礼', '空分类'])
  })
})
