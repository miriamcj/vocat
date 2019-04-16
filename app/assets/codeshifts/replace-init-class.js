module.exports = function(file, api) {
  const j = api.jscodeshift;
  const root = j(file.source);

  // change `static initClass() to constructor()`
  root
    .find(j.MethodDefinition)
    .filter(p => {
      return p.value.key.name === "initClass"
    })
    .forEach(p => {
      p.value.static = false;
      p.value.key.name = "constructor";
    });

  // Assign to constructor rather than prototype
  root
    .find(j.MemberExpression, { property: { name: "prototype" }})
    .forEach(p => {
      j(p).replaceWith(j.thisExpression());
    });

  return root.toSource({quote: 'double'});
};
