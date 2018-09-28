import { Validator } from 'vee-validate';
import upperFirst from 'lodash/upperFirst';
import camelCase from 'lodash/camelCase';

const requireValidator = require.context(
  // Look for files in the current directory
  '.',
  // Do not look in subdirectories
  false,
  // Anything with prefixed .vue files
  /[\w-]+\.js$/
);

requireValidator.keys().forEach(fileName => {
  // Skip this file, as it's not a validator
  if (fileName === './index.js') return;

  // Get the validator path as an array
  const validatorName = camelCase(
    fileName
      // Remove the file extension from the end
      .replace(/\.\w+$/, '')
  );

  const validatorModule = requireValidator(fileName);

  Validator.extend(validatorName, validatorModule.default || validatorModule);
});
