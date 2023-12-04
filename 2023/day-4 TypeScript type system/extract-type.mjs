#!/usr/bin/env node

// el: https://stackoverflow.com/a/67235137

import ts from "typescript";

/**
 * @param {string} fileName
 * @param {string} typeName
 *
 * @returns {string}
 */
function extractType(fileName, typeName) {
  const program = ts.createProgram([fileName], { emitDeclarationOnly: true });
  const sourceFile = program.getSourceFile(fileName);
  const typeChecker = program.getTypeChecker();
  const statement = sourceFile.statements.find((s) =>
    ts.isTypeAliasDeclaration(s) && s.name.text === typeName
  );
  if (!statement) {
    throw new Error(`Type ${typeName} not found in file "${fileName}"`);
  }
  const type = typeChecker.getTypeAtLocation(statement);
  return typeChecker.typeToString(type);
}

function main() {
  const argv = process.argv.slice(2);
  if (argv.length != 2) {
    console.error("usage: <this-program> xxx.ts TypeName");
    process.exit(1);
  }
  console.log(extractType(argv[0], argv[1]));
}

main();
