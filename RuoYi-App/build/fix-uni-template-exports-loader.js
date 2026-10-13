module.exports = function fixUniTemplateExports(source) {
  if (!source.includes('export { render, staticRenderFns, recyclableRender, components }')) {
    return source
  }

  let declarations = ''
  if (!source.includes('recyclableRender')) {
    declarations += 'var recyclableRender;\n'
  } else if (!/var\s+recyclableRender|let\s+recyclableRender|const\s+recyclableRender/.test(source)) {
    declarations += 'var recyclableRender;\n'
  }
  if (!/var\s+components|let\s+components|const\s+components/.test(source)) {
    declarations += 'var components;\n'
  }

  return declarations + source
}
