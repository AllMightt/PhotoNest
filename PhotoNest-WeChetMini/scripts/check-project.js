const fs = require('fs')
const path = require('path')
const assert = require('assert')

const root = path.resolve(__dirname, '..')

function readJson(file) {
  return JSON.parse(fs.readFileSync(path.join(root, file), 'utf8'))
}

function walk(dir, predicate, result = []) {
  for (const name of fs.readdirSync(dir)) {
    const file = path.join(dir, name)
    const stat = fs.statSync(file)
    if (stat.isDirectory()) walk(file, predicate, result)
    else if (predicate(file)) result.push(file)
  }
  return result
}

const jsonFiles = walk(root, (file) => file.endsWith('.json'))
jsonFiles.forEach((file) => JSON.parse(fs.readFileSync(file, 'utf8')))

const app = readJson('app.json')
assert(Array.isArray(app.pages), 'app.json pages must be an array')
assert(app.tabBar.list.length === 5, 'tabBar must contain 5 guest tabs')

for (const page of app.pages) {
  for (const ext of ['js', 'json', 'wxml', 'wxss']) {
    const file = path.join(root, `${page}.${ext}`)
    assert(fs.existsSync(file), `missing page file: ${page}.${ext}`)
  }
}

const { maskPhone } = require('../utils/phone')
const { visibleCategories } = require('../utils/work-categories')
assert.strictEqual(maskPhone('13812345678'), '138****5678')
assert.deepStrictEqual(
  visibleCategories([
    { id: 3, categoryName: '婚礼', sort: 30, status: '0' },
    { id: 1, categoryName: '写真', sort: 10, status: '0' },
    { id: 2, categoryName: '隐藏', sort: 20, status: '1' }
  ]).map((item) => item.categoryName),
  ['写真', '婚礼']
)

console.log(`JSON OK: ${jsonFiles.length} files`)
console.log(`Pages OK: ${app.pages.length} pages`)
console.log('Utility rules OK')
