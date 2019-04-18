module.exports = function(file, api) {
  const j = api.jscodeshift;
  const root = j(file.source);

  // clean up `export default`
  root
    .find(j.ExportDefaultDeclaration)
    .forEach(p => {
      const body = cleanedExport(p.value.declaration);

      if (body) return j(p).replaceWith(body);
    });

  return root.toSource({quote: 'double'});

  /**
   * Clean up `export default`.
   * @param body - Function body AST (Array)
   */
  function cleanedExport(body) {
    const identifier = body.left.name;
    const { type, callee } = body.right;

    if (
      type !== "ClassExpression" && (
        type !== "CallExpression" ||
        callee.type !== "FunctionExpression"
      )
    ) return undefined;

    // assume structure is ```
    // export default Class = (function() {
    //   Class = class Class extends SuperClass // <= callee.body.body
    // })
    const exportBody =
      type === "ClassExpression"
        ? body.right
        : callee.body.body[0].expression.right;
    const newExportStatement = j.exportDeclaration(true, exportBody);

    return newExportStatement;
  }
};
