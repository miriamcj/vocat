import find from "lodash/find";

module.exports = function(file, api) {
  const j = api.jscodeshift;
  const root = j(file.source);

  const jqueryExpressions =
    root.find(j.CallExpression, isJqueryExpression);
  const jqueryIsUsed = jqueryExpressions.__paths.length;

  // Add import declaration if lodash methods exist
  // Later method will split into partial imports
  if (jqueryIsUsed) {
    const existingJqueryImports
      = root.find(j.ImportDeclaration, isJqueryImport);

    // do nothing if an import of `$` already exists
    if (existingJqueryImports.__paths.length) return null;

    const jqueryImport =
      j.importDeclaration(
        [j.importSpecifier(j.identifier("$"))],
        j.literal("jquery")
      );
    const existingImports = root.find(j.ImportDeclaration);
    existingImports.length
      ? j(existingImports.at(0).get()).insertAfter(jqueryImport)
      : root.get().node.program.body.unshift(jqueryImport);
  };

  return root.toSource({ quote: "double" });

  function isJqueryExpression(node) {
    return (
      node.type === "CallExpression" &&
      node.callee &&
      node.callee.name === "$"
    );
  }

  function isJqueryImport(node) {
    return find(node.specifiers, s => s.local.name === "$");
  }
};
