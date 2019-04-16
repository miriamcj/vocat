module.exports = function(file, api) {
  const j = api.jscodeshift;
  const root = j(file.source);
  const getFirstNode = () => root.find(j.Program).get('body', 0).node;

  // Save the comments attached to the first node
  const firstNode = getFirstNode();
  const { comments } = firstNode;

  // get the name of the export class
  let exportDeclarations = [];
  root
    .find(j.ExportDefaultDeclaration)
    .forEach(p => {
      exportDeclarations.push(p.value.declaration);
    });

  const exportClassName =
    exportDeclarations[0].left
      ? exportDeclarations[0].left.name
      : exportDeclarations[0].name;

  // Remove leftover variable declaration at top of file
  root
    .find(j.VariableDeclaration, isExportClassVariable)
    .forEach(p => {
      j(p).remove();
    });

  // If the first node has been modified or deleted, reattach the comments
  const firstNode2 = getFirstNode();
  if (firstNode2 !== firstNode) {
    firstNode2.comments = comments;
  };

  return root.toSource({quote: 'double'});

  function isExportClassVariable(node) {
    return (
      node.kind === "let" &&
      node.declarations[0].id.name === exportClassName
    )
  }
};
