import { describe, expect, it } from 'vitest'
import { reorderCategories, categoriesWithWorkCount } from '../utils/categoryOrder'
import { maskPhone } from '../utils/phone'

describe('photographer workbench rules', () => {
  it('masks customer phone numbers for photographer display', () => {
    expect(maskPhone('18671266000')).toBe('186****6000')
  })

  it('reorders photographer categories and normalizes sort gaps', () => {
    const result = reorderCategories(
      [
        { id: 1, categoryName: '写真', sort: 10 },
        { id: 2, categoryName: '领证', sort: 20 },
        { id: 3, categoryName: '婚礼', sort: 30 }
      ],
      3,
      1
    )

    expect(result.map((item) => item.categoryName)).toEqual(['婚礼', '写真', '领证'])
    expect(result.map((item) => item.sort)).toEqual([10, 20, 30])
  })

  it('attaches work counts to sorted categories', () => {
    const result = categoriesWithWorkCount(
      [
        { id: 2, categoryName: '婚礼', sort: 20 },
        { id: 1, categoryName: '写真', sort: 10 }
      ],
      [{ categoryId: 2 }, { categoryId: 2 }]
    )

    expect(result.map((item) => [item.categoryName, item.workCount])).toEqual([
      ['写真', 0],
      ['婚礼', 2]
    ])
  })
})
