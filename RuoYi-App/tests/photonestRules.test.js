import { describe, expect, it } from 'vitest'
import { maskPhone } from '../utils/photonest/phone.js'
import { visibleCategories } from '../utils/photonest/workCategories.js'

describe('PhotoNest rules in RuoYi-App', () => {
  it('masks customer phone numbers for photographer-facing pages', () => {
    expect(maskPhone('13812345678')).toBe('138****5678')
  })

  it('shows only categories with works using photographer order', () => {
    const categories = [
      { id: 1, categoryName: '婚礼', sort: 30, status: '0' },
      { id: 2, categoryName: '写真', sort: 10, status: '0' },
      { id: 3, categoryName: '百天', sort: 20, status: '0' },
      { id: 4, categoryName: '隐藏', sort: 40, status: '0' }
    ]
    const works = [
      { id: 11, categoryId: 1, status: '0' },
      { id: 12, categoryId: 2, status: '0' },
      { id: 13, categoryId: 3, status: '0' }
    ]

    expect(visibleCategories(categories, works).map(item => item.categoryName)).toEqual(['写真', '百天', '婚礼'])
  })
})
