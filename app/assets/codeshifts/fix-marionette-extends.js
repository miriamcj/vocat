module.exports = function(file, api) {
  const j = api.jscodeshift;
  const root = j(file.source);

  const eligibleExports = root.find(j.ExportDefaultDeclaration, hasSuperClass);

  if (eligibleExports.__paths.length < 1) return;

  // transform superClass
  root
    .find(j.ExportDefaultDeclaration, hasSuperClass)
    .forEach(p => {
      const sup = p.value.declaration.superClass;

      let newSuper = undefined;

      if (sup.object) {
        const supClassName = sup.object.name;
        const supSubClassName = sup.property && sup.property.name;
        newSuper = transformSuperClass(supClassName, supSubClassName);
      } else {
        const supClassName = sup.name;
        newSuper = transformSuperClass(supClassName);
      }

      let extendsProperties = [];

      const constructorMethod = p.value.declaration.body.body[0];

      if (constructorMethod) {
        const properties = transformConstructor(constructorMethod.value.body.body);
        extendsProperties = [j.objectExpression(properties)];
      }

      p.value.declaration.superClass = j.callExpression(newSuper, extendsProperties);
    })

  // remove constructor
  root
    .find(j.MethodDefinition, isConstructor)
    .forEach(p => {
      return j(p).remove();
    });

  return root.toSource({quote: 'double'});

  function hasSuperClass(node) {
    return node.declaration.superClass && (
      node.declaration.superClass.property ||
      node.declaration.superClass.name
    );
  }

  function isConstructor(node) {
    return node.key.name === "constructor";
  };

  function transformSuperClass(supClass, supSubClass) {
    let newSuper = undefined;

    if (supSubClass) {
      newSuper = j.memberExpression(
        j.identifier(supClass), j.identifier(supSubClass)
      );
    } else {
      newSuper = j.identifier(supClass);
    }

    const newExtends = j.memberExpression(
      newSuper, j.identifier("extends")
    );

    return newExtends;
  }

  function transformConstructor(body) {
    let properties = [];

    body
      .filter(p => {
        if (p.expression && p.expression.callee && p.expression.callee.type === "Super") return false;
        return true;
      })
      .forEach(p => {
        if (!p.expression || !p.expression.left || !p.expression.left.property) return;
        const identifier = p.expression.left.property.name;
        const property = j.property("init", j.identifier(identifier), p.expression.right);
        properties.push(property);
      });

    return properties;
  }
};
