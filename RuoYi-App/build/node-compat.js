const util = require('util')

if (!util.isRegExp) {
  util.isRegExp = (value) => value instanceof RegExp
}

if (!util.isArray) {
  util.isArray = Array.isArray
}
