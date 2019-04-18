module.exports = function(file, api) {
  const j = api.jscodeshift;
  const root = j(file.source);
  const getFirstNode = () => root.find(j.Program).get('body', 0).node;

  // Save the comments attached to the first node
  const firstNode = getFirstNode();
  const { comments } = firstNode;

  // Create import declarations from array in `define()` (if exists)
  root
    .find(j.CallExpression, {callee: { name: 'define' }}) // find require() function calls
    .filter(p => {
      return (
        p.parentPath.parentPath.name === 'body' &&
        p.value.arguments[0].type === "ArrayExpression"
      );
    })
    .forEach(p => {
      const specifiers = p.value.arguments[1].params;

      let imports = [];
      specifiers.forEach((specifier, index) => {
        const source = p.value.arguments[0].elements[index];
        const importDeclaration = j.importDeclaration([j.importDefaultSpecifier(specifier)], source);
        imports.push(importDeclaration);
      });

      const existingImports = root.find(j.ImportDeclaration);
      if (existingImports.length) {
        j(existingImports.at(0).get()).insertBefore(...imports);
      } else {
        root.get().node.program.body.unshift(...imports);
      }
    });

  // Replace `return` with `export default`
  root
    .find(j.CallExpression, {callee: { name: 'define' }}) // find require() function calls
    .filter(p => {
      return p.parentPath.parentPath.name === 'body';
    })
    .forEach(p => {
      // get function expression of define() or define([])
      const definedFunction =
        p.value.arguments
          .filter(node => {
            return (
              node.type === "FunctionExpression" ||
              node.type === "ArrowFunctionExpression"
            );
          })
          .reduce((prev, current) => {
            return current;
          }, null);

      // convert `return` statement to `export default`
      if (definedFunction.type === "ArrowFunctionExpression") {
        return j(p).replaceWith(definedFunction.body);
      } else {
        const body = returnToExport(definedFunction.body.body);
        return j(p.parent).replaceWith(body);
      }
    });

    // If the first node has been modified or deleted, reattach the comments
    const firstNode2 = getFirstNode();
    if (firstNode2 !== firstNode) {
      firstNode2.comments = comments;
    };

  return root.toSource({quote: 'double'});

  /**
   * Convert a `return` to `export default`.
   * @param body - Function body AST (Array)
   */
  function returnToExport(body) {
    const possibleReturn =
      body
        .filter(node => {
          return node.type === 'ReturnStatement'
        })
        .reduce((prev, current) => {
          return current;
        }, null);

    if (!possibleReturn || body.indexOf(possibleReturn) === -1) return body;

    const exportStatement = j.exportDeclaration(true, possibleReturn.argument);
    body[body.indexOf(possibleReturn)] = exportStatement;

    return body;
  }
};
